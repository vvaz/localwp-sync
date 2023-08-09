#!/bin/bash

# Read API_KEY and API_SECRET from conf.yml file
conf_file="conf.yml"
RUNCLOUD_API_KEY=$(grep "runcloudApiKey:" "$conf_file" | awk '{print $2}')
RUNCLOUD_API_SECRET=$(grep "runcloudApiSecret:" "$conf_file" | awk '{print $2}')
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# ensure everyfile have execute permission
chmod +x $DIR/inc/*.sh

# add OS to conf.yml
check_os() {
  $DIR/inc/check_os.sh
}

# Function to check if variables exist in the conf.yml file
check_existing_variables() {
  $DIR/inc/check_existing_variables.sh
}

# Function to store variables in the conf.yml file
store_variables() {
  $DIR/inc/store_variables.sh
}

# Function to find server ID by IP
find_server_id_by_ip() {
  $DIR/inc/find_server_id_by_ip.sh
}

check_if_app_exists() {

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
