#!/bin/bash

# create backup folders
# echo "Creating backup folders"
# cd .. && mkdir backups && mkdir backups/db/
# echo "DONE"

# getting variables
echo "Whats your site name on LOCAL?"
read siteName
echo "siteName=$siteName" > variables.dat
echo "Whats the IP of the LIVE server?"
read ipRuncloud
echo "ipRuncloud=$ipRuncloud" >> variables.dat
echo "What is the your RunCloud username?"
read usernameRuncloud
echo "usernameRuncloud=$usernameRuncloud" >> variables.dat
echo "What is your app-name on RunCloud?"
read runcloudAppName
echo "runcloudAppName=$runcloudAppName" >> variables.dat

# clearing public and adding a Git repo
