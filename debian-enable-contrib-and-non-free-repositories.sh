#!/bin/bash
# Script to create a new "sources.list" to
# enable contrib and non-free repositories

DEBIAN_RELEASE=`cat /etc/*-release 2> /dev/null | grep PRETTY_NAME | awk -F "=" {'print $2'} | awk -F "(" {'print $2'} | awk -F ")" {'print $1'}`
SOURCES_FILE="/etc/apt/sources.list"
MIRROR_URL="http://httpredir.debian.org/debian" # find the closest mirror
MIRROR_SECURITY_URL="http://security.debian.org/"

if [ $(id -u) -eq 0 ]; then # root check
    echo "-> Updating sources.list to add \"contrib\" and \"non-free\""
    echo "-> Backuping original sources.list before modification"
    if [ -e SOURCES_FILE ] # if sources.list exists, consider a backup has already been made in a proper state
    then
        cp -p SOURCES_FILE SOURCES_FILE.back
        echo "Backup done."
    else
        echo "File exists. Leaving previous backup."
    fi
    echo "deb MIRROR_URL $DEBIAN_RELEASE main contrib non-free" >> SOURCES_FILE
    echo "deb-src MIRROR_URL $DEBIAN_RELEASE main contrib non-free" >> SOURCES_FILE
    echo "" >> SOURCES_FILE
    echo "deb MIRROR_SECURITY_URL $DEBIAN_RELEASE/updates main contrib non-free" >> SOURCES_FILE
    echo "deb-src MIRROR_SECURITY_URL $DEBIAN_RELEASE/updates main contrib non-free" >> SOURCES_FILE
    echo "" >> SOURCES_FILE
    echo "# $DEBIAN_RELEASE-updates, previously known as 'volatile'" >> SOURCES_FILE
    echo "deb MIRROR_URL $DEBIAN_RELEASE-updates main contrib non-free" >> SOURCES_FILE
    echo "deb-src MIRROR_URL $DEBIAN_RELEASE-updates main contrib non-free" >> SOURCES_FILE
else
	echo "Only root may edit $SOURCES_FILE"
	exit 2
fi
