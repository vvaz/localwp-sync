#!/bin/bash

WPPath=--path=public/
# read variables from the .dat file
while read line; do    
    declare $line    
done < variables.dat

# STOP EDITING
# Welcome message / sanity check

# Get the uploads (excluding log files)
echo "Zip PROD uploads"
ssh $usernameRuncloud@$ipRuncloud "cd webapps/$runcloudAppName/wp-content && zip -r uploads.zip uploads"
echo "clear local uploads"
rm -rf public/wp-content/uploads
echo "Downloading uploads from PROD"
scp $usernameRuncloud@$ipRuncloud:/home/$usernameRuncloud/webapps/$runcloudAppName/wp-content/uploads.zip public/wp-content/uploads.zip
echo "clearing uploads.zip on PROD"
ssh $usernameRuncloud@$ipRuncloud "cd webapps/$runcloudAppName/wp-content && rm -rf uploads.zip"
echo "Unziping uploads on LOCAL"
unzip public/wp-content/uploads.zip -d public/wp-content/
# Clean Up
echo "Cleaning up LOCAL"
rm public/wp-content/uploads.zip
echo "removed uploads.zip from LOCAL"
