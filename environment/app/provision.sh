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

export DB_HOST=192.168.10.200

## finally, restart the nginx service so the new config takes hold

echo "export DB_HOST=192.168.10.200" >> ~/.bashrc
source ~/.bashrc


sudo apt-get install nginx -y
sudo systemctl restart nginx

# create a site-available for the node app

cd /home/ubuntu/app

npm start &

sudo cp /home/config-files/reverse-proxy.conf /etc/nginx/conf.d/app.conf

sudo rm /etc/nginx/sites-enabled/default

sudo systemctl restart nginx
