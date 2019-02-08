#!/bin/bash

set -euo pipefail

echo "Installing dependencies ..."
apt-get install -y --no-install-recommends \
                curl
echo "Installing dependencies ... done"

echo "Add VS Code repository to apt-get ..."
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
echo "Add VS Code repository to apt-get ... done"

echo "Install VS Code ..."
apt-get install -y --no-install-recommends \
                apt-transport-https
apt-get update
apt-get install -y --no-install-recommends \
                code
echo "Install VS Code ... done"

echo "Add docker repository to apt-get ..."
apt-get update
apt-get install -y --no-install-recommends \
                apt-transport-https        \
                ca-certificates            \
                curl                       \
                gnupg-agent                \
                software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository                                            \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs)                                         \
   stable"
echo "Add docker repository to apt-get ... done"

echo "Install docker ..."
apt-get update
apt-get install -y --no-install-recommends \
                docker-ce                  \
                docker-ce-cli              \
                containerd.io
echo "Install docker ... done"

echo "Install docker-compose ..."
curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
echo "Install docker-compose ... done"

echo "Install ssh-askpass-fullscreen ..."
apt-get install -y --no-install-recommends \
                ssh-askpass-fullscreen
echo "Install ssh-askpass-fullscreen ... done"

echo "Install chromium-browser ..."
apt-get install -y --no-install-recommends \
                chromium-browser
echo "Install chromium-browser ... done"
