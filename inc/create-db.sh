#!/bin/bash

# load base variables
DIR="$(pwd)"
conf_file=$DIR/conf.yml

# load variables

RUNCLOUD_API_KEY=$(grep "api_key:" "$conf_file" | awk '{print $2}')
RUNCLOUD_API_SECRET=$(grep "api_secret:" "$conf_file" | awk '{print $2}')
server_id=$(grep "server_id:" "$conf_file" | awk '{print $2}')

app_name=$(grep "app_name:" "$conf_file" | awk '{print $2}') # app name
db_user_id=$(grep "db_user_id:" "$conf_file" | awk '{print $2}') # db user id

propper_app_name=$(echo "$app_name" | tr '-' '_')
ready_app_name="${propper_app_name#app_}"
random_number=$((RANDOM % 9001 + 1000))
db_name=db_"$ready_app_name"_"$random_number"

echo "db_name: $db_name" >> "$conf_file"

response=$(curl -s --request POST \
  -u "$RUNCLOUD_API_KEY:$RUNCLOUD_API_SECRET" \
  -H "Accept: application/json" \
  -H "content-type: application/json" \
  --data '{
    "name": "'"$db_name"'",
    "collation": "utf8mb4_unicode_ci",
    "user": "'"$db_user_id"'"
      }' \
  "https://manage.runcloud.io/api/v2/servers/$server_id/databases"
)

if [ $? -eq 0 ]; then
  db_id=$(echo "$response" | jq -r ' .id')
  echo "db_id: $db_id" >> "$conf_file"
fi

# echo $response

echo "Created the database."
