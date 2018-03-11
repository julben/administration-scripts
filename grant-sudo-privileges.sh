#!/bin/bash

echo "What is the user you wish to grant sudo privileges with?"
echo "Enter username: "
read -e USERNAME # TODO: implement whether a user exists or not
usermod -a -G sudo $USERNAME
