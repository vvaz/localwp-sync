#!/bin/bash

WPPath=--path=public/
conf_file="conf.yml"
mysqlFile=mysql.sql
current_time=$(date "+%Y.%m.%d-%H.%M.%S")
mysqlFileTime=$current_time.$mysqlFile


username=$(grep "username:" "$conf_file" | awk '{print $2}') # username
server=$(grep "server:" "$conf_file" | awk '{print $2}') # IP address of the server
app_name=$(grep "app_name:" "$conf_file" | awk '{print $2}') # app name
live_domain=$(grep "live_domain:" "$conf_file" | awk '{print $2}') # live domain
dev_domain=https://impakttv.ddev.site # dev domain
ssh_key=$(grep "ssh_key:" "$conf_file" | awk '{print $2}') # ssh key

#echo "Server: $server"
#echo "App Name: $app_name"
#echo "Live Domain: $live_domain"
#echo "username: $username"

# exit 0

# STOP EDITING
# Welcome message / sanity check
echo "Running Pull for PROD site: $live_domain"
# Create db dump named 'mysql.sql'
echo "Dumping database on PROD"
ssh $username@$server "cd webapps/$app_name && wp db export mysql.sql"
# Copy db dump to local
echo "Copying to LOCAL"
scp $username@$server:/home/$username/webapps/$app_name/mysql.sql public/mysql.sql

# Delete db dump from prod server
echo "Cleaning up PROD"
ssh $username@$server "cd webapps/$app_name && rm mysql.sql"

# Import db dump locally
echo "Importing on LOCAL"
ddev wp db import public/mysql.sql $WPPath
# Search & Replace the site url
echo "Fixing site url"
ddev wp search-replace https://$live_domain $dev_domain $WPPath
ddev wp search-replace https://www.$live_domain $dev_domain $WPPath
ddev wp search-replace http://www.$live_domain $dev_domain $WPPath
ddev wp search-replace http://$live_domain $dev_domain $WPPath
ddev wp search-replace http://$live_domain $dev_domain $WPPath
echo "Adding dev user"
ddev wp user create dev dev@wpbox.io --role=administrator --user_pass=dev  $WPPath
echo "Created user: dev / pass: dev"

echo "backing up mysql"
mv public/$mysqlFile public/$mysqlFileTime
mv public/$mysqlFileTime backups/db/$mysqlFileTime
gzip backups/db/$mysqlFileTime
echo "Stored a database backup in backups/db/"
echo "Clean up FINISHED"

echo "All done"

exit 0
