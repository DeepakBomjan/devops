To set up a Docker registry with HTTP basic authentication using `htpasswd` and NGINX, follow these steps:

### Step 1: Install Docker
Ensure Docker is installed on your machine. You can download and install Docker from [here](https://www.docker.com/get-started).

### Step 2: Create Authentication File
Install `htpasswd` (part of `apache2-utils` on Debian/Ubuntu or `httpd-tools` on Red Hat/CentOS).

For Debian/Ubuntu:

```sh
sudo apt-get update
sudo apt-get install apache2-utils
```

For Red Hat/CentOS:

```sh
sudo yum install httpd-tools
```

Create a directory to store the authentication file:

```sh
mkdir -p auth
```

Create the `htpasswd` file with a user:

```sh
htpasswd -Bc auth/htpasswd myuser
```

You’ll be prompted to enter and confirm a password.

### Step 3: Create Docker Registry Container
Create a directory to store Docker registry data:

```sh
mkdir -p /data/registry
```

Run the Docker registry container:

```sh
docker run -d \
  --name registry \
  -v /data/registry:/var/lib/registry \
  registry:2
```

### Step 4: Configure NGINX
Create a directory for NGINX configuration and SSL certificates:

```sh
mkdir -p /etc/nginx/certs /etc/nginx/conf.d
```

Create an NGINX configuration file (`/etc/nginx/conf.d/registry.conf`):

```sh
cat <<EOF > /etc/nginx/conf.d/registry.conf
server {
    listen 443 ssl;
    server_name localhost;

    ssl_certificate /etc/nginx/certs/domain.crt;
    ssl_certificate_key /etc/nginx/certs/domain.key;

    # Disable any limits to avoid HTTP 413 for large image uploads
    client_max_body_size 0;

    # Basic auth
    auth_basic "Docker Registry";
    auth_basic_user_file /etc/nginx/auth/htpasswd;

    location / {
        proxy_pass http://registry:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_read_timeout 900;
    }
}
EOF
```

Generate SSL certificates (self-signed for testing purposes):

```sh
openssl req -newkey rsa:4096 -nodes -sha256 -keyout /etc/nginx/certs/domain.key -x509 -days 365 -out /etc/nginx/certs/domain.crt
```

### Step 5: Run NGINX Container
Run the NGINX container with the necessary volumes:

```sh
docker run -d \
  --name nginx \
  -p 443:443 \
  --link registry:registry \
  -v /etc/nginx/conf.d:/etc/nginx/conf.d:ro \
  -v /etc/nginx/certs:/etc/nginx/certs:ro \
  -v $(pwd)/auth:/etc/nginx/auth:ro \
  nginx:latest
```

### Step 6: Configure Docker Clients
Docker clients need to be configured to interact with the authenticated registry.

#### Option 1: Login to the Registry
On each client machine, log in to the registry:

```sh
docker login localhost
```

Enter the username (`myuser`) and the password you set up earlier.

#### Option 2: Configure Docker Daemon for Insecure Registry (if using HTTP)
If you are using HTTP instead of HTTPS, configure Docker to treat it as an insecure registry.

Edit the Docker daemon configuration file (`daemon.json`):

```json
{
  "insecure-registries": ["localhost"]
}
```

Restart Docker:

```sh
sudo systemctl restart docker  # For Linux
```

For Docker Desktop on Windows and macOS, restart Docker from the Docker Desktop interface.

### Step 7: Push and Pull Images
Tag an image with the registry's address and push it:

```sh
docker tag hello-world localhost/hello-world
docker push localhost/hello-world
```

Pull the image from the registry:

```sh
docker pull localhost/hello-world
```

### Summary
By following these steps, you have set up a Docker registry with HTTP basic authentication using `htpasswd` and NGINX. This configuration enhances the security of your Docker registry by requiring authentication for pushing and pulling images.
