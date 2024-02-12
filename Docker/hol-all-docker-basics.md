## Example 1
1. Dockerfile
```bash
FROM nginx:alpine

COPY default.conf /etc/nginx/conf.d/
COPY index.html /usr/share/nginx/html/
```
2. default.conf
```bash
server {
    listen       80;
    server_name  localhost;
    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
    ssi on;
}
```
3. index.html
```bash
<!doctype html>
<html>
    <head>
        <meta charset="utf-8">
        <title>My wonderful website</title>
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>
        <h1>Welcome to my wonderful website</h1>
        <p>You will never find another place as cool as this</p>
        <p><img src="img/bridge.jpg" alt="A nice picture of The Bridge"/></p>
    </body>
</html>
```

## Example 2
Building and Exporting a Docker Image to Deploy a Static Website with Apache Web Server
1. Set Up the Base Apache Docker Image
```bash
sudo docker image pull httpd:latest
```
2. Run the Container in Detached Mode
```bash
sudo docker run -d --name web-mania -p 8080:80 httpd
```
```bash
sudo docker ps
```

3. Start an Interactive Terminal to Access the Created Container
```bash
sudo docker container exec -it web-mania /bin/bash
```
Install vi or nano
```bash
apt-get update;apt-get install nano
```
4. Create the index.html File
```bash
nano /usr/local/apache2/htdocs/index.html
```
Content
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Web-Mania!!!</title>
</head>
<body>
    <h1>This is a test landing page for the created docker image</h1>
</body>
</html>
```

5. Test the Created Apache Static Website
```bash
 http://127.0.0.1:8080/index.html

```

6. Create a Custom Docker Image from the Created Container
```bash
sudo docker commit web-mania
```
```bash
sudo docker images
```
```bash
sudo docker image tag c9917b2064a6 docker-mania-apache:1.0
```

This created image can then be exported and distributed as needed by using the docker save command

```bash
sudo docker save docker-mania-apache:1.0 | gzip > docker-mania-apache.tar.gz
```

## Example 3

## Connect various databases

### MySQL
1. Pull image
```bash
docker pull mysql/mysql-server:8.0.28
```
2. Start MySQL container
```bash
docker run --name='my_sql_container' -d -p 3306:3306 mysql/mysql-server
```
3. check container
```bash
docker ps
```
4. Check Logs
```bash
docker logs my_sql_container
```
5. Exec into container
```bash
docker exec -it my_sql_container bash
```

6. Install psql
```bash
sudo apt install mysql-client

```

7. Connect MySQL
```bash
cd /var/lib/mysql
mysql -u root -p
```
```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'newpassword';
use mysql;
select user from user;

```
8. Create a user for connection
```sql
CREATE USER 'dbeaver'@'%' IDENTIFIED BY 'dbeaver';
GRANT ALL PRIVILEGES ON *.* TO 'dbeaver'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```
### Postgres
1. Start postgres
```bash
docker pull postgres

```
```bash
docker run --name my_postgres -e POSTGRES_PASSWORD=mysecretpassword -d -p 5432:5432 postgres

```
2. Install client
```bash
sudo apt install postgresql-client

```
3. Access PostgreSQL
```bash
psql -h localhost -p 5432 -U postgres
```

### Mongodb
1. Pull mongodb
```bash
docker pull mongo

```
2. Run mongodb
```bash
docker run --name my_mongodb -d -p 27017:27017 mongo

```

### Running database with volume

```bash
# PostgreSQL with Volume
docker run --name postgres_container -e POSTGRES_PASSWORD=mysecretpassword -d -p 5432:5432 -v /path/to/postgres_data:/var/lib/postgresql/data postgres

# MySQL with Volume
docker run --name mysql_container -e MYSQL_ROOT_PASSWORD=mysecretpassword -d -p 3306:3306 -v /path/to/mysql_data:/var/lib/mysql mysql

# MongoDB with Volume
docker run --name mongo_container -d -p 27017:27017 -v /path/to/mongo_data:/data/db mongo

```
### Running database in separate network
1. Create Docker Networks
```bash
docker network create postgres_network
docker network create mysql_network
docker network create mongo_network

```
2. Start databses
```bash
# Start PostgreSQL in the `postgres_network`:
docker run --name postgres_container --network postgres_network -e POSTGRES_PASSWORD=mysecretpassword -d -p 5432:5432 postgres

# Start MySQL in the `mysql_network`
docker run --name mysql_container --network mysql_network -e MYSQL_ROOT_PASSWORD=mysecretpassword -d -p 3306:3306 mysql

# Start MongoDB in the `mongo_network`:
docker run --name mongo_container --network mongo_network -d -p 27017:27017 mongo

```

## Example 4

### Postgress DB Initialization scripts
init.sql
```sql
create table sometable(id int);
```
```bash
docker run -v ./init.sql:/docker-entrypoint-initdb.d/init.sql p 5432:5432 postgres
```

_**More**_..

```sql
CREATE USER docker;
CREATE DATABASE docker;
GRANT ALL PRIVILEGES ON DATABASE docker TO docker;
```
Dockerfile
```bash
FROM library/postgres
COPY init.sql /docker-entrypoint-initdb.d/
```

Run
```bash
docker run -e POSTGRES_USER=docker -e POSTGRES_PASSWORD=docker -e POSTGRES_DB=docker library/postgres
```
or with Dockerfile
```bash
FROM library/postgres
ENV POSTGRES_USER docker
ENV POSTGRES_PASSWORD docker
ENV POSTGRES_DB docker
```




## Challange HOL
Dockerize following php application
[docker-php-sample Public](https://github.com/docker/docker-php-sample/tree/main)

## Example 5

my-database.sql
```sql
CREATE TABLE student (
    id int,
    name VARCHAR(255)
);

INSERT INTO student(id, name) VALUES
(1,'A'),
(2,'B'),
(3,'C');
```

**Mysql**
```bash
FROM mysql:latest

ENV MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
ENV MYSQL_DATABASE=${MYSQL_DATABASE}
ENV MYSQL_USER=${MYSQL_USER}
ENV MYSQL_PASSWORD=${MYSQL_PASSWORD}

COPY my-database.sql /docker-entrypoint-initdb.d/
```
Build

```bash
docker build --build-arg MYSQL_ROOT_PASSWORD=password --build-arg MYSQL_DATABASE=my_database --build-arg MYSQL_USER=my_user --build-arg MYSQL_PASSWORD=my_password -t my-database-env .
```



## References
1. [docker-apache-php](https://github.com/Actency/docker-apache-php/tree/master)
2. [docker commit make image](https://devopsdevelopment.medium.com/building-and-exporting-a-docker-image-to-deploy-a-static-website-with-apache-web-server-be23a43831c9)
3. [docker samples](https://github.com/dockersamples)
4. [Setting up and Running a MySQL Container](https://www.baeldung.com/ops/docker-mysql-container)
4. [PostgreSQL database samples with Docker](https://github.com/zseta/postgres-docker-samples/tree/main)
5. [docker postgresql](https://github.com/sameersbn/docker-postgresql)
6. [Apache Docker Container](https://github.com/d11wtq/apache-docker/tree/master)
7. [Mysql dockerfile](https://github.com/docker-library/mysql/blob/master/Dockerfile.debian)



