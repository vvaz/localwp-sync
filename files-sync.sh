#!/bin/bash

WPPath=--path=public/
conf_file="conf.yml"

username=$(grep "username:" "$conf_file" | awk '{print $2}') # username
server=$(grep "server:" "$conf_file" | awk '{print $2}') # IP address of the server
app_name=$(grep "app_name:" "$conf_file" | awk '{print $2}') # app name
live_domain=$(grep "live_domain:" "$conf_file" | awk '{print $2}') # live domain
dev_domain=https://merch.getquick.io.ddev.site # dev domain
ssh_key=$(grep "ssh_key:" "$conf_file" | awk '{print $2}') # ssh key


# STOP EDITING
# Welcome message / sanity check

rsync -avz -e ssh $username@$server:webapps/$app_name/wp-content/uploads public/wp-content/
