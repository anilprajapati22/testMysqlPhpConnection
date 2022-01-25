#!/bin/sh

# Define your function here
Hello () {
   echo "Hello World"$1 
   return 11
}
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

# Invoke your function
checkDistro
echo $?