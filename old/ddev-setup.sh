#!/bin/bash

conf_file="conf.yml"
WPPath=--path=public/
current_folder=$(basename "$PWD")

ddevSetup () {
  # ddev setup
  echo "Setting up DDEV..."
  ddev config --project-name=$current_folder --docroot=public --create-docroot --project-type=wordpress --php-version=7.4
  echo "Done!"
}


cloneRepo () {
  git_owner=$(grep "git_owner:" "$conf_file" | awk '{print $2}') # github owner
  git_repo=$(grep "git_repo:" "$conf_file" | awk '{print $2}') # git repository
  gitRepo=git@github.com:$git_owner/$git_repo.git

  # clone repo
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
}

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

# check if there is a .ddev folder
if ! [ -d ".ddev" ]; then
  echo "No .ddev folder found, setting up DDEV..."
  ddevSetup
fi

# Prompt the user for questions and store answers in variables
# read -p "Enter your name: " name
# Create a conf YAML file
# cat <<EOF >conf.yml
# name: $name
#EOF

cloneRepo

exit 0
