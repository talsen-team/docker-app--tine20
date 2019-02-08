# docker-app: tine20 -- issue - extra reverse proxy

## To reproduce the issue with hostname **localhost** (problem occurring in Firefox), perform the following steps:

1. Setup Ubuntu Bionic Desktop (minimal installation) in a virtual machine
2. Install system updates and git   
   1. `sudo apt-get update`  
   2. `sudo apt-get dist-upgrade`
   3. `sudo apt-get install git`
3. Reboot the VM (and maybe create a snapshot here)
4. Clone this repository with this branch checked out  
   `git clone https://github.com/talsen-team/docker-app--tine20.git --recurse-submodules --branch=issue--tine20-extra-reverse-proxy`
5. Install additional dependencies and perform required modifications to the system  
   `sudo /bin/bash docker-app--tine20/install-dependencies.sh`
6. After the script finishes open the clone repository with VS Code  
   `code docker-app--tine20`
7. Perform the VS Code task `docker-compose--compose--up`  
   This task will pull required docker images and create required docker containers and networks.  
   Use either the VS Code UI  
   1. Press Ctrl + Shift + P
   2. Type `Run Task` and select `Tasks: Run Task`
   3. Press Enter
   4. Select the task `docker-compose--compose--up`
   5. Press enter again 
   6. Confirm the fullscreen prompt with your password, **Or** use the terminal:  
   1. Change to the cloned directory  
      `cd docker-app--tine20`
   2. Run the task manually  
      `/bin/bash bash-util/elevate.sh root bash-commands/docker-compose--compose--up.sh . default.docker-compose`
   3. Confirm the fullscreen prompt with your password
8. Wait until the images are pulled and both containers are started
9. Wait until the nginx container has finished starting, after the file `volumes/server-nginx-certbot/cache/dhparams.pem` wait 2 moe seconds and the container is ready
10. Perform the VS Code task `nginx--update-configuration`
    This task will create the nginx configuration which performs the http to https redirection using locally generated self-signed certificates.
    Use either the VS Code UI  
    1. Press Ctrl + Shift + P
    2. Type `Run Task` and select `Tasks: Run Task`
    3. Press Enter
    4. Select the task `nginx--update-configuration`
    5. Press enter again 
    6. Confirm the fullscreen prompt with your password, **Or** use the terminal:  
    1. Change to the cloned directory  
       `cd docker-app--tine20`
    2. Run the task manually  
       `/bin/bash bash-util/elevate.sh root bash-commands--custom/nginx--update-configuration.sh . default.docker-compose application`
    3. Confirm the fullscreen prompt with your password
11. Perform the VS Code task `chromium--open-application-url`
    This task will tell Chromium to open the url https://localhost.
    Use either the VS Code UI  
    1. Press Ctrl + Shift + P
    2. Type `Run Task` and select `Tasks: Run Task`
    3. Press Enter
    4. Select the task `chromium--open-application-url`
    5. Press enter again 
    6. Confirm the fullscreen prompt with your password, **Or** use the terminal:  
    1. Change to the cloned directory  
       `cd docker-app--tine20`
    2. Run the task manually  
       `/bin/bash bash-util/elevate.sh ${USER} bash-commands--custom/chromium--open-application-url.sh . default.docker-compose`
    3. Confirm the fullscreen prompt with your password
12. Now Chromium is open and showing the url https://localhost, prompting you trying to access unsecure web content (due to self-signed certificates). Tell Chromium to show the content anyway.
    1. Click on `Advanced`
    2. Then click on `Proceed to localhost (unsafe)`
13. Now the tine20 login page is visible, log in with the pre-defined credentials (defined in [container.env](container.env)).
    - user: `admin`
    - pass: `secureadminpassword`
14. Now the more-or-less working version of http to https redirection has been performed. If the same page is opened with Firefox, the login page is stuck loading forever.
15. Perform the VS Code task `browser--open-application-url`
    This task will tell the default web browser (Firefox) to open the url https://localhost.
    Use either the VS Code UI  
    1. Press Ctrl + Shift + P
    2. Type `Run Task` and select `Tasks: Run Task`
    3. Press Enter
    4. Select the task `browser--open-application-url`
    5. Press enter again 
    6. Confirm the fullscreen prompt with your password, **Or** use the terminal:  
    1. Change to the cloned directory  
       `cd docker-app--tine20`
    2. Run the task manually  
       `/bin/bash bash-util/elevate.sh ${USER} bash-commands/browser--open-application-url.sh . default.docker-compose`
    3. Confirm the fullscreen prompt with your password
16. Now Firefox is open and showing the url https://localhost, prompting you trying to access unsecure web content (due to self-signed certificates). Tell Firefox to show the content anyway.
    1. Click on `Advanced`
    2. Then click on `Add Exception...`
    3. Uncheck option `Permanently store this exception`
    4. Click on `Confirm Security Exception`
17. Now the tine20 login page is stuck loading (for unknown reason).

The used nginx configuration can be found [here](https://github.com/talsen-team/docker-nginx-certbot/blob/master/docker/server-nginx-certbot/rootfs/templates/vhost.template.conf).
To view the *live* file execute the following commands:

1. Attach to the nginx container  
   `sudo docker exec -it server-nginx-certbot /bin/bash`
2. Install nano  
   `apk add nano`
3. Change to the nginx vhost directory  
   `cd /etc/nginx/vhosts/`
4. Open the tine20 configuration  
   `nano localhost.conf`

The configuration can be viewed and edited directly inside the container.
To apply changes to nginx perform the following command:

1. Attach to the nginx container  
   `sudo docker exec -it server-nginx-certbot /bin/bash`
2. Reload nginx configuration
   `nginx -s reload`  
   The warnings regardng `ssl_stapling` can be ignored (they come from the self-signed certificates)

## To reproduce the issue with hostname **tine.private** (problem occurring in both Chromium and Firefox), perform the following steps:

Do the same steps as in [above](#to-reproduce-the-issue-with-hostname-localhost-problem-occurring-in-firefox-perform-the-following-steps) until step 10 (including 10).
