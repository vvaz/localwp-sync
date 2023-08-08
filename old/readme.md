# Intro

This workflow will setup a new site on DDEV based on a Github repository for local development.
It will also let you sync any production files to your local environment.
It connects to your site on Runcloud with your DDEV. It should work on Mac OS and Windows WSL2 with Ubuntu

# 1. Setup DDEV and project structures
> We're assuming you already have DDEV installed and running on your OS.

Go into your project path and clone this repository into a folder called **ops**
```
git clone git@github.com:vvaz/localwp-sync.git ops
```
Create a folder called public which will have our repository
```
mkdir public
```
Run ddev config and follow the prompts
```
ddev config
```



# Step 1
Create your Github repository and add WordPress core to it, ignore wp-config.php and node_modules

# Step 2
Create a username on runcloud.io without password and add your ssh key.

# Step 3
Copy the deployment key to your Github repository

# Step 4
On Cloudflare create a new subdomain and point to the proper Runcloud IP server.

# Step 5
Create a new Git app on Runcloud

# Step 6
Copy the webhook URL to your Github repository

# Step 7
Create a new database and username for your new app

# Step 8
Run setup.sh
