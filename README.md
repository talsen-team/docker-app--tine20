# docker-app: tine20 -- issue - extra reverse proxy

## To reproduce the issue with hostname *localhost* (problem occurring in Firefox), perform the following steps:

1. Setup Ubuntu Bionic Desktop (minimal installation) in a virtual machine
2. Install system updates and git   
   1. `sudo apt-get update`  
   2. `sudo apt-get dist-upgrade`
   3. `sudo apt-get install git`
3. Clone this repository with this branch checked out  
   `git clone https://github.com/talsen-team/docker-app--tine20.git --recurse-submodules --branch=issue--tine20-extra-reverse-proxy`
4. Install additional dependencies and perform required modifications to the system  
   `sudo /bin/bash docker-app--tine20/install-dependencies.sh`
5. After the script finishes open the clone repository with VS Code  
   `code docker-app--tine20`
6. Perform the VS Code task `docker-compose--compose--up`  
   This task will pull required docker images and create required docker containers and networks.  
   Use either the VS Code UI  
   1. Press Ctrl + Shift + P
   2. Type `Run Task`
   3. Press Enter
   4. Select the task `docker-compose--compose--up`
   5. Press enter again 
   6. Confirm the fullscreen prompt with your password

  Or use the terminal:  
   1. Change to the cloned directory  
      `cd docker-app--tine20`
   2. Run the task manually  
      `/bin/bash bash-util/elevate.sh root bash-commands/docker-compose--compose--up.sh . default.docker-compose`
   3. Confirm the fullscreen prompt with your password
7. Wait until the images are pulled and both containers are started
8. Wait until the nginx container has finished starting, after the file `volumes/server-nginx-certbot/cache/dhparams.pem` wait 2 moe seconds and the container is ready
9. Perform the VS Code task `nginx--update-configuration`
   This task will create the nginx configuration which performs the http to https redirection using locally generated self-signed certificates.
   Use either the VS Code UI  
   1. Press Ctrl + Shift + P
   2. Type `Run Task`
   3. Press Enter
   4. Select the task `nginx--update-configuration`
   5. Press enter again 
   6. Confirm the fullscreen prompt with your password

  Or use the terminal:  
   1. Change to the cloned directory  
      `cd docker-app--tine20`
   2. Run the task manually  
      `/bin/bash bash-util/elevate.sh root bash-commands--custom/nginx--update-configuration.sh . default.docker-compose application`
   3. Confirm the fullscreen prompt with your password
10. Perform the VS Code task `chromium--open-application-url`
   This task will tell Chromium to open the url https://localhost.
   Use either the VS Code UI  
   1. Press Ctrl + Shift + P
   2. Type `Run Task`
   3. Press Enter
   4. Select the task `chromium--open-application-url`
   5. Press enter again 
   6. Confirm the fullscreen prompt with your password

  Or use the terminal:  
   1. Change to the cloned directory  
      `cd docker-app--tine20`
   2. Run the task manually  
      `/bin/bash bash-util/elevate.sh ${USER} bash-commands--custom/chromium--open-application-url.sh . default.docker-compose`
   3. Confirm the fullscreen prompt with your password
11. Now Chromium is open and showing the url https://localhost, prompting you trying to access unsecure web content (due to self-signed certificates). Tell Chromium to show the content anyway.
   1. Click on ``
   2. Click on ``
12. Now the tine20 login page is visible, log in with the pre-defined credentials (defined in [container.env](container.env)).
   - user: `admin`
   - pass: `secureadminpassword`
13. Now the more-or-less working version of http to https redirection has been performed. If the same page is opened with Firefox, the login page is stuck loading forever.
14. Perform the VS Code task `browser--open-application-url`
   This task will tell the default web browser (Firefox) to open the url https://localhost.
   Use either the VS Code UI  
   1. Press Ctrl + Shift + P
   2. Type `Run Task`
   3. Press Enter
   4. Select the task `browser--open-application-url`
   5. Press enter again 
   6. Confirm the fullscreen prompt with your password
   
  Or use the terminal:  
   1. Change to the cloned directory  
      `cd docker-app--tine20`
   2. Run the task manually  
      `/bin/bash bash-util/elevate.sh ${USER} bash-commands/browser--open-application-url.sh . default.docker-compose`
   3. Confirm the fullscreen prompt with your password
15. Now Firefox is open and showing the url https://localhost, prompting you trying to access unsecure web content (due to self-signed certificates). Tell Firefox to show the content anyway.
   1. Click on ``
   2. Click on ``
16. Now the tine20 login page is stuck loading (for unknown reason).
