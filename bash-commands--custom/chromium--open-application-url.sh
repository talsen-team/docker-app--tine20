#!/bin/bash

set -euo pipefail

source bash-util/functions.sh

prepare_local_environment ${@}

function open_application_url_in_chromium_if_defined() {
    local VAR_NAME_OF_URL_ENVIRONMENT_VARIABLE="HOST_SERVICE_URL"

    echo -E "Opening URL ..."

    if [[ ! -v ${VAR_NAME_OF_URL_ENVIRONMENT_VARIABLE} ]];
    then
        echo -e "Opening URL ... $( __skipped )"
        exit 0
    fi
    
    local VAR_URL_TO_OPEN=${!VAR_NAME_OF_URL_ENVIRONMENT_VARIABLE}
    
    chromium-browser "${VAR_URL_TO_OPEN}"

    echo -e "Opening URL ... $( __done )"
}

open_application_url_in_chromium_if_defined
