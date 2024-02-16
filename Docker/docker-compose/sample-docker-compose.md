## Run nginx with docker compose

### Example 1
```yaml
version: '3'

services:
  nginx:
    image: nginx:latest
    container_name: nginx
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    restart: always

```

### Example 2
```yaml
version: '3'

services:
  nginx:
    image: nginx:latest
    container_name: nginx
    networks:
      my_network:
        ipv4_address: 172.18.0.2
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    restart: always

networks:
  my_network:
    driver: bridge
    ipam:
      driver: default
      config:
        - subnet: 172.18.0.0/16

```

## Run database with volume

### Example 1
```yaml
version: '3'

services:
  mysql:
    image: mysql:latest
    container_name: mysql
    networks:
      my_network:
        ipv4_address: 172.19.0.2
    ports:
      - "3306:3306"
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    volumes:
      - mysql_data:/var/lib/mysql
    restart: always

networks:
  my_network:
    driver: bridge
    ipam:
      driver: default
      config:
        - subnet: 172.19.0.0/16

volumes:
  mysql_data:
    driver: local

```

### Example 2 - with healthcheck
```bash
version: '3'

services:
  mysql:
    image: mysql:latest
    container_name: mysql
    networks:
      my_network:
        ipv4_address: 172.19.0.2
    ports:
      - "3306:3306"
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    volumes:
      - mysql_data:/var/lib/mysql
    healthcheck:
      test: ["CMD-SHELL", "mysqladmin ping -h 127.0.0.1 -u${MYSQL_USER} -p${MYSQL_PASSWORD}"]
      interval: 10s
      timeout: 5s
      retries: 3
    restart: always

networks:
  my_network:
    driver: bridge
    ipam:
      driver: default
      config:
        - subnet: 172.19.0.0/16

volumes:
  mysql_data:
    driver: local

```
### Example 2 - with ENV in separate file
**mysql.env**
```bash
MYSQL_ROOT_PASSWORD=your_root_password
MYSQL_DATABASE=your_database_name
MYSQL_USER=your_mysql_user
MYSQL_PASSWORD=your_mysql_password
```

```yaml
version: '3'

services:
  mysql:
    image: mysql:latest
    container_name: mysql
    networks:
      my_network:
        ipv4_address: 172.19.0.2
    ports:
      - "3306:3306"
    env_file:
      - mysql.env
    volumes:
      - mysql_data:/var/lib/mysql
    healthcheck:
      test: ["CMD-SHELL", "mysqladmin ping -h 127.0.0.1 -u${MYSQL_USER} -p${MYSQL_PASSWORD}"]
      interval: 10s
      timeout: 5s
      retries: 3
    restart: always

networks:
  my_network:
    driver: bridge
    ipam:
      driver: default
      config:
        - subnet: 172.19.0.0/16

volumes:
  mysql_data:
    driver: local

```
### Example 3 - with hostname map
```yaml
version: '3'

services:
  mysql:
    image: mysql:latest
    container_name: mysql
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    volumes:
      - mysql_data:/var/lib/mysql
    healthcheck:
      test: ["CMD-SHELL", "mysqladmin ping -h 127.0.0.1 -u${MYSQL_USER} -p${MYSQL_PASSWORD}"]
      interval: 10s
      timeout: 5s
      retries: 3
    network_mode: host
    restart: always
    extra_hosts:
      - "hostname:192.168.1.100"

volumes:
  mysql_data:
    driver: local

```
