#!/bin/bash

# load base variables
DIR="$(pwd)"
conf_file=$DIR/conf.yml

github_token=$(grep "github_token:" "$conf_file" | awk '{print $2}') # github token
git_owner=$(grep "git_owner:" "$conf_file" | awk '{print $2}') # github owner
git_repo=$(grep "git_repository:" "$conf_file" | awk '{print $2}') # git repository
pullKey1=$(grep "pullKey1:" "$conf_file" | awk '{print $2}') # pull key 1
pullKey2=$(grep "pullKey2:" "$conf_file" | awk '{print $2}') # pull key 2

response=$(curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $github_token" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$git_owner/$git_repo/hooks \
  -d "{\"name\":\"web\",\"active\":true,\"events\":[\"push\",\"pull_request\"],\"config\":{\"url\":\"https://manage.runcloud.io/webhooks/git/$pullKey1/$pullKey2\",\"content_type\":\"json\",\"insecure_ssl\":\"0\"}}" \
  )
