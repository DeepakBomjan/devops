To set up HTTP basic authentication with `htpasswd` using Apache, along with a simple UI for login, follow these steps:

### Step 1: Install Apache and `htpasswd`

First, ensure Apache and `htpasswd` are installed on your system.

#### On Debian/Ubuntu:
```sh
sudo apt-get update
sudo apt-get install apache2 apache2-utils
```

#### On Red Hat/CentOS:
```sh
sudo yum install httpd httpd-tools
```

### Step 2: Create Authentication File

Create a directory to store the authentication file:

```sh
mkdir -p /etc/apache2/auth
```

Create the `htpasswd` file with a user:

```sh
htpasswd -c /etc/apache2/auth/.htpasswd myuser
```

You’ll be prompted to enter and confirm a password for the user `myuser`.

### Step 3: Configure Apache for Authentication

Open or create an Apache configuration file for your site. Here, we'll create a new file in the `sites-available` directory.

```sh
sudo nano /etc/apache2/sites-available/my_site.conf
```

Add the following configuration:

```apache
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html

    <Directory /var/www/html>
        AuthType Basic
        AuthName "Restricted Content"
        AuthUserFile /etc/apache2/auth/.htpasswd
        Require valid-user
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

### Step 4: Enable the Site and Authentication Modules

Enable the new site configuration and the necessary authentication modules:

```sh
sudo a2enmod auth_basic
sudo a2ensite my_site.conf
```

### Step 5: Restart Apache

Restart Apache to apply the changes:

```sh
sudo systemctl restart apache2  # For Debian/Ubuntu
sudo systemctl restart httpd    # For Red Hat/CentOS
```

### Step 6: Test the Authentication

Navigate to your server's IP address or domain name in a web browser. You should see a login prompt. Enter the username (`myuser`) and password you set up earlier.

### Step 7: Create a Simple Login UI (Optional)

While HTTP basic authentication provides a standard browser login prompt, you can create a custom HTML login page with form-based authentication. This involves more advanced configuration and potentially using additional software like PHP. Below is a simple example of how you might set this up:

1. **Create an HTML Login Page**

Create a simple login form in your web document root (`/var/www/html`):

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
</head>
<body>
    <h2>Login</h2>
    <form action="/login.php" method="post">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username"><br><br>
        <label for="password">Password:</label>
        <input type="password" id="password" name="password"><br><br>
        <input type="submit" value="Login">
    </form>
</body>
</html>
```

2. **Create a PHP Script for Authentication**

Create a PHP script (`login.php`) to handle the form submission and authenticate against the `htpasswd` file. Note that this is a simplified example and not secure for production use.

```php
<?php
$username = $_POST['username'];
$password = $_POST['password'];

$htpasswd_path = '/etc/apache2/auth/.htpasswd';

$lines = file($htpasswd_path);
foreach ($lines as $line) {
    list($stored_user, $stored_hash) = explode(':', trim($line));
    if ($username == $stored_user && password_verify($password, $stored_hash)) {
        echo "Login successful!";
        exit;
    }
}
echo "Login failed!";
?>
```

3. **Update Apache Configuration for PHP**

Ensure Apache is configured to handle PHP. On Debian/Ubuntu, you might need to install PHP and the Apache PHP module:

```sh
sudo apt-get install php libapache2-mod-php
sudo systemctl restart apache2
```

On Red Hat/CentOS:

```sh
sudo yum install php
sudo systemctl restart httpd
```

### Step 8: Test the Custom Login Page

Navigate to your server's IP address or domain name in a web browser and visit the `index.html` page. Try logging in with the username (`myuser`) and password you set up earlier.

### Summary

By following these steps, you've set up Apache with HTTP basic authentication using `htpasswd`. Additionally, you created a simple custom login UI using HTML and PHP, which can be expanded upon for more complex authentication needs.
