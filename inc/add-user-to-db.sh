#!/bin/bash

# load base variables
DIR="$(pwd)"
conf_file=$DIR/conf.yml

# load variables

RUNCLOUD_API_KEY=$(grep "runcloudApiKey:" "$conf_file" | awk '{print $2}')
RUNCLOUD_API_SECRET=$(grep "runcloudApiSecret:" "$conf_file" | awk '{print $2}')
server_id=$(grep "server_id:" "$conf_file" | awk '{print $2}')

app_name=$(grep "app_name:" "$conf_file" | awk '{print $2}') # app name
db_id=$(grep "db_id:" "$conf_file" | awk '{print $2}') # db id
db_user_id=$(grep "db_user_id:" "$conf_file" | awk '{print $2}') # db user id

response=$(curl -s --request POST \
  -u "$RUNCLOUD_API_KEY:$RUNCLOUD_API_SECRET" \
  -H "Accept: application/json" \
  -H "content-type: application/json" \
  --data '{
    "id": "'"$db_user_id"'"
      }' \
  "https://manage.runcloud.io/api/v2/servers/$server_id/databases/$db_id/grant"
)

if [ $? -eq 0 ]; then
  echo "Added the user to the database."
fi
