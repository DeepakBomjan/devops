## How to run mongodb using docker-compose in ubuntu
1. Create docker-compose file like the following:
```yaml
version: '3.7'
services:
  mongodb:
    image: mongo:latest
    container_name: mongodb_contaner
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: 12345678
      MONGO_INITDB_DATABASE: chat_app
    command:
      - '--logpath'
      - '/var/log/mongodb/mongod.log'
    ports:
      - 27017:27017
    volumes:
      - ./docker/mongodb_data:/data/db
      - ./docker/init-mongo.js:/docker-entrypoint-initdb.d/init-mongo.js
```

2. Create a directory called docker like the following:
```bash
mkdir -p docker/mongodb_data
```
Create an `init-mongo.js` inside docker directory and with the following content

```javascript
db = db.getSiblingDB('admin');
db.auth('root', '12345678');

db = db.getSiblingDB('chat_app');
db.createUser({
  user: 'app_user',
  pwd: 'password',
  roles: [
    {
      role: 'readWrite',
      db: 'chat_app',
    },
  ],
});

db.createCollection('test_docker');
```
3. Run docker-compose to start running the container:
```bash
docker-compose down && docker-compose build --no-cache && docker-compose up -d
```
4. To check everything is working, SSH into the MongoDB container like the following:
```bash
//to SSH into the container
docker exec -it mongodb_contaner bash

mongod --version

//Check admin db connection is working or not
mongosh admin -u root -p

// check default database with newly created by init-mongo.js
show dbs
```

## Example 2
1. `docker-compose.yaml`
```yaml
version: '3.7'
services:
  mongodb_container:
    image: mongo:latest
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: rootpassword
    ports:
      - 27017:27017
    volumes:
      - mongodb_data_container:/data/db

volumes:
  mongodb_data_container:
```
2. Connect to database
```bash
mongo admin -u root -p rootpassword
```
3. Some useful commands.
    * Show databases:
    ```bash
    show dbs
    ```
    * Create new non-existant database
    ```bash
    use mydatabase
    ```
    * Show collections:
    ```bash
    show collections
    ```
    * Show contents/documents of a collection:
    ```bash
    db.your_collection_name.find()
    ```
    * Save a data to a collection:
    ```bash
    db.your_collection_name.save({"name":"Sony AK"})
    ```
    * Show database version:
    ```bash
    db.version()
    ```

## References
1. [How to run mongodb using docker-compose in ubuntu](https://dev.to/shaikhalamin/how-to-run-mongodb-using-docker-compose-in-ubuntu-14l3)
2. [How to spin MongoDB server with Docker and Docker Compose](https://dev.to/sonyarianto/how-to-spin-mongodb-server-with-docker-and-docker-compose-2lef)
3. [mongodb-docker step-by-step](How to run MongoDB with Docker and Docker Compose a Step-by-Step guide)
