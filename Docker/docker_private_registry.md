To create a local Docker registry, you'll need to set up a Docker Registry container on your local machine. Docker Registry is an open-source server-side application that can store and distribute Docker images.

Here's a step-by-step guide to set up a local Docker registry:

### Step 1: Install Docker
Make sure Docker is installed on your machine. You can download and install Docker from [here](https://www.docker.com/get-started).

### Step 2: Run Docker Registry Container
You can run a Docker Registry container using the `docker run` command. Open a terminal and run the following command:

```sh
docker run -d -p 5000:5000 --name local-registry registry:2
```

This command does the following:
- `-d` runs the container in detached mode.
- `-p 5000:5000` maps port 5000 on your host to port 5000 in the container.
- `--name local-registry` gives the container a name for easier management.
- `registry:2` specifies the Docker Registry image to use (version 2).

### Step 3: Verify the Registry is Running
To verify that the registry is running, you can use the `docker ps` command to list the running containers:

```sh
docker ps
```

You should see the `local-registry` container listed.

### Step 4: Push an Image to Your Local Registry
First, tag an image with the local registry's address. For example, let's tag the `hello-world` image:

```sh
docker tag hello-world localhost:5000/hello-world
```

Now, push the tagged image to your local registry:

```sh
docker push localhost:5000/hello-world
```

### Step 5: Pull an Image from Your Local Registry
To pull the image from your local registry, use the following command:

```sh
docker pull localhost:5000/hello-world
```

### Step 6: Configuring Docker Daemon (Optional)
If you want to access the local registry without specifying `localhost:5000`, you can configure Docker daemon to recognize the local registry as an insecure registry.

Edit the Docker daemon configuration file (`daemon.json`). On Linux, this file is usually located at `/etc/docker/daemon.json`. On Windows and Mac, it can be accessed through Docker Desktop settings.

Add the following configuration:

```json
{
  "insecure-registries": ["localhost:5000"]
}
```

After editing the file, restart Docker to apply the changes:

```sh
sudo systemctl restart docker  # For Linux
```

For Docker Desktop on Windows/Mac, restart Docker from the Docker Desktop interface.

### Summary
By following these steps, you have set up a local Docker registry and learned how to push and pull images to and from the registry. This setup is useful for local development and testing purposes.

To access your local Docker registry from another machine on the same network, follow these steps:

### Step 1: Find the Host Machine's IP Address
On the machine where the Docker registry is running, find its local IP address. You can do this by running:

```sh
ifconfig  # On Linux or macOS
ipconfig  # On Windows
```

Look for the IP address of the network interface that is connected to your local network (e.g., `192.168.1.100`).

### Step 2: Tag and Push Docker Image from Another Machine
On the other machine, tag the Docker image with the IP address of the host machine. For example, if the host machine's IP address is `192.168.1.100`, you would tag the `hello-world` image as follows:

```sh
docker tag hello-world 192.168.1.100:5000/hello-world
```

Then, push the image to the registry:

```sh
docker push 192.168.1.100:5000/hello-world
```

### Step 3: Pull Docker Image from Another Machine
To pull the image from the registry on the other machine, use the following command:

```sh
docker pull 192.168.1.100:5000/hello-world
```

### Step 4: Configure Docker Daemon for Insecure Registry
Docker, by default, only allows connections to secure registries (those using HTTPS). To connect to an insecure registry (using HTTP), you need to configure the Docker daemon on the other machine.

Edit the Docker daemon configuration file (`daemon.json`) on the other machine. This file is usually located at `/etc/docker/daemon.json` on Linux. On Windows and macOS, it can be accessed through Docker Desktop settings.

Add the following configuration:

```json
{
  "insecure-registries": ["192.168.1.100:5000"]
}
```

### Restart Docker
After editing the file, restart Docker to apply the changes:

```sh
sudo systemctl restart docker  # For Linux
```

For Docker Desktop on Windows and macOS, restart Docker from the Docker Desktop interface.

### Firewall and Network Considerations
Ensure that there are no firewall rules blocking access to port `5000` on the host machine. You might need to open this port in your firewall settings.

### Summary
By following these steps, you can access your local Docker registry from another machine on the same network. This setup is useful for sharing Docker images between multiple machines in a local development environment.

To get a list of images stored in your local Docker registry, you can use the Docker Registry HTTP API. Here’s how you can do it:

### Step 1: Query the Registry API
The Docker Registry HTTP API allows you to interact with your Docker registry. To list all repositories (images) in your registry, you can use the following API endpoint:

```sh
curl http://<registry-ip>:5000/v2/_catalog
```

Replace `<registry-ip>` with the IP address or hostname of your Docker registry (e.g., `localhost` if you are running the command on the same machine).

### Step 2: Example
If your registry is running on `localhost`, you would run:

```sh
curl http://localhost:5000/v2/_catalog
```

The response will be in JSON format and will look something like this:

```json
{
  "repositories": [
    "hello-world",
    "another-repo"
  ]
}
```

### Step 3: List Tags for a Specific Repository
To list all tags for a specific repository, use the following endpoint:

```sh
curl http://<registry-ip>:5000/v2/<repository-name>/tags/list
```

For example, to list the tags for the `hello-world` repository, run:

```sh
curl http://localhost:5000/v2/hello-world/tags/list
```

The response will be:

```json
{
  "name": "hello-world",
  "tags": [
    "latest",
    "v1.0"
  ]
}
```

### Step 4: Automate with a Script (Optional)
You can automate the process of listing all images and their tags with a simple script. Here's an example using `bash`:

```bash
#!/bin/bash

REGISTRY_URL="http://localhost:5000"

# Get the list of repositories
REPOS=$(curl -s ${REGISTRY_URL}/v2/_catalog | jq -r '.repositories[]')

# Loop through each repository and list tags
for REPO in ${REPOS}; do
  echo "Repository: ${REPO}"
  TAGS=$(curl -s ${REGISTRY_URL}/v2/${REPO}/tags/list | jq -r '.tags[]')
  for TAG in ${TAGS}; do
    echo "  Tag: ${TAG}"
  done
done
```

### Prerequisites for the Script
- Install `jq` for parsing JSON. You can install `jq` using your package manager:
  - For Debian/Ubuntu: `sudo apt-get install jq`
  - For macOS: `brew install jq`
  - For Windows: Download the executable from the [jq website](https://stedolan.github.io/jq/).

### Running the Script
Make the script executable and run it:

```sh
chmod +x list_registry_images.sh
./list_registry_images.sh
```

This script will list all repositories and their respective tags in your local Docker registry.

### Summary
By using the Docker Registry HTTP API, you can easily list all images and their tags stored in your local Docker registry. This can be done manually using `curl` or automated with a script for convenience.
Setting up a Docker registry with private authentication using NGINX as a reverse proxy provides added flexibility and security features. Here’s how you can achieve this:

### Step 1: Install Docker and NGINX
Ensure Docker is installed on your machine. You can download and install Docker from [here](https://www.docker.com/get-started).

### Step 2: Create Authentication File
Install `htpasswd`:

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
htpasswd -Bc auth/htpasswd <username>
```

Replace `<username>` with your desired username. You’ll be prompted to enter and confirm a password.

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
    server_name <registry-ip>;

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

Make sure to replace `<registry-ip>` with the IP address or hostname of your registry server. You will also need to provide your own SSL certificate and key (`domain.crt` and `domain.key`).

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
docker login <registry-ip>
```

Replace `<registry-ip>` with the IP address or hostname of your registry server. Enter the username and password you set up earlier.

#### Option 2: Configure Docker Daemon for Insecure Registry (if using HTTP)
If you are using HTTP instead of HTTPS, configure Docker to treat it as an insecure registry.

Edit the Docker daemon configuration file (`daemon.json`):

```json
{
  "insecure-registries": ["<registry-ip>"]
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
docker tag hello-world <registry-ip>/hello-world
docker push <registry-ip>/hello-world
```

Pull the image from the registry:

```sh
docker pull <registry-ip>/hello-world
```

### Summary
By following these steps, you set up a Docker registry with private authentication using NGINX as a reverse proxy. This setup leverages NGINX for authentication and SSL termination, enhancing security and flexibility.
