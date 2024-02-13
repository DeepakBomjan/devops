## How to Set Up letsencrypt with Nginx on Docker
1. Create Directory
    ```bash
    sudo mkdir letsencrypt && cd letsencrypt
    ```

2. Create Docker Compose File
    ```bash
    nano docker-compose.yml
    ```
    Next, paste the following code into the file:
    ```bash
    version: '3'
    services:
      webserver:
        image: nginx:latest
        ports:
          - 80:80
          - 443:443
        restart: always
        volumes:
          - ./nginx/conf/:/etc/nginx/conf.d/:ro
          - ./certbot/www/:/var/www/certbot/:ro
      certbot:
        image: certbot/certbot:latest
        volumes:
          - ./certbot/www/:/var/www/certbot/:rw
          - ./certbot/conf/:/etc/letsencrypt/:rw
    ```

3. Create Configuration File
    ```bash
    sudo nano /etc/nginx/conf.d/app.conf
    ```
    Copy and paste the code below, replacing [domain-name] with your actual domain name:

    ```bash
        server {
        listen 80;
        listen [::]:80;
        server_name [domain-name] www.[domain-name];
        server_tokens off;
        location /.well-known/acme-challenge/ {
            root /var/www/certbot;
        }
        location / {
            return 301 https://[domain-name]$request_uri;
        }
    }
    ```
4. Run Certbot
    Dry run first
    ```bash
    docker-compose run --rm certbot certonly --webroot --webroot-path /var/www/certbot/ --dry-run -d [domain-name]
    ```

    ```bash
    docker-compose run --rm certbot certonly --webroot --webroot-path /var/www/certbot/ -d [domain-name]
    ```
5. Add HTTPS to Nginx Configuration File
    1. Open the configuration file:
        ```bash
        sudo nano /etc/nginx/conf.d/app.conf
        ```
    2. Add the following server block to the end of the file. Replace [domain-name] with your actual domain name.
        ```bash
        server {
            listen 443 default_server ssl http2;
            listen [::]:443 ssl http2;
            server_name [domain-name];
            ssl_certificate /etc/nginx/ssl/live/[domain-name]/fullchain.pem;
            ssl_certificate_key /etc/nginx/ssl/live/[domain-name]/privkey.pem;
            location / {
            	proxy_pass http://[domain-name];
            }
        }
        ```
    3. Reload Nginx
        ```bash
        docker-compose restart
        ```
        or
        ```bash
        docker-compose exec webserver nginx -s reload
        ```
6. Renew Certificates
    ```bash
    docker-compose run --rm certbot renew
    ```

## References
[lenscrypt with nginx on docker](https://phoenixnap.com/kb/letsencrypt-docker)