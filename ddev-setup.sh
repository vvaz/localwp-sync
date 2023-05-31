#!/bin/bash

WPPath=--path=public/

# create backup folders
echo "Creating backup folders"
mkdir ../backups && mkdir ../backups/db/ && mkdir ../backups/files/
echo "DONE"

# getting variables
echo "=================================="
echo "==            DDEV              =="
echo "=================================="
echo "What is your site name on DDEV?"
read siteName
echo "siteName=$siteName" > variables.dat
# echo "What is your db port on LOCAL"
# read dbport
# echo "dbport=$dbport" >> variables.dat
echo "=================================="
echo "==      LIVE / Runcloud         =="
echo "=================================="
echo "What is the IP of the LIVE server?"
read ipRuncloud
echo "ipRuncloud=$ipRuncloud" >> variables.dat
echo "What is the your RunCloud username?"
read usernameRuncloud
echo "usernameRuncloud=$usernameRuncloud" >> variables.dat
echo "What is your app-name on RunCloud?"
read runcloudAppName
echo "runcloudAppName=$runcloudAppName" >> variables.dat
echo "What is your Runcloud domain"
read runcloudDomain
echo "runcloudDomain=$runcloudDomain" >> variables.dat

# clearing public and adding a Git repo
rm -rf ../public
mkdir ../public
echo "Github repository (git@url):"
read gitRepo
echo "Cloning the repository..."
git clone $gitRepo public
echo "Done!"

# adding a wp-config.php file
# echo "Adding wp-config.php with Local variables"
# cp wp-config.php public/wp-config.php
# echo "Done"
# echo "Shuffling salts"
# wp config shuffle-salts $WPPath
# clear
# echo "Done"

####################
# echo "Create wp-config.php"
# wp config create --dbname=local --dbuser=root --dbpass=root --dbhost=localhost:$dbport $WPPath
# echo "Creating dev username"
# wp user create dev dev@wpbox.io --role=administrator --user_pass=dev $WPPath
# echo "Done"
# echo "Caching flush"
# wp cache flush --dbhost=localhost:$dbport $WPPath
# echo "Cache flushed"
exit 0