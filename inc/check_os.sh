#!/bin/bash

# load base variables
DIR="$(pwd)"
conf_file=$DIR/conf.yml



# load variables necessary to run on this script

printf "\n"
printf "+----------------+\n"
printf "| Checking OS... |\n"
printf "+----------------+\n"
printf "\n"

# check if OS is already added to conf.yml file

existing_variables=$(grep -E "^(os):" "$conf_file")
  if [ -n "$existing_variables" ]; then
    echo "> OS is already added to conf.yml file"
  else
    if [[ "$OSTYPE" == "darwin"* ]]; then
      OS="m1"
    else
        OS="w11"
    fi
    echo "os: $OS" >> "$conf_file"
    echo "OS stored in conf.yml"
  fi

printf "\n"
