#!/bin/bash

# load base variables
DIR="$(pwd)"
conf_file=$DIR/conf.yml

# load variables

RUNCLOUD_API_KEY=$(grep "runcloudApiKey:" "$conf_file" | awk '{print $2}')
RUNCLOUD_API_SECRET=$(grep "runcloudApiSecret:" "$conf_file" | awk '{print $2}')
server_id=$(grep "server_id:" "$conf_file" | awk '{print $2}')
DIR_OPS=$(grep "DIR_OPS:" "$conf_file" | awk '{print $2}')
username=$(grep "username:" "$conf_file" | awk '{print $2}')

# Generate a random password with 20 characters
password=$(LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 20)
echo "password: $password" >> "$conf_file"

create_deploy_key() {
  $DIR_OPS/inc/create-deploy_key.sh
}

add_deploy_key_github() {
  $DIR_OPS/inc/add-deploy-key-github.sh
}

add_ssh_key() {
  $DIR_OPS/inc/add-ssh-key.sh
}

# Perform the logic to create the username on the server
response=$(curl -s -X POST \
    -u "$RUNCLOUD_API_KEY:$RUNCLOUD_API_SECRET" \
    -H "accept: application/json" \
    -H "content-type: application/json" \
    --data '{
        "username": "'"$username"'",
        "password": "'"$password"'",
        "shell": "/bin/rc-shell"
    }' \
    "https://manage.runcloud.io/api/v2/servers/$server_id/users"
)


if [ $? -eq 0 ]; then
  user_id=$(echo "$response" | jq -r '.id')
  echo "Created the username $username on the server with ID $server_id."
  echo "Password is $password"
  echo "user_id: $user_id" >> "$conf_file"  # Save the user ID in conf.yml

  echo "Generating the deployment key..."
  create_deploy_key
  # add_deploy_key_github
else
  echo "Failed to create the username $username on the server with ID $server_id."
fi
