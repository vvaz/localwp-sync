#!/bin/bash

# load base variables
DIR="$(pwd)"
conf_file=$DIR/conf.yml

# load variables

RUNCLOUD_API_KEY=$(grep "api_key:" "$conf_file" | awk '{print $2}')
RUNCLOUD_API_SECRET=$(grep "api_secret:" "$conf_file" | awk '{print $2}')
server_id=$(grep "server_id:" "$conf_file" | awk '{print $2}')
app_name=$(grep "app_name:" "$conf_file" | awk '{print $2}') # app name

propper_app_name=$(echo "$app_name" | tr '-' '_')
ready_app_name="${propper_app_name#app_}"
random_number=$((RANDOM % 9001 + 1000))
db_user=dbUser_"$ready_app_name"_"$random_number"
db_password=$(LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 20)

echo "db_user: $db_user" >> "$conf_file"
echo "db_password: $db_password" >> "$conf_file"


response=$(curl -s --request POST \
  -u "$RUNCLOUD_API_KEY:$RUNCLOUD_API_SECRET" \
  -H "Accept: application/json" \
  -H "content-type: application/json" \
  --data '{
    "username": "'"$db_user"'",
    "password": "'"$db_password"'"
    }' \
  "https://manage.runcloud.io/api/v2/servers/$server_id/databaseusers"
)

if [ $? -eq 0 ]; then
  db_user_id=$(echo "$response" | jq -r ' .id')
  echo "db_user_id: $db_user_id" >> "$conf_file"
fi

echo "Created database user: $db_user"
