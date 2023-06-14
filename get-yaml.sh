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
  options=(
    " DEV - Development Server - Vultr\n"
    " Low Traffic Websites - Vultr\n"
    " Medium Sites - Vultr\n"
    " Other - Enter IP\n"
  )
  PS3="Select an option (default: 1): "

  default_option=1

  select opt in "${options[@]}"
  do
    case $REPLY in
      1)
          live_server="65.20.98.212"
          break
          ;;
      2)
          live_server="65.20.99.224"
          break
          ;;
      3)
          live_server="208.85.19.209"
          break
          ;;
      4)
          read -p "Enter the IP address for the server: " live_server
          break
          ;;
      *)
          if [[ $REPLY == $default_option ]]; then
              live_server="65.20.99.224"
              break
          else
              echo "Invalid option selected. Please try again."
          fi
          ;;
    esac
  done

   echo "server: $live_server" >> "$conf_file"

    # Read the variables from user input
    read -p "What is the username? " username
    read -p "What is the app name? " app_name
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

# Check if variables exist in conf.yml file
if check_existing_variables; then
    # Variables exist, perform necessary operations
    echo "Performing necessary operations with existing variables."
    # Call the appropriate functions based on your requirements
    # For example:
    # website_server_status
    find_server_id_by_ip
else
    # Variables don't exist, store the variables
    echo "Storing variables."
    store_variables
fi
