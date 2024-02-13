## How To Secure a Containerized Node.js Application with Nginx, Let's Encrypt, and Docker Compose

[github repo](https://github.com/do-community/nodejs-image-demo)

## Build and test node app
1. clone repo
    ```bash
    git clone https://github.com/do-community/nodejs-image-demo.git node_project

    cd node_project

    ```
2. Build image
    ```bash
    docker build -t node-demo .
    ```
3. Run node app
    ```bash
    docker run --name node-demo -p 80:8080 -d node-demo
    ```
4. Stop docker containers and prune
    ```bash
    docker stop container_id
    docker system prune -a
    ```
## Defining the Web Server Configuration

1. Create `nginx.conf` inside `nginx-conf` directory
    ```bash
    mkdir nginx-conf
    nano nginx-conf/nginx.conf
    ```
    **nginx.conf**
    ```bash
        server {
            listen 80;
            listen [::]:80;

            root /var/www/html;
            index index.html index.htm index.nginx-debian.html;

            server_name your_domain www.your_domain;

            location / {
                    proxy_pass http://nodejs:8080;
            }

            location ~ /.well-known/acme-challenge {
                    allow all;
                    root /var/www/html;
            }
        }
    ```
3. Creating the Docker Compose File
    ```bash
    nano docker-compose.yml
    ```
    ```bash
        version: '3'

        services:
          nodejs:
            build:
              context: .
              dockerfile: Dockerfile
            image: nodejs
            container_name: nodejs
            restart: unless-stopped
            networks:
              - app-network

          webserver:
            image: nginx:mainline-alpine
            container_name: webserver
            restart: unless-stopped
            ports:
              - "80:80"
            volumes:
              - web-root:/var/www/html
              - ./nginx-conf:/etc/nginx/conf.d
              - certbot-etc:/etc/letsencrypt
              - certbot-var:/var/lib/letsencrypt
            depends_on:
              - nodejs
            networks:
              - app-network

          certbot:
            image: certbot/certbot
            container_name: certbot
            volumes:
              - certbot-etc:/etc/letsencrypt
              - certbot-var:/var/lib/letsencrypt
              - web-root:/var/www/html
            depends_on:
              - webserver
            command: certonly --webroot --webroot-path=/var/www/html --email        sammy@your_domain --agree-tos --no-eff-email --staging -d your_domain  -d   www.your_domain 

        volumes:
          certbot-etc:
          certbot-var:
          web-root:
            driver: local
            driver_opts:
              type: none
              device: /home/sammy/node_project/views/
              o: bind

        networks:
          app-network:
            driver: bridge
    ```
### Obtaining SSL Certificates and Credentials
1. Start services
    ```bash
    docker-compose up -d
    ```
2. Check if the credentials have been loaded
    ```bash
    docker-compose exec webserver ls -la /etc/letsencrypt/live
    ```
    replace the `--staging` flag in the command option with the `--force-renewal` flag. This will tell Certbot that you want to request a new certificate with the same domains as an existing certificate.
3. Restart certbot
    ```bash
    docker-compose up --force-recreate --no-deps certbot
    ```
4. Modifying the Web Server Configuration and Service Definition
    ```bash
    docker-compose stop webserver
    ```


[Follow on ..](https://www.digitalocean.com/community/tutorials/how-to-secure-a-containerized-node-js-application-with-nginx-let-s-encrypt-and-docker-compose)
