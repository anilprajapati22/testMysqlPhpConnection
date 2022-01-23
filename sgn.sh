
RedHatInstall(){
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
		if [[ -z $(sudo systemctl status mariadb | grep "service not found")  ]]
		then
			if [[ 1 -ge $(systemctl status mariadb.service | grep -c "running") ]]
			then 			
				echo -e "mariadb Service is Running"
			fi
		else
			RedHatInstall	
		fi
		
		if [[ -z $(systemctl status httpd | grep "service not found")  ]]
		then
			if [[ 1 -ge $(systemctl status httpd.service | grep -c "running") ]]
			then 			
				echo -e "httpd Service is Running"
			fi	
		else
			RedHatInstall	
		fi
		

		
	else	
		if [[ -z $(sudo systemctl status mysql | grep "service not found")  ]]
		then
			if [[ 1 -ge $(systemctl status mysql.service | grep -c "running") ]]
			then 			
				echo -e "1Mysql Service is Running"
			fi
			
		#else
			#DebianInstall
		fi
		
		
		if [[ -z $(systemctl status apache2 | grep "service not found")  ]]
		then
			if [[ 1 -ge $(systemctl status apache2.service | grep -c "running") ]]
			then 			
				echo -e "2Apache Service is Running"
			fi	
		#else
			#DebianInstall
		fi	
	fi		
}


echo "Checking distro ..."
debian=$(cat /etc/os-release | grep debian)
redhat=$(cat /etc/os-release | grep rhel)

echo $1
if [ -z "$debian" ]
then
	echo -e "RedHat Distro Installing LAMP\n\n"
	RedHatInstall
elif [[ "$1" == "install" ]]
then
	echo -e "Debian Distro Installing LAMP\n\n"
	DebianInstall

elif [[ "$1" == "start" ]]
then
	checkInstallation
	
fi		
