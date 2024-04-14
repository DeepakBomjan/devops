# * Part 1 - Setup.
locals {
	container_name = "hello-world-container"
	frontend_container_port = 8080 # ! Must be same port from our Dockerfile that we EXPOSE
	backend_container_port = 3000
    example = "example-mern-app-ecs-terraform"
    mern-frontend-id = "cloudfront-ecs-demo-webapp-origin"
  
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "cloudfront-ecs-demo-webapp-origin"
}

}

# Load .env file content
locals {
  backend_env_content = file("${path.module}/.backend.env")
  mongodb_env_content = file("${path.module}/.mongodb.env")
}

# Parse .env content into a map of environment variables
locals {
  backend_env_vars = { for pair in split("\n", local.backend_env_content) : split("=", pair)[0] => split("=", pair)[1] if length(pair) > 0 }
  mongodb_env_vars = { for pair in split("\n", local.mongodb_env_content) : split("=", pair)[0] => split("=", pair)[1] if length(pair) > 0 }
}



provider "aws" {
	region = "us-east-1"

	default_tags {
		tags = { example = local.example }
	}
}

# Retrieve the default VPC ID
data "aws_vpc" "default" {
  default = true
}

# Retrieve the default subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Retrieve the default security group of the default VPC
data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}


data "aws_subnet" "default" {
  for_each = toset(data.aws_subnets.default.ids)
  id       = each.value
}


# Extract the subnet IDs as a list
locals {
  subnet_ids = values(data.aws_subnet.default)[*].id
}


# * Part 2 - Create application load balancer
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.4.0"

  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.default.id]
  subnets            = local.subnet_ids
  vpc_id             = data.aws_vpc.default.id

  security_group_rules = {
    ingress_all_http = {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "TCP"
      description = "HTTP web traffic"
      cidr_blocks = ["0.0.0.0/0"]
    }
    ingress_all_http_8000 = {  # Added rule for port 8000
      type        = "ingress"
      from_port   = 8000
      to_port     = 8000
      protocol    = "TCP"
      description = "HTTP backend traffic"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0  # Frontend target group
    },
    {
      port               = 8000  # New listener for backend
      protocol           = "HTTP"
      target_group_index = 1  # Backend target group
    },
  ]

  target_groups = [
    {
      backend_port     = local.frontend_container_port
      backend_protocol = "HTTP"
      target_type      = "ip"
    },
    {
      backend_port     = local.backend_container_port  # Backend port
      backend_protocol = "HTTP"
      target_type      = "ip"
    },
  ]
}

# * Setup EFS
resource "aws_efs_file_system" "mongodb_efs" {
  creation_token = "mongodb-efs"  # Unique name for your EFS file system

  tags = {
    Name = "MongoDB EFS"
  }
}

resource "aws_efs_mount_target" "mongodb_efs_mount" {
  count         = length(local.subnet_ids)  # Use all subnets where ECS tasks can run
  file_system_id = aws_efs_file_system.mongodb_efs.id
  subnet_id      = local.subnet_ids[count.index]
}

# * Setup ECR
# * Give Docker permission to push Docker Images to AWS.
data "aws_caller_identity" "this" {}

data "aws_ecr_authorization_token" "this" {}

data "aws_region" "this" {}

locals {
  ecr_address = format("%v.dkr.ecr.%v.amazonaws.com", data.aws_caller_identity.this.account_id, data.aws_region.this.name)
}

provider "docker" {
  registry_auth {
    address  = local.ecr_address
    password = data.aws_ecr_authorization_token.this.authorization_token
    username = "AWS"
  }
}

# * Part 2 - Build and push Docker images.

# * Create Amazon ECR repositories for backend and frontend.
resource "aws_ecr_repository" "mern_be_repository" {
  name = "mern-be"  # Name for the backend ECR repository
}

resource "aws_ecr_repository" "mern_fe_repository" {
  name = "mern-fe"  # Name for the frontend ECR repository
}

# Build and push the backend Docker image.
resource "docker_image" "mern_be_image" {
  name = "${aws_ecr_repository.mern_be_repository.repository_url}:${timestamp()}"
  build {
    context    = "./server"  # Path to the backend Dockerfile
    dockerfile = "./server/Dockerfile"  # Path to the backend Dockerfile
  }
}

