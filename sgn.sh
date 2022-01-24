echo "Checking distro ..."
debian=$(cat /etc/os-release | grep -o debian)
redhat=$(cat /etc/os-release | grep -o rhel)

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
	if [[ "$redhat" == *"rhel"* ]]
	then
		echo -e "checking mariadb\n\n"
		if [[ -z $(systemctl status mariadb | grep "service not found")  ]]
		then
			echo -e "in if\n\n"
			if [[ ! $(systemctl status mariadb.service | grep -o dead) == "dead" ]]
			then 			
				echo -e "mariadb Service is Running"
			else
				echo -e "restarting service \n\n"
				systemctl restart mariadb.service
			fi
		else
			RedHatInstall	
		fi
		
		if [[ -z $(systemctl status httpd | grep "service not found")  ]]
		then
			if [[ ! $(systemctl status httpd.service | grep -o dead) == "dead" ]]
			then 			
				echo -e "httpd Service is Running"
			else
				echo -e "restarting service"				
				systemctl restart httpd.service
			fi	
		else
			RedHatInstall	
		fi
		

		
	else	
		if [[ -z $(systemctl status mysql | grep "service not found")  ]]
		then
			if [[ ! $(systemctl status mysql.service | grep -o dead) == "dead" ]]
			then 			
				echo -e "1Mysql Service is Running"
			else
				echo -e "restarting service"				
				systemctl restart mysql.service

			fi
			
		else
			DebianInstall
		fi
		
		
		if [[ -z $(systemctl status apache2 | grep "service not found")  ]]
		then
			if [[ ! $(systemctl status apache2.service | grep -o dead) == "dead" ]]
			then 			
				echo -e "2Apache Service is Running"
			else
				echo -e "restarting service"				
				systemctl restart apache2.service

			fi	
		else
				DebianInstall
		fi	
	fi		
}

startInstalling(){
	if [[ "$redhat" == "rhel" && "$1" != "install" && "$1" != "start" && "$1" != "validate" && "$1" != "backup" ]]
	then
		echo -e "RedHat Distro Installing LAMP\n\n"
		RedHatInstall
	elif [[ "$debian" == "debian" && "$1" != "install" && "$1" != "start" && "$1" != "validate" && "$1" != "backup" ]]
	then
		echo -e "Debian Distro Installing LAMP\n\n"
		DebianInstall
	fi

}


siteUp(){
	if [[ "tables" == "$(curl http://localhost/testMysqlPhpConnection/mysqlConnection.php | grep -o tables)" ]]
	then
		echo -e "Service is Running\n\n"
	else
		echo -e "Service is not Running\n\n"
		checkInstallation	
	fi
}


if [[ "$1" == "install" ]]
then
	startInstalling
elif [[ "$1" == "start" ]]
then
	echo -e "checking services\n\n\n"
	checkInstallation
elif [[ "$1" == "validate" ]]	
then 
	echo -e "Validating Site is Up\n\n"
	siteUp
elif [[ "$1" == "backup" ]]	
then 
	echo -e "Tacking Backup of /var/lib/mysql directory\n\n"
	bash backUp.sh
elif [[ "$1" == "cron" ]]	
then 
	echo -e "adding cron job\n\n"
	sudo crontab -l > cron_bkp
	sudo echo "10 * * * * sudo /home/anil/testMysqlPhpConnection/backUp.sh >/dev/null 2>&1" >> cron_bkp
	sudo crontab cron_bkp
	sudo rm cron_bkp	

elif [[ "$envLamp" == "install" ]]	
then
	startInstalling
elif [[ "$envLamp" == "start" ]]
then
	echo -e "checking services\n\n\n"
	checkInstallation
elif [[ "$envLamp" == "validate" ]]	
then 
	echo -e "Validating Site is Up\n\n"
	siteUp
elif [[ "$envLamp" == "backup" ]]	
then 
	echo -e "Tacking Backup of /var/lib/mysql directory\n\n"
	bash backUp.sh
elif [[ "$envLamp" == "cron" ]]	
then 
	echo -e "adding cron job enter minute\n\n"
	read m
	sudo crontab -l > cron_bkp
	sudo echo "$m * * * * sudo /home/anil/testMysqlPhpConnection/backUp.sh >/dev/null 2>&1" >> cron_bkp
	sudo crontab cron_bkp
	sudo rm cron_bkp	

fi		
