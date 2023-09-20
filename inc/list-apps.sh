#!/bin/bash

# load base variables
DIR="$(pwd)"
conf_file=$DIR/conf.yml

# variables
RUNCLOUD_API_KEY=$(grep "api_key:" "$conf_file" | awk '{print $2}')
RUNCLOUD_API_SECRET=$(grep "api_secret:" "$conf_file" | awk '{print $2}')
server_id=$(grep "server_id:" "$conf_file" | awk '{print $2}') # IP address of the server

response=$(curl -s --request GET \
  -u "$RUNCLOUD_API_KEY:$RUNCLOUD_API_SECRET" \
  -H "Accept: application/json" \
  -H "content-type: application/json" \
    "https://manage.runcloud.io/api/v2/servers/$server_id/webapps/"
  )


# debug
echo "$response" | jq -r '.data[] | "\(.id) \(.name)"' | column -t
