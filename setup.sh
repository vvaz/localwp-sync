#!/bin/bash

# create backup folders
# echo "Creating backup folders"
# cd .. && mkdir backups && mkdir backups/db/
# echo "DONE"

# getting variables
echo "Whats your site name on LOCAL?"
read siteName
# echo "name is $siteName"
echo "siteName=$siteName" > variables.dat