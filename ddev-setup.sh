#!/bin/bash

WPPath=--path=public/
current_folder=$(basename "$PWD")

# check if there is a public-old folder
if ! [ -d "public-old" ]; then
  mv public public-old
  mkdir public
fi

# create backup folders
if ! [ -d "backups" ]; then
  echo "Creating backup folders"
  mkdir backups && mkdir backups/db/ && mkdir backups/files/
  echo "DONE"
fi

ddevSetup () {
  # ddev setup
  echo "Setting up DDEV..."
  ddev config --project-name=$current_folder --docroot=public --create-docroot --project-type=wordpress --php-version=7.4
  echo "Done!"
}

# check if there is a .ddev folder
if ! [ -d ".ddev" ]; then
  echo "No .ddev folder found, setting up DDEV..."
  ddevSetup
fi

# Prompt the user for questions and store answers in variables
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your favorite color: " color

# Create a conf YAML file
cat <<EOF >conf.yaml
name: $name
age: $age
color: $color
EOF



<<datfile
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
datfile

<<datfile
# read variables from the .dat file
  while read line; do
    declare $line
    echo $line
  done < variables.dat
datfile

<<test
echo "Cloning the repository..."
git clone $gitRepo public
echo "Done!"

# move wp-config.php to root
echo "creating wp-config from DDEV..."
mv public-old/wp-config.php public/wp-config.php
mv public-old/wp-config-ddev.php public/wp-config-ddev.php
echo "Done!"

# clear public-old
echo "Clear public-old..."
rm -rf public-old
echo "Done!"
test



exit 0
