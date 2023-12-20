## Dockerize React applications with Nginx

### Sample App
```bash
git clone https://github.com/wingkwong/react-quiz-form.git
git clone https://github.com/md-kawsar-ali/React-Quiz-App
```

### Nginx conf file
```bash
server {
    listen 80;
    location / {
        root /usr/share/nginx/html;
        index index.html index.htm;
        try_files $uri $uri/ /index.html =404;
        proxy_pass http://localhost:3000;
    }
}
```

### Dockerfile
```bash
# build environment
FROM node:alpine as build
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

# production environment
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY --from=build /app/nginx/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```


### Optimized Dockerfile
```bash
FROM node:18 as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### .dockerignore
```bash
node_modules
build
npm-debug.log
```

### Share Docker images

```bash
# Login to Docker Hub
docker login --username foo
docker push
```


## Debugged Dockerfile

### Nginx conf
```bash
server {
    listen       80;
    server_name  localhost;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
        try_files $uri.html $uri $uri/ /index.html;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
```

### Dockerfile

```bash
FROM nginx:alpine
COPY build /usr/share/nginx/html
COPY nginx/default.conf /etc/nginx/conf.d/
```


```bash
# build environment
FROM node:alpine as build
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

# production environment
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY --from=build /app/nginx/default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

## Docker single stage build
```bash
# Single-stage build with Alpine base image
FROM alpine

# Install Node.js and npm
RUN apk add --no-cache nodejs npm

WORKDIR /app

# Copy the application source code
COPY . .

# Install dependencies and build
RUN npm install && npm run build

# Install Nginx
RUN apk add --no-cache nginx

# Copy the built files to Nginx web root
RUN cp -r /app/build /usr/share/nginx/html

# Copy Nginx configuration
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

# Expose port 80 for the Nginx server
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
```

## Docker optimized multi-stage build
```bash
# build environment
FROM node:alpine as build
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

# production environment
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY --from=build /app/nginx/default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```


## Using docker-compose file
```bash
version: '3'

services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
    volumes:
      - ./nginx-config:/etc/nginx/conf.d
    restart: always
    networks:
      - mynetwork

networks:
  mynetwork:
    driver: bridge

```