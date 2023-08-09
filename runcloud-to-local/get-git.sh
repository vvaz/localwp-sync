#!/bin/bash

# get variables
conf_file="conf.yml"
RUNCLOUD_API_KEY=$(grep "runcloudApiKey:" "$conf_file" | awk '{print $2}')
RUNCLOUD_API_SECRET=$(grep "runcloudApiSecret:" "$conf_file" | awk '{print $2}')

server_id=$(grep "server_id:" "$conf_file" | awk '{print $2}')
app_id=$(grep "^app_id:" "$conf_file" | awk '{print $2}')

  response=$(curl -s -X GET \
        -u "$RUNCLOUD_API_KEY:$RUNCLOUD_API_SECRET" \
        -H "Accept: application/json" \
        "https://manage.runcloud.io/api/v2/servers/$server_id/webapps/$app_id/git"
    )

echo "$response"
