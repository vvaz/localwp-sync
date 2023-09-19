#!/bin/bash

# load base variables
DIR="$(pwd)"
conf_file=$DIR/conf.yml

# load variables

RUNCLOUD_API_KEY=$(grep "api_key:" "$conf_file" | awk '{print $2}')
RUNCLOUD_API_SECRET=$(grep "api_secret:" "$conf_file" | awk '{print $2}')
server_id=$(grep "server_id:" "$conf_file" | awk '{print $2}')

app_id=$(grep "app_id:" "$conf_file" | awk '{print $2}') # app id
#git_repository=$(grep "git_repository:" "$conf_file" | awk '{print $2}') # git repository
pullKey1=$(grep "pullKey1:" "$conf_file" | awk '{print $2}') # pull key 1
pullKey2=$(grep "pullKey2:" "$conf_file" | awk '{print $2}') # pull key 2

git_owner=$(grep "git_owner:" "$conf_file" | awk '{print $2}') # github owner
git_repo=$(grep "git_repository:" "$conf_file" | awk '{print $2}') # git repository

response=$(curl -s --request POST \
  -u "$RUNCLOUD_API_KEY:$RUNCLOUD_API_SECRET" \
  -H "Accept: application/json" \
  -H "content-type: application/json" \
  --data "{
      \"provider\": \"github\",
      \"repository\": \"$git_owner/$git_repo\",
      \"branch\": \"main\"
    }" \
  "https://manage.runcloud.io/api/v2/servers/$server_id/webapps/$app_id/git"
)

  echo "$response"
  echo "Added the github repository to the app."
