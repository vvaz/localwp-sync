#!/bin/bash

# load base variables
DIR="$(pwd)"
conf_file=$DIR/conf.yml

# load variables
existing_variables=$(grep -E "^(server):" "$conf_file")
DIR_OPS=$(grep "DIR_OPS:" "$conf_file" | awk '{print $2}')

# functions
store_variables() {
  $DIR_OPS/inc/store-variables.sh
}

return_existing_variables() {
  if [ -n "$existing_variables" ]; then
    # server exists
    echo "Existing variables found in conf.yml"
  else
    # server does NOT exist
    store_variables
  fi
}

# actions
return_existing_variables
