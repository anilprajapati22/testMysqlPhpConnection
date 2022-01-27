#!/bin/bash


# Author  : Anil Prajapati
# Email 	: anilprajapati18@gnu.ac.in
# About	: To install LAMP stack on Linux start,stop services


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

	yum update -y

	echo "installing php httpd mariadb"

	yum install -y httpd mariadb-server* mariadb php php-mysql* curl

	echo "restarting servicing"

	systemctl restart httpd.service mariadb.service

	# mysql_secure_installation

	cd /var/www/html/

	git clone https://anilprajapati22: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@github.com/anilprajapati22/testMysqlPhpConnection.git

	cd testMysqlPhpConnection/
	
	if [ -z "$Dbpasswd" ]
	then
		echo -e "please add Dbpasswd environment variable for database password\n"	
	fi	
	if [ -z "$Dbuser" ]
	then
		echo -e "please add Dbpasswd environment variable for database user\n"
	fi
	php -f mysqlConnection.php

}

DebianInstall(){
	apt update &&  apt upgrade
	apt-get update &&  apt-get upgrade

	apt install apache2 curl
	apt  install php libapache2-mod-php
	apt install mysql-server
	apt-get install php-mysql
	apt-get install libapache2-mod-php

}

checkInstallation(){
	echo -e "checking $1\n"
	checkDistro
	if [[ $? == 1 ]]
	then
		if [[ ! $(yum list --installed | grep $1 -c) -eq 0 ]]
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

	else
		if [[ ! $(apt list --installed | grep $1 -c) -eq 0 ]]
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
	if [[ "tables" == "$(curl http://localhost/testMysqlPhpConnection/sgn1.php | grep -o tables)" ]]
	then
		echo -e "Service is Running\n"
	else
		echo -e "Service is not Running\n"
		checkDistro
		if [[ $? == 1 ]]
		then
			checkInstallation mariadb
			checkInstallation httpd
		else
			checkInstallation mysql
			checkInstallation apache2
		fi
	
	fi
}

case "$1" in
	"install") 
		echo -e "Installing\n" 
		startInstalling
	;;
	"start") 
		echo -e "Cheking for $2\n" 
		checkInstallation $2

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
		crontab -l > cron_bkp
		echo "$m * * * * /home/anil/testMysqlPhpConnection/backUp.sh >/dev/null 2>&1" >> cron_bkp
		crontab cron_bkp
		rm cron_bkp	

		;;

esac
