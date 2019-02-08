#!/bin/bash

set -euo pipefail

source bash-util/functions.sh

prepare_local_environment ${@}

echo -E "Updating nginx configuration ..."

docker exec -t server-nginx-certbot /bin/bash /opt/server-nginx-certbot/command-update-configuration.sh ${3}

echo -e "Updating nginx configuration ... $( __done )"
