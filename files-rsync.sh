#!/bin/bash

WPPath=--path=public/
# read variables from the .dat file
while read line; do
    declare $line
done < variables.dat

# STOP EDITING
# Welcome message / sanity check

rsync -avz -e ssh $usernameRuncloud@$ipRuncloud:webapps/$runcloudAppName/wp-content/uploads public/wp-content/
