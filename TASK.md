# Nginx Reverse Proxy

## Timings

60 - 90 Minutes

## Summary

Our app is currently running on port 3000, in our multi vagrant machine. 
This fine for development but browsers use port 80 by default to load web applications.

We could get the app to run on port 80 but that requires giving the app more privileges than we want to which is very dangerous.

We need to set up a reverse proxy.

## Tasks

Research how to install and configure Nginx as a reverse proxy. This will listen for requests on port 80 and pass them on to our app on port 3000.

## Notes

You will find many many tutorials on how to do this.

If you have started your app and you can see it running on development.local ( without the :3000 ) you're configuration is correct.

You only need to edit one configuration file to do this.

Once you've completed this task, amend your provisioning script for your app VM so that it installs nginx and does the necessary configuration. Make sure you recreate your VM from scratch and run this provisioning script in order to test it works properly.



## Acceptance Criteria

* Uses vagrant file
* Localhost set to development.local (unless you computer can't handle this)
* port 80 has App running (you see the sparta logo on development.local)
* Work with only command "vagrant up" &/or mininum commands 

* Documentation exists as README.md file 
* Documentation includes: Intro (purpose of repo), Pre Requisits  and Intructions
* Instructions have a clear step by step

* repo exists on github
test
