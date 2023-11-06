#!/bin/bash

# load base variables
DIR="$(pwd)"
conf_file=$DIR/conf.yml

# load variables

RUNCLOUD_API_KEY=$(grep "runcloudApiKey:" "$conf_file" | awk '{print $2}')
RUNCLOUD_API_SECRET=$(grep "runcloudApiSecret:" "$conf_file" | awk '{print $2}')
server_id=$(grep "server_id:" "$conf_file" | awk '{print $2}')
OS=$(grep "os:" "$conf_file" | awk '{print $2}')
username=$(grep "username:" "$conf_file" | awk '{print $2}')
DIR_OPS=$DIR/ops
ssh_key=$(cat ~/.ssh/id_ed25519.pub)
app_name=$(grep "app_name:" "$conf_file" | awk '{print $2}')
OSkey="$OS"-"ssh-key"-"$app_name"

# Perform the logic to add the SSH key on the server
response=$(curl -s -X POST \
  -u "$RUNCLOUD_API_KEY:$RUNCLOUD_API_SECRET" \
  -H "accept: application/json" \
  -H "content-type: application/json" \
  --data '{
      "label": "'"$OSkey"'",
      "username": "'"$username"'",
      "publicKey": "'"$ssh_key"'"
  }' \
  "https://manage.runcloud.io/api/v2/servers/$server_id/sshcredentials"
)

if [ $? -eq 0 ]; then
    echo "Added the SSH key on the server with ID $server_id."
else
    echo "Failed to add the SSH key on the server with ID $server_id."
fi
