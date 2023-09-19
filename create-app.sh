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
  sleep 1
  echo "> Username fuctions"
  $DIR_OPS/inc/check-username.sh
}

create_app() {
  sleep 1
  echo "> Create app"
  $DIR_OPS/inc/create-app.sh
}

create_db_user() {
  sleep 1
  echo "> Create db user"
  $DIR_OPS/inc/create-db-user.sh
}

create_db() {
  sleep 1
  echo "> Create db"
  $DIR_OPS/inc/create-db.sh
}

add_user_to_db() {
  sleep 1
  echo "> Add user to db"
  $DIR_OPS/inc/add-user-to-db.sh
}

add_github() {
  sleep 1
  echo "> Add github repo to app"
  $DIR_OPS/inc/add-github.sh
}

add_deploy_key(){
  sleep 1
  echo "> Add deploy key"
  $DIR_OPS/inc/add-deploy-key.sh
}

add_webhook() {
  sleep 1
  echo "> Add webhook to github"
  $DIR_OPS/inc/add-webhook.sh
}

list_apps() {
  sleep 1
  echo "> List apps"
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
