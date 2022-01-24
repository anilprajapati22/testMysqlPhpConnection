backUp(){
    mkdir /etc/backup
	zip /etc/backup/mysqlBackup"$(date +%d-%m-%y-%T)".zip /var/lib/mysql/*

}


backUp