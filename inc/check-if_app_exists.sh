#!/bin/bash
# load base variables
DIR="$(pwd)"
conf_file=$DIR/conf.yml

# load variables

RUNCLOUD_API_KEY=$(grep "api_key:" "$conf_file" | awk '{print $2}')
RUNCLOUD_API_SECRET=$(grep "api_secret:" "$conf_file" | awk '{print $2}')
server_id=$(grep "server_id:" "$conf_file" | awk '{print $2}')
app_name=$(grep "app_name:" "$conf_file" | awk '{print $2}')
DIR_OPS=$(grep "DIR_OPS:" "$conf_file" | awk '{print $2}')

response=$(curl -s -X GET \
      -u "$RUNCLOUD_API_KEY:$RUNCLOUD_API_SECRET" \
      -H "Accept: application/json" \
      "https://manage.runcloud.io/api/v2/servers/$server_id/webapps"
  )

app_name_exists=$(echo "$response" | jq --arg app_name "$app_name" '.data[] | select(.name == $app_name) | .name')

if [[ -n $app_name_exists ]]; then
  $DIR_OPS/runcloud-to-local/get-app.sh
  get_git_info
else
  # Read the variables from user input
  read -p "username (either new or existing)? " username
  read -p "Live domain name? " live_domain
  read -p "Git owner? " git_owner
  read -p "Git repository? " git_repository

  # Grab the SSH key from ~/.ssh/id_rsa.pub
  ssh_key=$(cat ~/.ssh/id_ed25519.pub)

  # Append the variables to the conf.yml file
  echo "username: $username" >> "$conf_file"
  echo "live_domain: $live_domain" >> "$conf_file"
  echo "git_owner: $git_owner" >> "$conf_file"
  echo "git_repository: $git_repository" >> "$conf_file"
  echo "ssh_key: $ssh_key" >> "$conf_file"
  echo "Variables stored in conf.yml file."
fi
