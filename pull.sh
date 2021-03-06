#!/bin/bash

WPPath=--path=public/
# read variables from the .dat file
while read line; do    
    declare $line    
done < variables.dat

# STOP EDITING
# Welcome message / sanity check
echo "Running Pull for PROD site: $siteName"
# Create db dump named 'mysql.sql'
echo "Dumping database on PROD"
ssh $usernameRuncloud@$ipRuncloud "cd webapps/$runcloudAppName && wp db export mysql.sql"
# Copy db dump to local
echo "Copying to LOCAL"
scp $usernameRuncloud@$ipRuncloud:/home/$usernameRuncloud/webapps/$runcloudAppName/mysql.sql public/mysql.sql
# Delete db dump from prod server
echo "Cleaning up PROD"
ssh $usernameRuncloud@$ipRuncloud "cd webapps/$runcloudAppName && rm mysql.sql"
# Import db dump locally
echo "Importing on LOCAL"
wp db import public/mysql.sql --path=public/
# Search & Replace the site url
echo "Fixing site url"
wp search-replace "$runcloudDomain" "http://$siteName.local" $WPPath
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
rm public/mysql.sql
echo "removed mysql.sql from LOCAL"