#!/bin/bash
# This script will search for the string 'old' in all files
# relative to the passed directory and replace 'old'
# with 'new' for each occurrence of the string in each file.
#

DIRECTORY=$1
OLD_STR=$2
NEW_STR=$3

grep -rl $OLD_STR $DIRECTORY | xargs sed -i "s/${OLD_STR}/${NEW_STR}/g"
