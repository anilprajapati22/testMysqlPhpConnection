#!/bin/bash

#Functions
InstallLAMP () {
	sudo apt update && sudo apt upgrade
	sudo apt-get update && sudo apt-get upgrade
	echo -e  "\nInstalling Apache...\n------------"
	sudo apt install apache2
	sudo apt  install php libapache2-mod-php
	sudo apt install mysql-server
	sudo apt-get install php-mysql
	sudo apt-get install libapache2-mod-php
}

StartLAMP (){
	if !  [[ -z $(sudo systemctl status mysql | grep "service not found")  ]]
	then
		sudo apt install apache2
	fi
	if ! [[ -z $(systemctl status apache2 | grep "service not found")  ]]
	then
                sudo apt install mysqlserver
        fi
	InstallLAMP
	if [[ -z $(sudo systemctl status mysql | grep "active (running)") ]]
	then
		systemctl start mysql
	fi
	if [[ -z $(sudo systemctl status apache2 | grep "active (running)") ]]
	then
		systemctl start apache2
	fi
}
ShutLAMP (){
	if [$2 == ""]
	then
		sudo systemctl stop mysql
                sudo systemctl stop apache2
	elif [ $2 == "mysql" ]
	then
		sudo systemctl stop mysql
	elif [ $2 == "apache2" ]
	then
		sudo systemctl stop apache2
	else
		echo Nothing to shut
	fi
}
StatusLAMP (){
	echo "------------------------"
	echo Web Server
	echo "------------------------"
	echo $(sudo systemctl status apache2 | grep Active)
	echo "------------------------"
	echo DB Server
	echo "------------------------"
        echo $(sudo systemctl status mysql | grep Active)
}
echo "Checking distro ..."
debian=$(cat /etc/os-release | grep debian)
redhat=$(cat /etc/os-release | grep rhel)
echo $1
if [ -z "$debian" ]
then
	echo "This is RedHat Distro"
else
	echo "This is Debian Distro"
	if [[ $1 == "InstallLAMP" ]]
	then
		echo -e  "Installing LAMP...\n\n"
		InstallLAMP
	elif [[ $1 == "StartLAMP" ]]
	then
		echo "Starting LAMP"
		StartLAMP
	elif [[ $1 == "ShutLAMP" ]]
	then
		ShutLAMP
		echo "Shutting Down LAMP"
	elif [[ $1 == "StatusLAMP" ]]
	then
		StatusLAMP
		echo "Checking Status LAMP"
	else
		echo "Nothing"
	fi
fi
