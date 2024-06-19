Certainly! Docker networking can be quite extensive, but I’ll provide an example that covers the basics of creating a custom network and connecting multiple containers to it so they can communicate with each other.

### Step-by-Step Example

Let's create a Docker network and run a simple setup where one container runs a web server (e.g., Nginx) and another container runs a client (e.g., curl) to access the server.

#### 1. Create a Custom Docker Network

First, create a custom Docker network. This allows containers to communicate with each other easily.

```bash
docker network create my_custom_network
```

#### 2. Run an Nginx Container

Next, run an Nginx container and connect it to the custom network.

```bash
docker run -d --name my_nginx --network my_custom_network nginx
```

#### 3. Run a Curl Container to Access the Nginx Container

Now, run a curl container on the same network to test connectivity to the Nginx container.

```bash
docker run --rm --network my_custom_network curlimages/curl:latest curl -I http://my_nginx
```

#### Explanation

- `docker network create my_custom_network`: Creates a custom network named `my_custom_network`.
- `docker run -d --name my_nginx --network my_custom_network nginx`: Runs an Nginx container named `my_nginx` connected to `my_custom_network`.
- `docker run --rm --network my_custom_network curlimages/curl:latest curl -I http://my_nginx`: Runs a curl container on the `my_custom_network` network to make an HTTP request to the `my_nginx` container.

### Advanced Example: Docker Compose

For more complex setups, Docker Compose can be used to manage multi-container applications. Here’s an example of how to set this up using a `docker-compose.yml` file.

#### `docker-compose.yml`

```yaml
version: '3'
services:
  web:
    image: nginx
    networks:
      - my_custom_network

  client:
    image: curlimages/curl:latest
    networks:
      - my_custom_network
    command: ["sh", "-c", "while true; do curl -I http://web; sleep 5; done"]

networks:
  my_custom_network:
```

#### Steps to Run

1. Create a file named `docker-compose.yml` and paste the above content into it.
2. Run the following command in the directory containing `docker-compose.yml`:

```bash
docker-compose up
```

#### Explanation

- `version: '3'`: Specifies the version of the Docker Compose file format.
- `services`: Defines the two services, `web` (running Nginx) and `client` (running curl).
- `networks`: Specifies the custom network (`my_custom_network`) that both services will use.

With this setup, Docker Compose creates the network, runs the containers, and ensures they can communicate with each other. The curl container will continuously send HTTP requests to the Nginx container.

This example should give you a good starting point for using Docker networks to enable communication between containers.
