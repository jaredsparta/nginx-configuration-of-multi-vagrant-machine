# Configuring nginx

- The task is specified in `TASK.md` found in the same repo [here](https://github.com/jaredsparta/nginx-configuration-of-multi-vagrant-machine/blob/master/TASK.md)

- The aim of this task is to link together the previous three tasks and host the node.js app using our Linux VM. Before, we could access our app through aliases or the ip address but ONLY specifying the port the app was running on, in this case port 3000. Using nginx as a reverse proxy, we can re-route all traffic coming into port 80 to our app running on port 3000.

- This allows users to simply access the app using `development.local` instead of specifying the port `development.local:3000`

<br>

# Pre-requisites

- Install `Oracle Virtual Box` [here](https://www.virtualbox.org/wiki/Downloads). This is the software that allows us to create virtual machines (VM).

- Install `Vagrant` [here](https://www.vagrantup.com/downloads.html). We use Vagrant to manage our virtual machines in Oracle VM.

- Once `Vagrant` is installed, you need the `vagrant-hostsupdater` plugin. 
> Run `vagrant plugin install vagrant-hostsupdater` to install it

> Run `vagrant plugin uninstall vagrant-hostsupdater` to uninstall it

> There may be be some problems with this plugin, if you do encounter some just uninstall and then re-install

- One will also need `Ruby` installed, find it [here](https://www.ruby-lang.org/en/downloads/). 

<br>

# Instructions

- Now that we have the app listening on port 3000, we just need to configure nginx as a reverse proxy. We can do so by creating a configuration file and copying it into `/etc/nginx/conf.d/app.conf`.

<br>

- The configuration file is shown below. As you can see, nginx will listen on port 80 and reroute any connections made there to port 3000, where the app is located.

```bash
server {
    listen 80;
    server_name node.app.spartaglobal;

    location / {
        proxy_set_header   X-Forwarded-For $remote_addr;
        proxy_set_header   Host $http_host;
        proxy_pass         http://192.168.10.100:3000;
    }
}
```

<br>

- There will be a folder called `config-files` containing the configuration file as shown above in a file called `reverse-proxy.conf`.

<br>

- Now to automate this entire process, we need to change both our app's provision file and the `Vagrantfile` a tiny bit.

<br>

- The VM will need access to the `config-files` folder so we must add a line in our `Vagrantfile` that does so. The config for the app in `Vagrantfile` will look like this:
```bash
config.vm.define "app" do |app|
    app.vm.box = "ubuntu/xenial64"
    app.vm.network "private_network", ip: "192.168.10.100"
    app.hostsupdater.aliases = ["development.local"]
    app.vm.synced_folder "app", "/home/ubuntu/app"

    #This is the newly added synced folder
    app.vm.synced_folder "config-files", "/home/config-files"
    app.vm.provision "shell", path: "environment/app/provision.sh", privileged: false
  end
```

<br>

- Afterwards we must append the provision file found in `/environment/app/provision.sh`. The nginx server needs to be able to send connections to the app so we first need to start it. Hence, we put the nginx configuration commands after.

<br>

- To start, we must copy our `reverse-proxy.conf` into `/etc/nginx/conf.d`. 
> We can do this using `sudo cp /home/config-files/reverse-proxy.conf /etc/nginx/conf.d/app.conf`

<br>

- To ensure the nginx server uses this configuration file, we must also remove the default one. This is found in `/etc/nginx/sites-enabled`.
> We can remove the default one by issuing `sudo rm /etc/nginx/sites-enabled/default`

<br>

- Finally, since all necessary configuration is done, we simply need to restart the nginx server to allow the changes to occur.
> Done with `sudo systemctl restart nginx`

<br>

- The provision file for the app found in `/environment/app/provision.sh` should now look like:
```bash
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
npm start &

# this moves the configuration file to the necessary place
sudo cp /home/config-files/reverse-proxy.conf /etc/nginx/conf.d/app.conf

# this removes the default sites to ensure that nginx looks to our config file
sudo rm /etc/nginx/sites-enabled/default

# restart the server to allow the config files to change
sudo systemctl restart nginx

```

- Now since all the necessary commands in the provision file are inputted, we just simply need to `vagrant up` and the app will be running on `development.local`

<br>

# Possible errors

- There could be some errors relating to the app. One possible way to fix it would be to delete the following files:
    1. `app/node_modules`
    2. `app/package-lock.json`

- Then, add `npm install` before `npm start &` in `environment/app/provision.sh`. This will allow you to install the necessary files and packages yourself.
