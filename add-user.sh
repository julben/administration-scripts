#!/bin/bash
# Script to add a user and create his/her "home"
if [ $(id -u) -eq 0 ]; then
	read -p "Enter username : " username
	read -s -p "Enter password : " password
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username already exists!"
		exit 1
	else
		salt="iodized-salt"
		encrypted_password=$(perl -e 'print crypt($ARGV[0], salt)' $password)
		# create a new user, with specified password, default home and group
		useradd -m -U -p $encrypted_password $username
		[ $? -eq 0 ] && echo "User $username has been added to system" || echo "Failed to add $username!"
	fi
else
	echo "Only root may add a user to the system"
	exit 2
fi
