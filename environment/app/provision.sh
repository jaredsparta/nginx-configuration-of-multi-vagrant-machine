#!/bin/bash

# Update the sources list
sudo apt-get update -y

# upgrade any packages available

# install nodejs
sudo apt-get install python-software-properties -y
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install nodejs -y

# install pm2
sudo npm install pm2 -g

# creates an environment variable
export DB_HOST=192.168.10.200

# these two lines will input the environment variable into the bashrc file
# the bashrc file runs everytime we start a terminal which in this case means we ssh into the VM
echo "export DB_HOST=192.168.10.200" >> ~/.bashrc
source ~/.bashrc

# this installs nginx
sudo apt-get install nginx -y
sudo systemctl restart nginx

# we cd into the app directory and start it
# we use & to start it in the background
cd /home/ubuntu/app
rm -r node_modules
npm install
npm start &

# this moves the configuration file to the necessary place
sudo cp /home/config-files/reverse-proxy.conf /etc/nginx/conf.d/app.conf

# this removes the default sites to ensure that nginx looks to our config file
sudo rm /etc/nginx/sites-enabled/default

# restart the server to allow the config files to change
sudo systemctl restart nginx
