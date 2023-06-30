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

        echo "$response"
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

        echo "$response"
}

# list_apps
# create_app
create_db_user
# create_db
