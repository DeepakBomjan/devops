Virtual hosting with Apache allows you to host multiple websites on a single server. There are two types of virtual hosting: name-based and IP-based. Name-based virtual hosting is more common and allows multiple domain names to be served from a single IP address.

Here’s a step-by-step guide to setting up name-based virtual hosting with Apache.

### Step 1: Install Apache

Ensure Apache is installed on your server.

#### On Debian/Ubuntu:
```sh
sudo apt-get update
sudo apt-get install apache2
```

#### On Red Hat/CentOS:
```sh
sudo yum install httpd
```

### Step 2: Configure DNS

Ensure that the domain names you plan to use are pointed to your server's IP address. This involves setting up DNS records with your domain registrar.

### Step 3: Set Up Directory Structure

Create a directory structure for your websites. For example, let's host `example1.com` and `example2.com`.

```sh
sudo mkdir -p /var/www/example1.com/public_html
sudo mkdir -p /var/www/example2.com/public_html

sudo chown -R $USER:$USER /var/www/example1.com/public_html
sudo chown -R $USER:$USER /var/www/example2.com/public_html

sudo chmod -R 755 /var/www
```

Create a simple index.html file for each site:

```sh
echo "<html><body><h1>Welcome to example1.com</h1></body></html>" > /var/www/example1.com/public_html/index.html
echo "<html><body><h1>Welcome to example2.com</h1></body></html>" > /var/www/example2.com/public_html/index.html
```

### Step 4: Create Virtual Host Files

Create a virtual host file for each website.

#### On Debian/Ubuntu:
```sh
sudo nano /etc/apache2/sites-available/example1.com.conf
```

#### On Red Hat/CentOS:
```sh
sudo nano /etc/httpd/conf.d/example1.com.conf
```

Add the following configuration to `example1.com.conf`:

```apache
<VirtualHost *:80>
    ServerAdmin webmaster@example1.com
    ServerName example1.com
    ServerAlias www.example1.com
    DocumentRoot /var/www/example1.com/public_html
    ErrorLog ${APACHE_LOG_DIR}/example1.com_error.log
    CustomLog ${APACHE_LOG_DIR}/example1.com_access.log combined
</VirtualHost>
```

Create a similar file for `example2.com`.

#### On Debian/Ubuntu:
```sh
sudo nano /etc/apache2/sites-available/example2.com.conf
```

#### On Red Hat/CentOS:
```sh
sudo nano /etc/httpd/conf.d/example2.com.conf
```

Add the following configuration to `example2.com.conf`:

```apache
<VirtualHost *:80>
    ServerAdmin webmaster@example2.com
    ServerName example2.com
    ServerAlias www.example2.com
    DocumentRoot /var/www/example2.com/public_html
    ErrorLog ${APACHE_LOG_DIR}/example2.com_error.log
    CustomLog ${APACHE_LOG_DIR}/example2.com_access.log combined
</VirtualHost>
```

### Step 5: Enable the Virtual Hosts

#### On Debian/Ubuntu:

Enable the new virtual host files:

```sh
sudo a2ensite example1.com.conf
sudo a2ensite example2.com.conf
```

Disable the default site if desired:

```sh
sudo a2dissite 000-default.conf
```

Reload Apache to apply the changes:

```sh
sudo systemctl reload apache2
```

#### On Red Hat/CentOS:

For CentOS, virtual hosts in `/etc/httpd/conf.d/` are automatically included. Restart Apache to apply the changes:

```sh
sudo systemctl restart httpd
```

### Step 6: Test Your Configuration

To test your configuration, add entries to your local `hosts` file to map the domain names to your server's IP address. This is useful for testing without modifying DNS settings.

#### On Windows:
Edit the `C:\Windows\System32\drivers\etc\hosts` file.

#### On Linux/macOS:
Edit the `/etc/hosts` file.

Add the following lines:

```plaintext
127.0.0.1 example1.com
127.0.0.1 example2.com
```

Replace `127.0.0.1` with your server's IP address if accessing from a remote machine.

### Step 7: Access the Websites

Open a web browser and navigate to `http://example1.com` and `http://example2.com`. You should see the respective welcome messages for each site.

### Summary

By following these steps, you can set up name-based virtual hosting with Apache to host multiple websites on a single server. This allows efficient use of server resources and simplifies management.
