#!/bin/bash

# load base variables
DIR="$(pwd)"
conf_file=$DIR/conf.yml

# load variables
DIR_OPS=$(grep "DIR_OPS:" "$conf_file" | awk '{print $2}')

# functions
check_server_id_by_ip() {
  $DIR_OPS/inc/check-server_id_by_ip.sh
}

check_if_app_exists() {
  $DIR_OPS/inc/check-if_app_exists.sh
}

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

  check_server_id_by_ip

  read -p "app name (either new or existing)? " app_name
  echo "app_name: $app_name" >> "$conf_file"

  check_if_app_exists
