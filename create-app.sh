#!/bin/bash

# load base variables
DIR="$(pwd)"
conf_file=$DIR/conf.yml

# load variables

RUNCLOUD_API_KEY=$(grep "api_key:" "$conf_file" | awk '{print $2}')
RUNCLOUD_API_SECRET=$(grep "api_secret:" "$conf_file" | awk '{print $2}')
server_id=$(grep "server_id:" "$conf_file" | awk '{print $2}')
app_name=$(grep "app_name:" "$conf_file" | awk '{print $2}')
live_domain=$(grep "live_domain:" "$conf_file" | awk '{print $2}')
git_repository=$(grep "git_repository:" "$conf_file" | awk '{print $2}')
user_id=$(grep "user_id:" "$conf_file" | awk '{print $2}')
username=$(grep "username:" "$conf_file" | awk '{print $2}')
DIR_OPS=$DIR/ops


# functions
check_username() {
  $DIR_OPS/inc/check-username.sh
}

create_app() {
  $DIR_OPS/inc/create-app.sh
}

create_db_user() {
  $DIR_OPS/inc/create-db-user.sh
}

create_db() {
  $DIR_OPS/inc/create-db.sh
}

add_user_to_db() {
  $DIR_OPS/inc/add-user-to-db.sh
}

add_github() {
  $DIR_OPS/inc/add-github.sh
}

add_deploy_key(){
  $DIR_OPS/inc/add-deploy-key.sh
}

add_webhook() {
  $DIR_OPS/inc/add-webhook.sh
}

list_apps() {
  $DIR_OPS/inc/list-apps.sh
}

check_username

list_apps
create_app
create_db_user
create_db
add_deploy_key
add_github
add_webhook
add_user_to_db
