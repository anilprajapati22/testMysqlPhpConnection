echo "Checking distro ..."
debian=$(cat /etc/os-release | grep -o debian)
redhat=$(cat /etc/os-release | grep -o rhel)

RedHatInstall(){
	echo "updating packages"

	sudo yum update -y

	echo "installing php httpd mariadb"

	sudo yum install -y httpd mariadb-server* mariadb php php-mysql*

	echo "restarting servicing"

	sudo systemctl restart httpd.service mariadb.service

	#sudo mysql_secure_installation

	cd /var/www/html/

	sudo git clone https://anilprajapati22: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@github.com/anilprajapati22/testMysqlPhpConnection.git

	cd testMysqlPhpConnection/

	sudo php -f mysqlConnection.php

}

DebianInstall(){
	sudo apt update && sudo apt upgrade
	sudo apt-get update && sudo apt-get upgrade
	echo -e  "\nInstalling Apache...\n------------"
	sudo apt install apache2
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
		if [[ -z $(sudo systemctl status mysql | grep "service not found")  ]]
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
	if [[ "$redhat" == "rhel" && "$1" != "install" && "$1" != "start" ]]
	then
		echo -e "RedHat Distro Installing LAMP\n\n"
		RedHatInstall
	elif [[ "$debian" == "debian" && "$1" != "install" && "$1" != "start" ]]
	then
		echo -e "Debian Distro Installing LAMP\n\n"
		DebianInstall
	fi

}


if [[ "$1" == "install" ]]
then
	startInstalling
elif [[ "$1" == "start" ]]
then
	echo -e "checking services\n\n\n"
	checkInstallation
elif [[ "$envLamp" == "install" ]]	
then
	startInstalling
elif [[ "$envLamp" == "start" ]]
then
	echo -e "checking services\n\n\n"
	checkInstallation

fi		
