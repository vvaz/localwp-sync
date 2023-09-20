#!/bin/bash

# load base variables
DIR="$(pwd)"
conf_file=$DIR/conf.yml

# load variables

RUNCLOUD_API_KEY=$(grep "api_key:" "$conf_file" | awk '{print $2}')
RUNCLOUD_API_SECRET=$(grep "api_secret:" "$conf_file" | awk '{print $2}')
server_id=$(grep "server_id:" "$conf_file" | awk '{print $2}')
username=$(grep "username:" "$conf_file" | awk '{print $2}')
DIR_OPS=$(grep "DIR_OPS:" "$conf_file" | awk '{print $2}')

printf "\n"
printf "+----------------------+\n"
printf "| Checking username... |\n"
printf "+----------------------+\n"
printf "\n"

create_username() {
  $DIR_OPS/inc/create-username.sh
}

check_username() {

    response2=$(curl -s -D - -X GET \
        -u "$RUNCLOUD_API_KEY:$RUNCLOUD_API_SECRET" \
        -H "Accept: application/json" \
        "https://manage.runcloud.io/api/v2/servers/$server_id/users"
    )

    headers=$(echo "$response2" | grep -E 'HTTP|^[A-Za-z-]+:' | sed 's/\r$//')
    body=$(echo "$response2" | sed -n '/^\r$/,$p' | sed '1d')

    : '
    echo "headers:"
    echo "$headers"

    echo "body:"
    echo "$body"
    '

    # Extract the HTTP status code
    http_status_code=$(echo "$headers" | grep -oP 'HTTP/\d+ \K\d+')


    echo "http_status_code: $http_status_code"

    # Check if the status code is 200
    if [ "$http_status_code" -eq 200 ]; then
        echo "Success: Received HTTP 200 status code."

        exists=$(echo "$response" | jq -r ".data[] | select(.username == \"$username\")")

        if [ -n "$exists" ]; then
            echo "The username $username exists on the server with ID $server_id."
        else
            echo "The username $username does not exist on the server with ID $server_id."
            # Perform the logic to create the username on the server
            create_username "$username" "$server_id"
        fi
    else
        echo "Error: Did not receive HTTP 200 status code. Received HTTP $http_status_code status code instead."
        echo "Failed to retrieve user list from the Runcloud API."
        exit
    fi


    : '
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
    '
}


# run the functions
check_username
