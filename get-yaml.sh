#!/bin/bash

# Prompt the user for input
options=(
    "- DEV - Development Server - Vultr\n"
    "- Low Traffic Websites - Vultr\n"
    "- Medium Sites - Vultr\n"
    "- Other - Enter IP\n"
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

read -p "What is the username? " username
read -p "What is the app name? " app_name
read -p "What is the git repository? " git_repository

# Create a YAML file and store the variables
cat << EOF > conf.yml
server: $live_server
username: $username
app_name: $app_name
git_repository: $git_repository
EOF

echo "Variables stored in conf.yml file."
