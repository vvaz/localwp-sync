#!/bin/bash

WPPath=--path=../public/

  # clearing public and adding a Git repo
  mv ../public ../public-old
  mkdir ../public

if ! [ -d "../backups" ]; then
  # create backup folders
  echo "Creating backup folders"
  mkdir ../backups && mkdir ../backups/db/ && mkdir ../backups/files/
  echo "DONE"
fi

if ! [ -e "variables.dat" ]; then
  echo "variables.dat file not found, creating one..."
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
  echo "Github repository (git@url):"
  read gitRepo
  echo "gitRepo=$gitRepo" >> variables.dat
fi

# read variables from the .dat file
  while read line; do
    declare $line
    echo $line
  done < variables.dat

echo "Cloning the repository..."
git clone $gitRepo ../public
echo "Done!"

# move wp-config.php to root
echo "creating wp-config from DDEV..."
mv ../public-old/wp-config.php ../public/wp-config.php
mv ../public-old/wp-config-ddev.php ../public/wp-config-ddev.php
echo "Done!"

# clear public-old
rm -rf ../public-old
echo "Done!"

exit 0
