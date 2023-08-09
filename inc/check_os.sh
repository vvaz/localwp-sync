#!/bin/bash
conf_file="conf.yml"

clear
echo "Checking OS..."

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

echo ""
