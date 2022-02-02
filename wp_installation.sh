#!/bin/bash
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xzf latest.tar.gz
sudo systemctl start mariadb
mysql -u root -p

# DB changes
CREATE USER 'wordpress-user'@'localhost' IDENTIFIED BY 'your_strong_password';
CREATE DATABASE `wordpress-db`;
GRANT ALL PRIVILEGES ON `wordpress-db`.* TO "wordpress-user"@"localhost";
FLUSH PRIVILEGES;
exit

cp wordpress/wp-config-sample.php wordpress/wp-config.php

# Edit the wp-config.php file with your favorite text editor (such as nano or vim) and enter values for your installation.
# DB_NAME, DB_USER, DB_PASSWORD

# Find the section called Authentication Unique Keys and Salts. These KEY and SALT values provide a layer of encryption to the browser cookies that WordPress users store on their local machines. Basically, adding long, random values here makes your site more secure. Visit https://api.wordpress.org/secret-key/1.1/salt/ to randomly generate a set of key values that you can copy and paste into your wp-config.php file.

# Allow wordpress to use permalinks; 
#1. sudo vim /etc/httpd/conf/httpd.conf
#2. Find the section that starts with <Directory "/var/www/html">.
#3. Change the AllowOverride None line in the above section to read AllowOverride All.
#4. Save and exit text editor

cp -r wordpress/* /var/www/html/

sudo yum install php-gd
sudo chown -R apache /var/www
sudo chgrp -R apache /var/www
sudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
sudo systemctl restart httpd
sudo systemctl enable httpd && sudo systemctl enable mariadb
