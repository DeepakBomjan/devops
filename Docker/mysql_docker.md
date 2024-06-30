1. DB Initialisation script
```mysql
-- Create database if not exists
CREATE DATABASE IF NOT EXISTS mydatabase;
USE mydatabase;

-- Create table for students
CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Faculty VARCHAR(100),
    Address VARCHAR(255)
);

-- Insert sample data
INSERT INTO students (Name, Faculty, Address) VALUES
    ('John Doe', 'Engineering', '123 Main St, Cityville'),
    ('Jane Smith', 'Science', NULL),
    ('Michael Brown', NULL, '456 Elm St, Townsville');
```
2. Running mysql container
```bash
docker run -d --name mysql-container -p 3306:3306 \
    -e MYSQL_ROOT_PASSWORD=root_password \
    -v /path/to/init.sql:/docker-entrypoint-initdb.d/init.sql \
    mysql:8.0

```

3. Connect database
```bash
mysql -h 127.0.0.1 -P 3306 -u root -p mydatabase

```

