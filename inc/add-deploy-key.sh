#!/bin/bash

# load base variables
DIR="$(pwd)"
conf_file=$DIR/conf.yml

# variables
github_token=$(grep "github_token:" "$conf_file" | awk '{print $2}') # github token
git_owner=$(grep "git_owner:" "$conf_file" | awk '{print $2}') # github owner
git_repo=$(grep "git_repository:" "$conf_file" | awk '{print $2}') # git repository
# load string with spaces
git_deployment_key=$(grep "git_deployment_key:" "$conf_file" | cut -d' ' -f2-)
username=$(grep "username:" "$conf_file" | awk '{print $2}') # username
live_domain=$(grep "live_domain:" "$conf_file" | awk '{print $2}') # server id



payload=$(jq -n \
                  --arg username "$username" \
                  --arg live_domain "$live_domain" \
                  --arg git_deployment_key "$git_deployment_key" \
                  '{title: "\($username)@\($live_domain)", key: $git_deployment_key, read_only: false}')

response=$(curl -L -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $github_token" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  -d "$payload" \
  "https://api.github.com/repos/$git_owner/$git_repo/keys"
)



#
#response=$(curl -L -X POST \
#  -H "Accept: application/vnd.github+json" \
#  -H "Authorization: Bearer $github_token"\
#  -H "X-GitHub-Api-Version: 2022-11-28" \
#  -d '{"title":""'"$username"'"@"'"$server_id"'"","key":"'"$git_deployment_key"'","read_only":false}' \
#  "https://api.github.com/repos/$git_owner/$git_repo/keys"
#  )


# echo "$response"

echo "key added to Github"
