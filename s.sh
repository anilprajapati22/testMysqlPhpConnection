if [[ ! "$(systemctl status mariadb.service | grep -o running )" == "running" ]]
then 			
	echo -e "mariadb Service is Running"
else
	echo -e "restarting service"	
	systemctl restart mariadb.service
fi
