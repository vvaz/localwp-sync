#!/bin/bash

# load base variables
DIR="$(pwd)"
conf_file=$DIR/conf.yml

# load variables

RUNCLOUD_API_KEY=$(grep "runcloudApiKey:" "$conf_file" | awk '{print $2}')
RUNCLOUD_API_SECRET=$(grep "runcloudApiSecret:" "$conf_file" | awk '{print $2}')
server_id=$(grep "server_id:" "$conf_file" | awk '{print $2}')
app_name=$(grep "app_name:" "$conf_file" | awk '{print $2}')
live_domain=$(grep "live_domain:" "$conf_file" | awk '{print $2}')
git_repository=$(grep "git_repository:" "$conf_file" | awk '{print $2}')
user_id=$(grep "^user_id:" "$conf_file" | awk '{print $2}')
username=$(grep "username:" "$conf_file" | awk '{print $2}')
DIR_OPS=$DIR/ops


  response=$(curl -s --request POST \
    -u "$RUNCLOUD_API_KEY:$RUNCLOUD_API_SECRET" \
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

    echo "Created app: $app_name"

    # debug
    echo "$response" | jq -r '.'
