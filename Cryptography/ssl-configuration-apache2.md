## Ubuntu Server with Apache2: Create CSR & Install SSL Certificate (OpenSSL)

1. Ubuntu with Apache2: Creating Your CSR with OpenSSL

    [Go to link](https://www.digicert.com/easy-csr/openssl.htm) and generate one


2. Ubuntu with Apache2: Installing and Configuring Your SSL Certificate

    1. Find the Apache configuration file you need to edit
        ```bash
        /etc/apache2/sites-enabled/your_site_name
        ```
        ```bash
        sudo a2ensite your_site_name
        ```
    2. Configure the <VirtualHost> block for the SSL-enabled site
        ```bash
        <VirtualHost 192.168.0.1:443>
        DocumentRoot /var/www/
        SSLEngine on
        SSLCertificateFile /path/to/your_domain_name.crt
        SSLCertificateKeyFile /path/to/your_private.key
        SSLCertificateChainFile /path/to/DigiCertCA.crt
        </VirtualHost>
        ```
        > *Note*: If the SSLCertificateChainFile directive doesn't work, try using the SSLCACertificateFile directive instead.
    3. Test your Apache2 configuration file before restarting
        ```bash
        apachectl configtest
        ```
    4. Restart Apache2.
        ```bash
        apachectl stop
        apachect1 start
        ```


### How to Generate a CSR for Ubuntu with Apache 2 Using OpenSSL
```bash
openssl req -new -newkey rsa:2048 -nodes -keyout server.key -out server.csr
```

### Some Commands
```bash
sudo apt-get install apache2
```

### Generate public key from private key
```bash
ssh-keygen -f rsa.pem -y
```


## Nginx: Installing & Configuring Your SSL Certificate
1. Concatenate the primary and intermediate certificates
    ```bash
    cat your_domain_name.crt DigiCertCA.crt >> bundle.crt
    ```
2. Edit the Nginx virtual hosts file
    ```bash
    server {

    listen   443;
    
    ssl    on;
    ssl_certificate    /etc/ssl/your_domain_name.pem; (or bundle.crt)
    ssl_certificate_key    /etc/ssl/your_domain_name.key;
    
    server_name your.domain.com;
    access_log /var/log/nginx/nginx.vhost.access.log;
    error_log /var/log/nginx/nginx.vhost.error.log;
    location / {
    root   /home/www/public_html/your.domain.com/public/;
    index  index.html;
    }
    
    }
    ```
3. Restart Nginx.
    ```bash
    nginx -s reload
    ```

## Reference
1. [SSL Configuration apache ubuntu](https://www.digicert.com/kb/csr-ssl-installation/ubuntu-server-with-apache2-openssl.htm)
2. [How to enable HTTPS protocol with Apache 2 on Ubuntu 20.04](https://www.arubacloud.com/tutorial/how-to-enable-https-protocol-with-apache-2-on-ubuntu-20-04.aspx)

