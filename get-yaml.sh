#!/bin/bash

# Read API_KEY and API_SECRET from conf.yml file
conf_file="conf.yml"
API_KEY=$(grep "api_key:" "$conf_file" | awk '{print $2}')
API_SECRET=$(grep "api_secret:" "$conf_file" | awk '{print $2}')

# Function to check if variables exist in the conf.yml file
check_existing_variables() {
    existing_variables=$(grep -E "^(server|username|app_name|git_repository|server_id):" "$conf_file")

    if [ -n "$existing_variables" ]; then
        echo "Existing variables found in conf.yml file:"
        echo "$existing_variables"
        return 0
    else
        echo "No existing variables found in conf.yml file."
        return 1
    fi
}

# Function to store variables in the conf.yml file
store_variables() {
  # Prompt the user for input
# Prompt the user for input
options=(
  "DEV - Development Server - Vultr"
  "Low Traffic Websites - Vultr"
  "Medium Sites - Vultr"
  "Tipme Staff - Vultr"
  "Other - Enter IP"
)
PS3="Select an option (default: 1): "

default_option=1

# Display options with new lines
for ((i=1; i<=${#options[@]}; i++))
do
  printf "%d) %s\n" "$i" "${options[$i-1]}"
done

# Read user input
read -p "Select an option (default: 1): " selection
selection=${selection:-$default_option}

case $selection in
  1)
    live_server="65.20.98.212"
    ;;
  2)
    live_server="65.20.99.224"
    ;;
  3)
    live_server="208.85.20.59"
    ;;
  4)
    live_server="208.85.19.209"
    ;;
  5)
    read -p "Enter the IP address for the server: " live_server
    ;;
  *)
    live_server="65.20.99.224"
    ;;
esac

   echo "server: $live_server" >> "$conf_file"

    # Read the variables from user input
    read -p "What is the username (either new or existing)? " username
    read -p "What is the app name (either new or existing? " app_name
    read -p "What is the git repository? " git_repository

    find_server_id_by_ip
    # Append the variables to the conf.yml file
    echo "username: $username" >> "$conf_file"
    echo "app_name: $app_name" >> "$conf_file"
    echo "git_repository: $git_repository" >> "$conf_file"
    echo "server_id: $server_id" >> "$conf_file"
    echo "Variables stored in conf.yml file."
}

# Function to find server ID by IP
find_server_id_by_ip() {
    ip_address=$(grep "server:" "$conf_file" | awk '{print $2}') # IP address of the server

    response=$(curl -s -X GET \
        -u "$API_KEY:$API_SECRET" \
        -H "Accept: application/json" \
        "https://manage.runcloud.io/api/v2/servers"
    )

    if [ $? -eq 0 ]; then
        server_id=$(echo "$response" | jq -r --arg ip "$ip_address" '.data[] | select(.ipAddress == $ip) | .id')

        if [ -n "$server_id" ]; then
            echo "Server ID for IP $ip_address: $server_id"
            # echo "server_id: $server_id" >> "$conf_file"
        else
            echo "No server found with IP $ip_address."
        fi
    else
        echo "Failed to retrieve server list from the Runcloud API."
    fi
}

check_username_existence() {
    server_id=$(grep "server_id:" "$conf_file" | awk '{print $2}')
    username=$(grep "username:" "$conf_file" | awk '{print $2}')

    response=$(curl -s -X GET \
        -u "$API_KEY:$API_SECRET" \
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
        -u "$API_KEY:$API_SECRET" \
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
        echo "Created the username $username on the server with ID $server_id."
        echo "Password is $password"
    else
        echo "Failed to create the username $username on the server with ID $server_id."
    fi
}


# Check if variables exist in conf.yml file
if check_existing_variables; then
    # Variables exist, perform necessary operations
    echo "Performing necessary operations with existing variables."

    # find_server_id_by_ip

    echo "variables found"

    # check_username_existence
    check_username_existence

else
    # Variables don't exist, store the variables
    echo "Storing variables."
    store_variables
fi
