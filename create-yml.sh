#!/bin/bash

# Read API_KEY and API_SECRET from conf.yml file
DIR="$(pwd)"
DIR_OPS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
conf_file=$DIR/conf.yml

printf "\n"
printf "+---------------------+\n"
printf "| Saving base DIRS... |\n"
printf "+---------------------+\n"
printf "\n"

# check if DIR and DIR_OPS are already in the conf.yml file
existing_variables=$(grep -E "^(DIR|DIR_OPS):" "$conf_file")
if [ -n "$existing_variables" ]; then
  echo "DIR and DIR_OPS are already stored on the conf.yml"
else
  echo "DIR: $DIR" >> "$conf_file"
  echo "DIR_OPS: $DIR_OPS" >> "$conf_file"
  echo "DIR and DIR_OPS were stored in conf.yml"
fi


# ensure everyfile have execute permission
chmod +x $DIR_OPS/inc/*.sh

# clear

# add OS to conf.yml
check_os() {
  $DIR_OPS/inc/check_os.sh
}

# Function to check if variables exist in the conf.yml file
check_existing_variables() {
  $DIR_OPS/inc/check_existing_variables.sh
}

# Function to store variables in the conf.yml file
store_variables() {
  $DIR_OPS/inc/store_variables.sh
}

# Function to find server ID by IP
find_server_id_by_ip() {
  $DIR_OPS/inc/find_server_id_by_ip.sh
}

check_if_app_exists() {
  $DIR_OPS/inc/check_if_app_exists.sh
}

get_git_info() {
  echo "get git"
  ./ops/runcloud-to-local/get-git.sh
}

# run the functions

# check operating system
check_os

# get_git_info

# check if variables exist in the conf.yml file
check_existing_variables
