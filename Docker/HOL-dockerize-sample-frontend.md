## Dockerize React applications with Nginx

### Sample App
```bash
git clone https://github.com/wingkwong/react-quiz-form.git
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