# Push the backend Docker image to ECR.
resource "docker_registry_image" "mern_be_push" {
  name = docker_image.mern_be_image.name
  registry = aws_ecr_repository.mern_be_repository.repository_url
  build {
    context    = "./server"  # Path to the backend Dockerfile
    dockerfile = "./server/Dockerfile"  # Path to the backend Dockerfile
  }
  depends_on = [docker_image.mern_be_image]
}

# Build and push the frontend Docker image.
resource "docker_image" "mern_fe_image" {
  name = "${aws_ecr_repository.mern_fe_repository.repository_url}:${timestamp()}"
  build {
    context    = "./client"  # Path to the frontend Dockerfile
    dockerfile = "./client/Dockerfile"  # Path to the frontend Dockerfile
  }
}

# Push the frontend Docker image to ECR.
resource "docker_registry_image" "mern_fe_push" {
  name = docker_image.mern_fe_image.name
  registry = aws_ecr_repository.mern_fe_repository.repository_url
  build {
    context    = "./client"  # Path to the frontend Dockerfile
    dockerfile = "./client/Dockerfile"  # Path to the frontend Dockerfile
  }
  depends_on = [docker_image.mern_fe_image]
}


# * Step 5 - Create our ECS Cluster.
module "ecs" {
	source  = "terraform-aws-modules/ecs/aws"
	version = "~> 4.1.3"

	cluster_name = local.example

	# * Allocate 20% capacity to FARGATE and then split
	# * the remaining 80% capacity 50/50 between FARGATE
	# * and FARGATE_SPOT.
	fargate_capacity_providers = {
		FARGATE = {
			default_capacity_provider_strategy = {
				base   = 20
				weight = 50
			}
		}
		FARGATE_SPOT = {
			default_capacity_provider_strategy = {
				weight = 50
			}
		}
	}
}

# * Step 6 - Create our ECS Task Definition
data "aws_iam_policy_document" "this" {
	version = "2012-10-17"

	statement {
		actions = ["sts:AssumeRole"]
		effect = "Allow"

		principals {
			identifiers = ["ecs-tasks.amazonaws.com"]
			type = "Service"
		}
	}
}
resource "aws_iam_role" "this" { assume_role_policy = data.aws_iam_policy_document.this.json }
resource "aws_iam_role_policy_attachment" "this" {
	policy_arn  = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
	role = resource.aws_iam_role.this.name
}


