backUp(){
    if  [[ "backup" != "$(ls /etc/ | grep -o backup)" ]]
    then
        mkdir /etc/backup
    fi    
	zip /etc/backup/mysqlBackup"$(date +%d-%m-%y-%T)".zip /var/lib/mysql/*

}


backUp