#!/bin/bash

# load base variables
DIR="$(pwd)"
conf_file=$DIR/conf.yml
github_token=$(grep "github_token:" "$conf_file" | awk '{print $2}')
git_owner=$(grep "git_owner:" "$conf_file" | awk '{print $2}')
git_repo=$(grep "git_repository:" "$conf_file" | awk '{print $2}')
ssh_key=$(grep "ssh_key:" "$conf_file" | awk '{print $2}')
username=$(grep "username:" "$conf_file" | awk '{print $2}')
server_id=$(grep "server_id:" "$conf_file" | awk '{print $2}')

curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $github_token" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$git_owner/$git_repo/keys \
  -d "{\"title\":\"$username@$server_id\",\"key\":\"$ssh_key\",\"read_only\":false}"
