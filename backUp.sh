backUp(){
	zip mysqlBackup"$(date +%d-%m-%y-%T)".zip /var/lib/mysql/*

}


backUp