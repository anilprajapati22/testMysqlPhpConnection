#!/bin/bash

echo "updating packages"

sudo yum update -y

echo "installing php httpd mariadb"

sudo yum install -y httpd mariadb-server* mariadb php php-mysql*

echo "restarting servicing"

sudo systemctl restart httpd.service mariadb.service




