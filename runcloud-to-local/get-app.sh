#!/bin/bash

# get variables
conf_file="conf.yml"
RUNCLOUD_API_KEY=$(grep "runcloudApiKey:" "$conf_file" | awk '{print $2}')
RUNCLOUD_API_SECRET=$(grep "runcloudApiSecret:" "$conf_file" | awk '{print $2}')
server_id=$(grep "server_id:" "$conf_file" | awk '{print $2}')
app_name=$(grep "app_name:" "$conf_file" | awk '{print $2}')

response=$(curl -s -X GET \
      -u "$RUNCLOUD_API_KEY:$RUNCLOUD_API_SECRET" \
      -H "Accept: application/json" \
      "https://manage.runcloud.io/api/v2/servers/$server_id/webapps"
  )

app_name_exists=$(echo "$response" | jq --arg app_name "$app_name" '.data[] | select(.name == $app_name) | .name')


matching_object=$(echo "$response" | jq --arg app_name "$app_name" '.data[] | select(.name == $app_name)')

# Check if a matching object was found. If not, exit or handle as needed.
if [[ -z $matching_object ]]; then
    echo "No matching object found!"
    exit 1
fi

# Extract and save each key-value pair to the conf.yml file
for key in $(echo "$matching_object" | jq -r 'keys[]'); do
    value=$(echo "$matching_object" | jq -r --arg key "$key" '.[$key]')
    echo "$key: $value" >> conf.yml
done

# fixing app_id key
app_id=$(grep "^id:" "$conf_file" | awk '{print $2}')
echo "app_id: $app_id" >> "$conf_file"

#removing stupid id
awk '!/^id:/' conf.yml > temp.yml && mv temp.yml conf.yml
