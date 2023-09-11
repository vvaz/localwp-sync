#!/bin/bash

# load base variables
DIR="$(pwd)"
conf_file=$DIR/conf.yml

# load variables
ip_address=$(grep "server:" "$conf_file" | awk '{print $2}')
RUNCLOUD_API_KEY=$(grep "api_key:" "$conf_file" | awk '{print $2}')
RUNCLOUD_API_SECRET=$(grep "api_secret:" "$conf_file" | awk '{print $2}')


response=$(curl -s -X GET \
    -u "$RUNCLOUD_API_KEY:$RUNCLOUD_API_SECRET" \
    -H "Accept: application/json" \
    "https://manage.runcloud.io/api/v2/servers"
)

if [ $? -eq 0 ]; then
    server_id=$(echo "$response" | jq -r --arg ip "$ip_address" '.data[] | select(.ipAddress == $ip) | .id')

    if [ -n "$server_id" ]; then
        # echo "Server ID for IP $ip_address: $server_id"
        echo "server_id: $server_id" >> "$conf_file"
    else
        echo "No server found with IP $ip_address."
    fi
else
    echo "Failed to retrieve server list from the Runcloud API."
fi
