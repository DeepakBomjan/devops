provider "aws" {
  region = "us-east-1" # Change this to your desired AWS region
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "subnets" {
  type    = list(string)
  default = ["subnet-0641a726ae103c990"]
}

variable "root_ssh_pub_key" {
  type    = string
  default = ""
}

variable "instance_count" {
  type    = number
  default = 5
}

resource "aws_security_group" "hol-machine" {
  name        = "hol-machine-sg"
  description = "Security group for HOL instances"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_file" "init_script" {
  template = file("user-data.sh")
}

resource "aws_key_pair" "hol_user_key" {
  key_name   = "hol_user_key"
  public_key = file("./id_rsa.pub")
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/*20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

data "aws_ami" "rhel" {
  most_recent = true
  owners      = ["309956199498"]
  filter {
    name   = "name"
    values = ["RHEL-9.*"]
  }
}

resource "aws_instance" "hol-machine" {
  count                  = var.instance_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.medium"
  key_name               = "hol_user_key"
  subnet_id              = element(var.subnets, count.index % length(var.subnets))
  vpc_security_group_ids = [aws_security_group.hol-machine.id]

  tags = {
    Name    = "hol-machine-${count.index + 1}"
    Project = "DevOps"
    Environment = "Testing"
  }

  user_data = data.template_file.init_script.rendered
}

output "public_ips" {
  value = aws_instance.hol-machine[*].public_ip
}

output "private_ips" {
  value = aws_instance.hol-machine[*].private_ip
}
