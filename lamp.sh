#!/bin/bash

echo "updating packages"

sudo yum update -y

echo "installing php httpd mariadb"

sudo yum install -y httpd mariadb-server* mariadb php php-mysql*

echo "restarting servicing"

sudo systemctl restart httpd.service mariadb.service

sudo mysql_secure_installation

cd /var/www/html/

sudo git clone https://anilprajapati22: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@github.com/anilprajapati22/testMysqlPhpConnection.git

cd testMysqlPhpConnection/

sudo php -f mysqlConnection.php



