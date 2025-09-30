#!/bin/bash
# Update and upgrade packages
sudo apt update -y && sudo apt upgrade -y
# Install Apache, MySQL, and PHP
sudo apt install -y apache2 mysql-server php libapache2-mod-php php-mysql
# Change the Apache document root directory to /var/www/html/wordpress
sudo sed -i "s/DocumentRoot.*$/DocumentRoot \/var\/www\/html\/wordpress/g" /etc/apache2/sites-available/000-default.conf
# Change the Apache directory settings to allow overrides
sudo sed -i "s/AllowOverride.*$/AllowOverride All/g" /etc/apache2/apache2.conf
# Create a WordPress database and user
sudo mysql -e "CREATE DATABASE wordpress; \
CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY 'password'; \
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'localhost'; \
FLUSH PRIVILEGES;"
# Download and extract the latest version of WordPress
cd /tmp && curl -LO https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
sudo mv wordpress /var/www/html/
# Set the correct permissions for the WordPress files
sudo chown -R www-data:www-data /var/www/html/wordpress
sudo chmod -R 755 /var/www/html/wordpress
# Create a wp-config.php file from the sample file
cd /var/www/html/wordpress
sudo mv wp-config-sample.php wp-config.php
sudo sed -i "s/database_name_here/wordpress/" wp-config.php
sudo sed -i "s/username_here/wordpressuser/" wp-config.php
sudo sed -i "s/password_here/password/" wp-config.php
# Restart Apache
sudo systemctl restart apache2