resource "aws_ecs_task_definition" "mern_fe" {
  container_definitions = jsonencode([{
    environment = [
      { name = "API_URL", value = "http://mern-be:3000/api" }  # Assuming back-end service name is "mern-be"
    ],
    essential      = true,
    image          = "your-mern-fe-image",  # Replace with your MERN front-end image
    name           = "mern-fe-container",
    portMappings   = [{ containerPort = 3000 }],  # Assuming your front-end listens on port 3000
    log_configuration = {
      log_driver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/${local.example}/frontend"  # Adjust log group name as needed
        "awslogs-region"        = "us-east-1"  # Update with your region if different
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
  execution_role_arn     = aws_iam_role.this.arn
  family                 = "family-of-mern-fe-tasks"
  memory                 = 512
  network_mode           = "awsvpc"
  requires_compatibilities = ["FARGATE"]
}


resource "aws_ecs_task_definition" "mern_be" {
  container_definitions = jsonencode([{
    essential      = true,
    image          = "your-mern-be-image",  # Replace with your MERN back-end image
    name           = "mern-be-container",
    portMappings   = [{ containerPort = 5000 }],  # Assuming your back-end listens on port 5000
    # environment    = [
    #   { name = "PORT", value = "3000" },
    #   { name = "MONGO_URI", value = "mongodb://127.0.0.1:27017/mern_ecommerce" },
    #   { name = "JWT_SECRET", value = "" },  # Add your actual JWT_SECRET value here
    #   { name = "MAILCHIMP_KEY", value = "" },  # Add your actual MAILCHIMP_KEY value here
    #   { name = "MAILCHIMP_LIST_KEY", value = "" },  # Add your actual MAILCHIMP_LIST_KEY value here
    #   { name = "MAILGUN_KEY", value = "" },  # Add your actual MAILGUN_KEY value here
    #   { name = "MAILGUN_DOMAIN", value = "" },  # Add your actual MAILGUN_DOMAIN value here
    #   { name = "MAILGUN_EMAIL_SENDER", value = "" },  # Add your actual MAILGUN_EMAIL_SENDER value here
    #   { name = "GOOGLE_CLIENT_ID", value = "" },  # Add your actual GOOGLE_CLIENT_ID value here
    #   { name = "GOOGLE_CLIENT_SECRET", value = "" },  # Add your actual GOOGLE_CLIENT_SECRET value here
    #   { name = "GOOGLE_CALLBACK_URL", value = "http://localhost:3000/api/auth/google/callback" },
    #   { name = "FACEBOOK_CLIENT_ID", value = "" },  # Add your actual FACEBOOK_CLIENT_ID value here
    #   { name = "FACEBOOK_CLIENT_SECRET", value = "" },  # Add your actual FACEBOOK_CLIENT_SECRET value here
    #   { name = "FACEBOOK_CALLBACK_URL", value = "http://localhost:3000/api/auth/facebook/callback" },
    #   { name = "CLIENT_URL", value = "http://localhost:8080" },
    #   { name = "BASE_API_URL", value = "api" },
    #   { name = "AWS_ACCESS_KEY_ID", value = "" },  # Add your actual AWS_ACCESS_KEY_ID value here
    #   { name = "AWS_SECRET_ACCESS_KEY", value = "" },  # Add your actual AWS_SECRET_ACCESS_KEY value here
    #   { name = "AWS_REGION", value = "us-east-2" },
    #   { name = "AWS_BUCKET_NAME", value = "" },  # Add your actual AWS_BUCKET_NAME value here
    # ],
    environment    = [
        { for key, value in local.env_vars_backend : key => value }  # Use environment variables from .env file
      ],
    log_configuration = {
      log_driver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/${local.example}/backend"  # Adjust log group name as needed
        "awslogs-region"        = "us-east-1"  # Update with your region if different
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
  execution_role_arn     = aws_iam_role.this.arn
  family                 = "family-of-mern-be-tasks"
  memory                 = 512
  network_mode           = "awsvpc"
  requires_compatibilities = ["FARGATE"]
}

resource "aws_ecs_task_definition" "mongodb" {
  container_definitions = jsonencode([{
    essential      = true,
    image          = "your-custom-mongodb-image:tag",  # Use your custom MongoDB image and tag
    name           = "mongodb-container",
    portMappings   = [{ containerPort = 27017 }],  # Assuming MongoDB listens on port 27017
    log_configuration = {
      log_driver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/${local.example}/mongodb"  # Adjust log group name as needed
        "awslogs-region"        = "us-east-1"  # Update with your region if different
        "awslogs-stream-prefix" = "ecs"
      }
    },
    # environment = [
    #   { name = "MONGO_INITDB_ROOT_USERNAME", value = "admin" },
    #   { name = "MONGO_INITDB_ROOT_PASSWORD", value = "changeme" },
    #   { name = "MONGO_INITDB_DATABASE", value = "mern" }
    # ],
    environment    = [
        { for key, value in local.mongodb_env_vars : key => value }  # Use MongoDB environment variables from mongodb.env file
      ],
    mountPoints = [
      {
        sourceVolume = "mongodb-data",  # Name of your volume
        containerPath = "/data/db",     # MongoDB data directory in the container
        readOnly = false
      }
    ]
  }])
  execution_role_arn     = aws_iam_role.this.arn
  family                 = "family-of-mongodb-tasks"
  memory                 = 512
  network_mode           = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  volume {
    name = "mongodb-data"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.mongodb_efs.id
      transit_encryption = "ENABLED"
    }
  }
}



# Step 6 - Create ECS Autoscaling Policy
# Create ECS service autoscaling policy for frontend
resource "aws_appautoscaling_policy" "mern_fe_autoscale_policy" {
  name               = "${local.example}-fe-autoscale-policy"
  service_namespace  = "ecs"
  scalable_dimension = "ecs:service:DesiredCount"
  resource_id        = "service/${module.ecs.cluster_name}/${aws_ecs_service.mern_fe_service.name}"
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value = 70  # Target CPU utilization percentage
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

# Create ECS service scalable target for frontend autoscaling
resource "aws_appautoscaling_target" "mern_fe_scalable_target" {
  max_capacity       = 5  # Maximum desired count for autoscaling
  min_capacity       = 1  # Minimum desired count for autoscaling
  resource_id        = "service/${module.ecs.cluster_name}/${aws_ecs_service.mern_fe_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


# Create ECS service autoscaling policy for backend
resource "aws_appautoscaling_policy" "mern_be_autoscale_policy" {
  name               = "${local.example}-be-autoscale-policy"
  service_namespace  = "ecs"
  scalable_dimension = "ecs:service:DesiredCount"
  resource_id        = "service/${module.ecs.cluster_name}/${aws_ecs_service.mern_be_service.name}"
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value = 70  # Target CPU utilization percentage
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

# Create ECS service scalable target for backend autoscaling
resource "aws_appautoscaling_target" "mern_be_scalable_target" {
  max_capacity       = 5  # Maximum desired count for autoscaling
  min_capacity       = 1  # Minimum desired count for autoscaling
  resource_id        = "service/${module.ecs.cluster_name}/${aws_ecs_service.mern_be_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}




# * Step 7 - Run our application.
# Create ECS service for the frontend task
resource "aws_ecs_service" "mern_fe_service" {
  name            = "${local.example}-frontend-service"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.mern_fe.arn
  desired_count   = 2  # Adjust as needed
  launch_type     = "FARGATE"  # Assuming Fargate launch type

  load_balancer {
    target_group_arn = module.alb.target_group_arns[0]
    container_name   = "mern-fe-container"
    container_port   = 3000  # Adjust based on your container configuration
  }

  network_configuration {
    security_groups = [data.aws_security_group.default.id]
    subnets         = local.subnet_ids
    assign_public_ip = true  # Adjust as needed
  }
}

# Create ECS service for the backend task
resource "aws_ecs_service" "mern_be_service" {
  name            = "${local.example}-backend-service"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.mern_be.arn
  desired_count   = 2  # Adjust as needed
  launch_type     = "FARGATE"  # Assuming Fargate launch type

  load_balancer {
    target_group_arn = module.alb.target_group_arns[1]
    container_name   = "mern-be-container"
    container_port   = 5000  # Adjust based on your container configuration
  }

  network_configuration {
    security_groups = [data.aws_security_group.default.id]
    subnets         = local.subnet_ids
    assign_public_ip = true  # Adjust as needed
  }
}

# Create ECS service for the MongoDB task
resource "aws_ecs_service" "mongodb_service" {
  name            = "${local.example}-mongodb-service"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.mongodb.arn
  desired_count   = 1  # Assuming single instance for MongoDB
  launch_type     = "FARGATE"  # Assuming Fargate launch type

  network_configuration {
    security_groups = [data.aws_security_group.default.id]
    subnets         = local.subnet_ids
    assign_public_ip = true  # Adjust as needed
  }
}

# Create CloudFront distribution for the frontend

resource "aws_cloudfront_distribution" "cf_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "cloudfront-ecs-demo-webapp"
  origin {
    domain_name = module.alb.lb_dns_name
    origin_id   = local.mern-frontend-id
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.mern-frontend-id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }


  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE", "IN", "IR"]
    }
  }

  tags = {
    Environment = "development"
    Name        = "example-mern-app"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

output "cloudfront_dns" {
  value = aws_cloudfront_distribution.cf_distribution.domain_name
}


# Output the CloudFront distribution domain name
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.frontend_distribution.domain_name
}



# * Step 8 - See our application working.
# * Output the URL of our Application Load Balancer so that we can connect to
# * our application running inside  ECS once it is up and running.
output "lb_url" { value = "http://${module.alb.lb_dns_name}" }
# Output
# output "subnets_out" {
#   value = data.aws_subnet.default
# }

# output "subnet_cidr_blocks" {
#   value = [for s in data.aws_subnet.default : s.cidr_block]
# }

### References
### https://github.com/1Mill/example-terraform-ecs
