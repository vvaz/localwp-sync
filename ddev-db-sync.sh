#!/bin/bash

WPPath=--path=public/

mysqlFile=mysql.sql
current_time=$(date "+%Y.%m.%d-%H.%M.%S")
mysqlFileTime=$current_time.$mysqlFile

# read variables from the .dat file
while read line; do
    declare $line
    echo $line
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
wp db import public/mysql.sql $WPPath
# Search & Replace the site url
echo "Fixing site url"
wp search-replace https://$runcloudDomain http://localhost:10043 $WPPath
wp search-replace http://$runcloudDomain http://localhost:10043 $WPPath
wp search-replace http://$runcloudDomain http://localhost:10043 $WPPath
echo "Adding dev user"
wp user create dev dev@wpbox.io --role=administrator --user_pass=dev  $WPPath
echo "Created user: dev / pass: dev"

echo "backing up mysql"
mv public/$mysqlFile public/$mysqlFileTime
mv public/$mysqlFileTime backups/db/$mysqlFileTime
gzip backups/db/$mysqlFileTime
echo "Stored a database backup in backups/db/"
echo "Clean up FINISHED"

echo "All done"
exit 0
