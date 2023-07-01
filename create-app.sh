#!/bin/bash

# Read API_KEY and API_SECRET from conf.yml file
conf_file="conf.yml"
API_KEY=$(grep "api_key:" "$conf_file" | awk '{print $2}')
API_SECRET=$(grep "api_secret:" "$conf_file" | awk '{print $2}')

create_app() {
  # variables
  server_id=$(grep "server_id:" "$conf_file" | awk '{print $2}') # IP address of the server
  app_name=$(grep "app_name:" "$conf_file" | awk '{print $2}') # app name
  live_domain=$(grep "live_domain:" "$conf_file" | awk '{print $2}') # live domain
  git_repository=$(grep "git_repository:" "$conf_file" | awk '{print $2}') # git repository
  user_id=$(grep "user_id:" "$conf_file" | awk '{print $2}') # user id
  username=$(grep "username:" "$conf_file" | awk '{print $2}') # username

  response=$(curl -s --request POST \
    -u "$API_KEY:$API_SECRET" \
    -H "Accept: application/json" \
    -H "content-type: application/json" \
    --data '{
        "name": "'"$app_name"'",
        "domainName": "'"$live_domain"'",
        "user": "'"$user_id"'",
        "publicPath": null,
        "phpVersion": "php82rc",
        "stack": "nativenginx",
        "stackMode": "production",
        "clickjackingProtection": true,
        "xssProtection": true,
        "mimeSniffingProtection": true,
        "processManager": "ondemand",
        "processManagerMaxChildren": 50,
        "processManagerMaxRequests": 500,
        "openBasedir": "/home/'"$username"'/webapps/'"$app_name"':/var/lib/php/session:/tmp",
        "timezone": "UTC",
        "disableFunctions": "getmyuid,passthru,leak,listen,diskfreespace,tmpfile,link,ignore_user_abort,shell_exec,dl,set_time_limit,exec,system,highlight_file,source,show_source,fpassthru,virtual,posix_ctermid,posix_getcwd,posix_getegid,posix_geteuid,posix_getgid,posix_getgrgid,posix_getgrnam,posix_getgroups,posix_getlogin,posix_getpgid,posix_getpgrp,posix_getpid,posix,_getppid,posix_getpwuid,posix_getrlimit,posix_getsid,posix_getuid,posix_isatty,posix_kill,posix_mkfifo,posix_setegid,posix_seteuid,posix_setgid,posix_setpgid,posix_setsid,posix_setuid,posix_times,posix_ttyname,posix_uname,proc_open,proc_close,proc_nice,proc_terminate,escapeshellcmd,ini_alter,popen,pcntl_exec,socket_accept,socket_bind,socket_clear_error,socket_close,socket_connect,symlink,posix_geteuid,ini_alter,socket_listen,socket_create_listen,socket_read,socket_create_pair,stream_socket_server",
        "maxExecutionTime": 30,
        "maxInputTime": 60,
        "maxInputVars": 1000,
        "memoryLimit": 256,
        "postMaxSize": 256,
        "uploadMaxFilesize": 256,
        "sessionGcMaxlifetime": 1440,
        "allowUrlFopen": true
        }' \
      "https://manage.runcloud.io/api/v2/servers/$server_id/webapps/custom"
    )

    if [ $? -eq 0 ]; then
      app_id=$(echo "$response" | jq -r '.id')
      pullKey1=$(echo "$response" | jq -r '.pullKey1')
      pullKey2=$(echo "$response" | jq -r '.pullKey2')

      echo "app_id: $app_id" >> "$conf_file"
      echo "pullKey1: $pullKey1" >> "$conf_file"
      echo "pullKey2: $pullKey2" >> "$conf_file"
    fi
    # echo "$response"
    echo "Created app: $app_name"
}

create_db_user() {
  # variables
  server_id=$(grep "server_id:" "$conf_file" | awk '{print $2}') # IP address of the server
  app_name=$(grep "app_name:" "$conf_file" | awk '{print $2}') # app name

  propper_app_name=$(echo "$app_name" | tr '-' '_')
  ready_app_name="${propper_app_name#app_}"
  random_number=$((RANDOM % 9001 + 1000))
  db_user=dbUser_"$ready_app_name"_"$random_number"
  db_password=$(LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 20)

  echo "db_user: $db_user" >> "$conf_file"
  echo "db_password: $db_password" >> "$conf_file"


response=$(curl -s --request POST \
    -u "$API_KEY:$API_SECRET" \
    -H "Accept: application/json" \
    -H "content-type: application/json" \
    --data '{
      "username": "'"$db_user"'",
      "password": "'"$db_password"'"
      }' \
    "https://manage.runcloud.io/api/v2/servers/$server_id/databaseusers"
  )

  if [ $? -eq 0 ]; then
    db_user_id=$(echo "$response" | jq -r ' .id')
    echo "db_user_id: $db_user_id" >> "$conf_file"
  fi

  echo "Created database user: $db_user"

}

