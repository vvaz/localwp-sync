#!/bin/bash

# load base variables
DIR="$(pwd)"
conf_file=$DIR/conf.yml

# load variables

RUNCLOUD_API_KEY=$(grep "api_key:" "$conf_file" | awk '{print $2}')
RUNCLOUD_API_SECRET=$(grep "api_secret:" "$conf_file" | awk '{print $2}')
server_id=$(grep "server_id:" "$conf_file" | awk '{print $2}')
username=$(grep "username:" "$conf_file" | awk '{print $2}')

echo "Checking if username exists"

check_username() {
    response=$(curl -s -X GET \
        -u "$RUNCLOUD_API_KEY:$RUNCLOUD_API_SECRET" \
        -H "Accept: application/json" \
        "https://manage.runcloud.io/api/v2/servers/$server_id/users"
    )

    if [ $? -eq 0 ]; then
        exists=$(echo "$response" | jq -r ".data[] | select(.username == \"$username\")")

        if [ -n "$exists" ]; then
            echo "The username $username exists on the server with ID $server_id."
        else
            echo "The username $username does not exist on the server with ID $server_id."
            # Perform the logic to create the username on the server
            create_username "$username" "$server_id"
        fi
    else
        echo "Failed to retrieve user list from the Runcloud API."
    fi
}

create_username() {
    local username=$1
    local server_id=$2

    # Generate a random password with 20 characters
    password=$(LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 20)
    echo "password: $password" >> "$conf_file"


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

      # echo $response

      echo "Created the username $username on the server with ID $server_id."
      echo "Password is $password"
      echo "user_id: $user_id" >> "$conf_file"  # Save the user ID in conf.yml
    else
      echo "Failed to create the username $username on the server with ID $server_id."
    fi
}


check_username
