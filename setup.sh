#!/bin/bash

$WPPath=--path="public//"

# create backup folders
echo "Creating backup folders"
mkdir backups && mkdir backups/db/ && mkdir backups/files/
echo "DONE"

# getting variables
# echo "What is your site name on LOCAL?"
# read siteName
# echo "siteName=$siteName" > variables.dat
# echo "What is the IP of the LIVE server?"
# read ipRuncloud
# echo "ipRuncloud=$ipRuncloud" >> variables.dat
# echo "What is the your RunCloud username?"
# read usernameRuncloud
# echo "usernameRuncloud=$usernameRuncloud" >> variables.dat
# echo "What is your app-name on RunCloud?"
# read runcloudAppName
# echo "runcloudAppName=$runcloudAppName" >> variables.dat

# clearing public and adding a Git repo
rm -rf public
mkdir public
echo "Github repository (https url):"
read gitRepo
echo "gitRepo=$gitRepo" >> variables.dat
echo "Cloning the repository..."
# git clone git@github.com:\${gitRepo}.git:public
git clone $gitRepo public
echo "Done!"

# adding a wp-config.php file
echo "Adding wp-config.php with Local variables"
cp wp-config.php public/wp-config.php
echo "Done"
echo "Shuffling salts"
wp config shuffle-salts $WPPath
echo "Done"
echo "Creating dev username"
wp user create dev dev@wpbox.io --role=administrator --user_pass=dev $WPPath
echo "Done"
echo "Caching flush"
wp cache flush $WPPath
echo "Cache flushed"