create_db() {
  # variables
  server_id=$(grep "server_id:" "$conf_file" | awk '{print $2}') # IP address of the server
  app_name=$(grep "app_name:" "$conf_file" | awk '{print $2}') # app name
  db_user_id=$(grep "db_user_id:" "$conf_file" | awk '{print $2}') # db user id

  propper_app_name=$(echo "$app_name" | tr '-' '_')
  ready_app_name="${propper_app_name#app_}"
  random_number=$((RANDOM % 9001 + 1000))
  db_name=db_"$ready_app_name"_"$random_number"

  echo "db_name: $db_name" >> "$conf_file"

  response=$(curl -s --request POST \
      -u "$API_KEY:$API_SECRET" \
      -H "Accept: application/json" \
      -H "content-type: application/json" \
      --data '{
        "name": "'"$db_name"'",
        "collation": "utf8mb4_unicode_ci",
        "user": "'"$db_user_id"'"
         }' \
      "https://manage.runcloud.io/api/v2/servers/$server_id/databases"
    )

    if [ $? -eq 0 ]; then
      db_id=$(echo "$response" | jq -r ' .id')
      echo "db_id: $db_id" >> "$conf_file"
    fi

    # echo $response

    echo "Created the database."
}

add_user_to_db() {
  # variables
  server_id=$(grep "server_id:" "$conf_file" | awk '{print $2}') # IP address of the server
  app_name=$(grep "app_name:" "$conf_file" | awk '{print $2}') # app name
  db_id=$(grep "db_id:" "$conf_file" | awk '{print $2}') # db id
  db_user_id=$(grep "db_user_id:" "$conf_file" | awk '{print $2}') # db user id

  response=$(curl -s --request POST \
      -u "$API_KEY:$API_SECRET" \
      -H "Accept: application/json" \
      -H "content-type: application/json" \
      --data '{
        "id": "'"$db_user_id"'"
         }' \
      "https://manage.runcloud.io/api/v2/servers/$server_id/databases/$db_id/grant"
    )

    if [ $? -eq 0 ]; then
      echo "Added the user to the database."
    fi

    # echo $response
}

add_github() {
  # variables
  server_id=$(grep "server_id:" "$conf_file" | awk '{print $2}') # IP address of the server
  app_id=$(grep "app_id:" "$conf_file" | awk '{print $2}') # app id
  #git_repository=$(grep "git_repository:" "$conf_file" | awk '{print $2}') # git repository
  pullKey1=$(grep "pullKey1:" "$conf_file" | awk '{print $2}') # pull key 1
  pullKey2=$(grep "pullKey2:" "$conf_file" | awk '{print $2}') # pull key 2

  git_owner=$(grep "git_owner:" "$conf_file" | awk '{print $2}') # github owner
  git_repo=$(grep "git_repository:" "$conf_file" | awk '{print $2}') # git repository

  # Remove "git@github.com:"
  #removed_prefix="${git_repository#git@github.com:}"6
  # Remove ".git"
  #removed_suffix="${removed_prefix%.git}"
  #git_name=$removed_suffix


  response=$(curl -s --request POST \
    -u "$API_KEY:$API_SECRET" \
    -H "Accept: application/json" \
    -H "content-type: application/json" \
    --data "{
        \"provider\": \"github\",
        \"repository\": \"$git_owner/$git_repo\",
        \"branch\": \"main\"
      }" \
   "https://manage.runcloud.io/api/v2/servers/$server_id/webapps/$app_id/git"
  )

   # echo "$response"
   echo "Added the github repository to the app."
}

add_deploy_key(){
  # add deploy key to github
  # variables
  github_token=$(grep "github_token:" "$conf_file" | awk '{print $2}') # github token
  git_owner=$(grep "git_owner:" "$conf_file" | awk '{print $2}') # github owner
  git_repo=$(grep "git_repository:" "$conf_file" | awk '{print $2}') # git repository
  # load string with spaces
  git_deployment_key=$(grep "git_deployment_key:" "$conf_file" | cut -d' ' -f2-)

response=$(curl -L -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $github_token"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  -d '{"title":"deploy@runcloud","key":"'"$git_deployment_key"'","read_only":false}' \
  "https://api.github.com/repos/$git_owner/$git_repo/keys"
  )

 # echo "$response"
}

add_webhook() {
  github_token=$(grep "github_token:" "$conf_file" | awk '{print $2}') # github token
  git_owner=$(grep "git_owner:" "$conf_file" | awk '{print $2}') # github owner
  git_repo=$(grep "git_repository:" "$conf_file" | awk '{print $2}') # git repository
  pullKey1=$(grep "pullKey1:" "$conf_file" | awk '{print $2}') # pull key 1
  pullKey2=$(grep "pullKey2:" "$conf_file" | awk '{print $2}') # pull key 2

  response=$(curl -L -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $github_token"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  -d "{\"name\":\"web\",\"active\":true,\"events\":[\"push\",\"pull_request\"],\"config\":{\"url\":\"https://manage.runcloud.io/webhooks/git/$pullKey1/$pullKey2\",\"content_type\":\"json\",\"insecure_ssl\":\"0\"}}" \
  "https://api.github.com/repos/$git_owner/$git_repo/hooks"
  )



# echo "$response"


}

list_apps() {

  # variables
  server_id=$(grep "server_id:" "$conf_file" | awk '{print $2}') # IP address of the server

  response=$(curl -s --request GET \
        -u "$API_KEY:$API_SECRET" \
        -H "Accept: application/json" \
        -H "content-type: application/json" \
          "https://manage.runcloud.io/api/v2/servers/$server_id/webapps/"
        )

        # echo "$response"
}

# list_apps
create_app

create_db_user

create_db

add_deploy_key

add_user_to_db

add_github

add_webhook
