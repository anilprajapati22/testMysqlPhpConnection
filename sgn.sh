#!/bin/bash

checkDistro(){
	echo "Checking distro ..."
	debian=$(cat /etc/os-release | grep -o debian)
	redhat=$(cat /etc/os-release | grep -o rhel)
	if [[ "$redhat" == "rhel" ]]
	then
		return 1
	else
		return 0
	fi		
}

RedHatInstall(){
	echo "updating packages"

	sudo yum update -y

	echo "installing php httpd mariadb"

	sudo yum install -y httpd mariadb-server* mariadb php php-mysql* curl

	echo "restarting servicing"

	sudo systemctl restart httpd.service mariadb.service

	#sudo mysql_secure_installation

	cd /var/www/html/

	sudo git clone https://anilprajapati22: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@github.com/anilprajapati22/testMysqlPhpConnection.git

	cd testMysqlPhpConnection/
	if [ ! -z "$Dbpasswd" ]
	then
		sed "s/username/$Dbpasswd/" mysqlConnection.php > newfile.php
	else
		echo -e "please add Dbpasswd environment variable for database password\n"	
	fi	
	if [ ! -z "$Dbuser" ]
	then
		sed "s/username/$Dbuser/" mysqlConnection.php > newfile.php
	else
		echo -e "please add Dbpasswd environment variable for database user\n"
	fi
	sudo php -f mysqlConnection.php

	sudo firewall-cmd --permanent --zone=public --add-service=http
}

DebianInstall(){
	sudo apt update && sudo apt upgrade
	sudo apt-get update && sudo apt-get upgrade

	sudo apt install apache2 curl
	sudo apt  install php libapache2-mod-php
	sudo apt install mysql-server
	sudo apt-get install php-mysql
	sudo apt-get install libapache2-mod-php

}

checkInstallation(){
	echo -e "checking $1\n"
	if [[ -z $(systemctl status $1 | grep "service not found")  ]]
	then
		if [[ ! $(systemctl status $1.service | grep -o dead) == "dead" ]]
		then 		
			echo -e "----------------------"	
			echo -e "$1 Service is Running"
			echo -e "----------------------"
		else
			echo -e "----------------------"	
			echo -e "$1 Service is Restarting"
			echo -e "----------------------"
			systemctl restart $1.service
		fi
	else
		startInstalling
	fi
}

stopService(){
	echo -e "Stoping $1\n"
	if [[ -z $(systemctl status $1 | grep "service not found")  ]]
	then
		systemctl stop $1.service
	else
		startInstalling
	fi
}

startInstalling(){
	checkDistro
	if [[ $? == 1 ]]
	then
		echo -e "RedHat Distro Installing LAMP\n\n"
		RedHatInstall
	else
		echo -e "Debian Distro Installing LAMP\n\n"
		DebianInstall
	fi

}


siteUp(){
	if [[ "tables" == "$(curl http://localhost/testMysqlPhpConnection/mysqlConnection.php | grep -o tables)" ]]
	then
		echo -e "Service is Running\n"
	else
		echo -e "Service is not Running\n"
		checkInstallation	
	fi
}


case "$1" in
	"install") 
		echo -e "Installing\n" 
		startInstalling
	;;
	"start") 
		echo -e "Cheking Installation\n" 
		echo -e "checking services\n"
		checkDistro
		if [[ $? == 1 ]]
		then
			checkInstallation mariadb
			checkInstallation httpd
		else
			checkInstallation mysql
			checkInstallation apache2
		fi

	;;

	"stop") 
		stopService $2
	;;

	"validate") 
		echo -e "validating service\n"
		siteUp 
		;;
		"backup") 
		echo "Tacking Backup\n"
		bash backUp.sh 
		;;
		"cron") 
		echo -e "adding cron job enter minute\n"
		read m
		sudo crontab -l > cron_bkp
		sudo echo "$m * * * * /home/anil/testMysqlPhpConnection/backUp.sh >/dev/null 2>&1" >> cron_bkp
		sudo crontab cron_bkp
		sudo rm cron_bkp	

   ;;

esac
