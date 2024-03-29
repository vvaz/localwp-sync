#!/bin/bash

# Read API_KEY and API_SECRET from conf.yml file
conf_file="conf.yml"
RUNCLOUD_API_KEY=$(grep "runcloudApiKey:" "$conf_file" | awk '{print $2}')
RUNCLOUD_API_SECRET=$(grep "runcloudApiSecret:" "$conf_file" | awk '{print $2}')

if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="m1"
else
    OS="w11"
fi

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
  read -p "username (either new or existing)? " username
  read -p "app name (either new or existing)? " app_name
  read -p "Live domain name? " live_domain
  # read -p "What is the git repository? " git_repository
  read -p "Git owner? " git_owner
  read -p "Git repository? " git_repository


  # Grab the SSH key from ~/.ssh/id_rsa.pub
  ssh_key=$(cat ~/.ssh/id_ed25519.pub)

  find_server_id_by_ip

  # Append the variables to the conf.yml file
  echo "username: $username" >> "$conf_file"
  echo "app_name: $app_name" >> "$conf_file"
  echo "live_domain: $live_domain" >> "$conf_file"
  echo "git_owner: $git_owner" >> "$conf_file"
  echo "git_repository: $git_repository" >> "$conf_file"
  echo "server_id: $server_id" >> "$conf_file"
  echo "ssh_key: $ssh_key" >> "$conf_file"
  echo "Variables stored in conf.yml file."
}

# Function to find server ID by IP
find_server_id_by_ip() {
    ip_address=$(grep "server:" "$conf_file" | awk '{print $2}') # IP address of the server

    response=$(curl -s -X GET \
        -u "$RUNCLOUD_API_KEY:$RUNCLOUD_API_SECRET" \
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
