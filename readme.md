# Intro

This workflow will setup a new site on LOCAL based on a Github repository for local development.

It will also let you sync any production files to your local environment.

It connects your site on Runcloud with your Local by Flywheel.

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

