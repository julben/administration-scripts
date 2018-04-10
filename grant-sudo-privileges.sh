#!/bin/bash
# Script to grant sudo privileges to specific user
if [ $(id -u) -eq 0 ]; then
    echo "What is the user you wish to grant sudo privileges with?"
    echo "Enter username: "
    read -e USERNAME # TODO: implement whether a user exists or not
    usermod -a -G sudo $USERNAME
else
	echo "Only root may grant sudo privileges to a user"
	exit 2
fi
