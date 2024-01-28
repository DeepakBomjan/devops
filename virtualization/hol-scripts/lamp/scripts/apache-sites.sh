#! /bin/bash

mv /tmp/configs/apache-example.site /etc/apache2/sites-available/example-site.conf
a2dissite 000-default.conf
a2ensite example-site.conf
service apache2 restart
