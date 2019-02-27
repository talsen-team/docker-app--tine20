# docker-app: tine20 -- issue - TLS verification error

## To reproduce the issue perform the following steps:

1. Setup Ubuntu Bionic Desktop (minimal installation) in a virtual machine
2. Install system updates, git, docker, docker-compose, VS Code and any ssh-askpass module  
   1. `sudo apt-get update`  
   2. `sudo apt-get dist-upgrade`
   3. `sudo apt-get install git`
3. Reboot the VM (and maybe create a snapshot here)
4. Clone this repository with this branch checked out  
   `git clone https://github.com/talsen-team/docker-app--tine20.git --recurse-submodules --branch=issue--tine20-tls-verification-error`
5. Install additional dependencies and perform required modifications to the system  
   `sudo /bin/bash docker-app--tine20/install-dependencies.sh`
6. After the script finishes open the clone repository with VS Code  
   `code docker-app--tine20`
7. Perform the VS Code task `docker-compose--image--build`  
   This task will build the slightly modified tine20 docker container.  
   Use either the VS Code UI  
   1. Press Ctrl + Shift + P
   2. Type `Run Task` and select `Tasks: Run Task`
   3. Press Enter
   4. Select the task `docker-compose--image--build`
   5. Press enter again 
   6. Confirm the fullscreen prompt with your password, **Or** use the terminal:  
   1. Change to the cloned directory  
      `cd docker-app--tine20`
   2. Run the task manually  
      `/bin/bash bash-util/elevate.sh root bash-commands/docker-compose--image--build.sh . default.docker-compose`
   3. Confirm the fullscreen prompt with your password
8. Update your container email configuration
   1. Adjust the values of the following variables in your [container.env](container.env)
   2. Uncomment and set `ENV_SSMTP_MAIL_HUB` to your mail hub smtp address and port
   3. Uncomment and set `ENV_SSMTP_MAIL_AUTH_USER` to your mail which should send an email to itself
   4. Uncomment and set `ENV_SSMTP_MAIL_AUTH_PASS` to the password of your specified email account
   5. Uncomment and set `ENV_SSMTP_MAIL_AUTH_METHOD` to the appropriate ssmtp authentication method (PLAIN, LOGIN, ...)
   6. Uncomment and set `ENV_SSMTP_MAIL_USE_TLS` to `YES` (must be ALL_UPPER) if the TLS flag should be set for ssmtp. If the flag should not be set just use any other value or comment the variable.
   7. Uncomment and set `ENV_SSMTP_MAIL_USE_START_TLS` to `YES` (must be ALL_UPPER) if the STARTTLS flag should be set for ssmtp. If the flag should not be set just use any other value or comment the variable.
9. Perform the VS Code task `docker-compose--compose--up`  
   This task will create and start required docker containers and networks.  
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
11. While the container is starting attach to the container log
    1. Open an Ubuntu terminal
    2. `sudo docker logs server--tine20 --follow`
    3. Now wait until the container starts and prints the output  
       `Email verification inside the docker container ...`
    4. Here the container [attempts to send an email](docker/server--tine20/rootfs/opt/server--tine20/send-mail-via-ssmtp.sh) via the tool [ssmtp](https://linux.die.net/man/8/ssmtp)
    5. If the step which sends the mail fails, just double check / adjust your email configuration (especially the TLS and STARTTLS configuration as well the smtp port being used) and the restart the container by continuing at step 9
