
check_username_existence() {
    server_id=$(grep "server_id:" "$conf_file" | awk '{print $2}')
    username=$(grep "username:" "$conf_file" | awk '{print $2}')

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
}

create_username() {
    local username=$1
    local server_id=$2

    # Generate a random password with 20 characters
    password=$(LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 20)
    echo "password: $password" >> "$conf_file"


    # Perform the logic to create the username on the server
    response=$(curl -s -X POST \
        -u "$RUNCLOUD_API_KEY:$RUNCLOUD_API_SECRET" \
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
      user_id=$(echo "$response" | jq -r '.id')

      # echo $response

      echo "Created the username $username on the server with ID $server_id."
      echo "Password is $password"
      echo "user_id: $user_id" >> "$conf_file"  # Save the user ID in conf.yml
    else
      echo "Failed to create the username $username on the server with ID $server_id."
    fi
}

list_ssh_keys () {
    server_id=$(grep "server_id:" "$conf_file" | awk '{print $2}')
    # ssh_key=$(grep "ssh_key:" "$conf_file" | awk '{print $2}')
    ssh_key=$(cat ~/.ssh/id_ed25519.pub)

    response=$(curl -s --request GET \
        -u "$RUNCLOUD_API_KEY:$RUNCLOUD_API_SECRET" \
        -H "Accept: application/json" \
        -H "Content-Type: application/json" \
        "https://manage.runcloud.io/api/v2/servers/$server_id/sshcredentials"
    )


    if [ $? -eq 0 ]; then
        echo "SSH keys on the server with ID $server_id:"
        echo "$response" | jq -r '.data[] | .id'
        echo "$response" | jq -r '.data[] | .user_id'
        echo "$response" | jq -r '.data[] | .publickey'

        # if .publickey is not equal to the ssh_key in conf.yml file, then add the ssh_key
        # Check if the SSH key exists
        key_exists=$(echo "$response" | jq -r --arg ssh_key "$ssh_key" '.data[] | select(.publickey == $ssh_key)')

        if [ -n "$key_exists" ]; then
            echo "The SSH key is already added on the server with ID $server_id."
        else
            echo "The SSH key is not added on the server with ID $server_id."
            add_ssh_key "$ssh_key" "$server_id"
        fi

    else
        echo "Failed to retrieve SSH keys from the Runcloud API."
    fi
}

add_ssh_key() {
  ssh_key=$(cat ~/.ssh/id_ed25519.pub)
  server_id=$2
  username=$(grep "username:" "$conf_file" | awk '{print $2}')
  app_name=$(grep "app_name:" "$conf_file" | awk '{print $2}')
  OSkey="$OS"-"ssh-key"-"$app_name"

  # Perform the logic to add the SSH key on the server
  response=$(curl -s -X POST \
      -u "$RUNCLOUD_API_KEY:$RUNCLOUD_API_SECRET" \
      -H "accept: application/json" \
      -H "content-type: application/json" \
      --data '{
          "label": "'"$OSkey"'",
          "username": "'"$username"'",
          "publicKey": "'"$ssh_key"'"
      }' \
      "https://manage.runcloud.io/api/v2/servers/$server_id/sshcredentials"
  )

  if [ $? -eq 0 ]; then
      echo "Added the SSH key on the server with ID $server_id."
  else
      echo "Failed to add the SSH key on the server with ID $server_id."
  fi
}


generate_deployment_key() {
  server_id=$(grep "server_id:" "$conf_file" | awk '{print $2}')
  user_id=$(grep "user_id:" "$conf_file" | awk '{print $2}')

  echo "server_id: $server_id"
  echo "user_id: $user_id"

  # Perform the logic to generate the deployment key on the server
  response=$(curl -s -X PATCH \
        -u "$RUNCLOUD_API_KEY:$RUNCLOUD_API_SECRET" \
        -H "accept: application/json" \
        -H "content-type: application/json" \
        "https://manage.runcloud.io/api/v2/servers/$server_id/users/$user_id/deploymentkey"
    )

    if [ $? -eq 0 ]; then
        git_deployment_key=$(echo "$response" | jq -r ' .deploymentKey')
        # echo "Git deployment key: $git_deployment_key"
        echo "git_deployment_key: $git_deployment_key" >> "$conf_file"
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

    # list ssh keys
    list_ssh_keys

    # generate deployment key
    generate_deployment_key

else
    # Variables don't exist, store the variables
    echo "Storing variables."
    store_variables
fi
