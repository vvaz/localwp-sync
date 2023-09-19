#!/bin/bash

# load base variables
DIR="$(pwd)"
conf_file=$DIR/conf.yml

# load variables

RUNCLOUD_API_KEY=$(grep "api_key:" "$conf_file" | awk '{print $2}')
RUNCLOUD_API_SECRET=$(grep "api_secret:" "$conf_file" | awk '{print $2}')
server_id=$(grep "server_id:" "$conf_file" | awk '{print $2}')
user_id=$(grep "^user_id:" "$conf_file" | awk '{print $2}')

# Perform the logic to generate the deployment key on the server


response=$(curl --request PATCH \
  --url "https://manage.runcloud.io/api/v2/servers/$server_id/users/$user_id/deploymentkey" \
  -u "$RUNCLOUD_API_KEY:$RUNCLOUD_API_SECRET" \
  --header "accept: application/json" \
  --header "content-type: application/json")


if [ $? -eq 0 ]; then
    git_deployment_key=$(echo "$response" | jq -r ' .deploymentKey')
    # echo "Git deployment key: $git_deployment_key"
    echo "git_deployment_key: $git_deployment_key" >> "$conf_file"
    echo "Generated the deployment key."
fi
