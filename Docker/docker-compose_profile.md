**Docker Compose** is a powerful tool for defining and running multi-container **Docker** applications. It allows developers to define their application’s services, networks, and volumes in a single YAML file, making it easy to deploy and manage complex applications.

## Sample docker compose file
```bash
version: "3.9"
services:
  web:
    image: nginx
    ports:
      - "8080:80"
  db:
    image: postgres
    environment:
      POSTGRES_PASSWORD: secretpassword
```

```bash
docker-compose up web
docker-compose up web db
```

## Service Profiles
```bash
version: "3.9"
services:
  web:
    image: nginx
    ports:
      - "8080:80"
  db:
    image: postgres
    environment:
      POSTGRES_PASSWORD: secretpassword  
    profiles:
      - dev   
  mysqldb:
    image: mysql:8.0
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: testrootpassword
      MYSQL_DATABASE: test
      MYSQL_USER: test
      MYSQL_PASSWORD: testpassword
    profiles:
      - prod
    volumes:
      - db_data:/var/lib/mysql
volumes:
  db_data:
```
```bash
docker-compose --profile=prod up
```
