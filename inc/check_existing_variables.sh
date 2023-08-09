#!/bin/bash
conf_file="conf.yml"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
existing_variables=$(grep -E "^(server|username|app_name|git_repository|server_id):" "$conf_file")

return_existing_variables() {
  if [ -n "$existing_variables" ]; then
      echo "Existing variables found in conf.yml file:"
      echo "$existing_variables"
      return 0
  else
      return 1
  fi
}

# Check the return value
if [ $? -eq 0 ]; then
  echo "Variables exist in conf.yml"
else
  echo "No existing variables found in conf.yml file."
  store_variables
fi


store_variables() {
  $DIR/inc/store_variables.sh
}
