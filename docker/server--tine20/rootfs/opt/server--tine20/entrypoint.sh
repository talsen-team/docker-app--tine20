#!/bin/bash

set -euo pipefail

function keep_timezone_information_up_to_date() {
    echo " * Updating timezone data ..."
    dpkg-reconfigure tzdata
    echo " * Updating timezone data ... done"
}

function check_system_environment() {
    echo " * Checking system environment ..."
    if [ -z "${ENV_TINE20_DB_LOCATION}" ];
    then
        echo >&2 "Environment variable named is ENV_TINE20_DB_LOCATION missing."
        exit 1
    fi
    if [ -z "${ENV_TINE20_DB_NAME}" ];
    then
        echo >&2 "Environment variable named is ENV_TINE20_DB_NAME missing."
        exit 1
    fi
    if [ -z "${ENV_TINE20_DB_USERNAME}" ];
    then
        echo >&2 "Environment variable named is ENV_TINE20_DB_USERNAME missing."
        exit 1
    fi
    if [ -z "${ENV_TINE20_DB_USERPASS}" ];
    then
        echo >&2 "Environment variable named is ENV_TINE20_DB_USERPASS missing."
        exit 1
    fi
    if [ -z "${ENV_TINE20_LOG_LEVEL}" ];
    then
        echo >&2 "Environment variable named is ENV_TINE20_LOG_LEVEL missing."
        exit 1
    fi
    if [ -z "${ENV_TINE20_ADMIN_NAME}" ];
    then
        echo >&2 "Environment variable named is ENV_TINE20_ADMIN_NAME missing."
        exit 1
    fi
    if [ -z "${ENV_TINE20_ADMIN_PASS}" ];
    then
        echo >&2 "Environment variable named is ENV_TINE20_ADMIN_PASS missing."
        exit 1
    fi
    if [ -z "${ENV_TINE20_SETUP_NAME}" ];
    then
        echo >&2 "Environment variable named is ENV_TINE20_SETUP_NAME missing."
        exit 1
    fi
    if [ -z "${ENV_TINE20_SETUP_PASS}" ];
    then
        echo >&2 "Environment variable named is ENV_TINE20_SETUP_PASS missing."
        exit 1
    fi
    if [ -z "${ENV_TIMEZONE}" ];
    then
        echo >&2 "Environment variable named is ENV_TIMEZONE missing."
        exit 1
    fi
    if [ -z "${ENV_SERVER_SCHEME}" ];
    then
        echo >&2 "Environment variable named is ENV_SERVER_SCHEME missing."
        exit 1
    fi
    if [ -z "${ENV_SERVER_NAME}" ];
    then
        echo >&2 "Environment variable named is ENV_SERVER_NAME missing."
        exit 1
    fi
    echo " * Checking system environment ... done"
}

function check_system_environment_validity() {
    echo " * Checking validity of environment variables ..."
    if ! [[ "${ENV_TINE20_DB_LOCATION}" =~ ^[0-9a-zA-Z.]+$ ]]; then
        echo >&2 "Error: Provided database location '${ENV_TINE20_DB_LOCATION}' contains invalid characters."
        exit 1
    fi
    if ! [[ "${ENV_TINE20_DB_NAME}" =~ ^[0-9a-zA-Z.]+$ ]]; then
        echo >&2 "Error: Provided database name '${ENV_TINE20_DB_NAME}' contains invalid characters."
        exit 1
    fi
    if ! [[ "${ENV_TINE20_DB_USERNAME}" =~ ^[0-9a-zA-Z.]+$ ]]; then
        echo >&2 "Error: Provided database user name '${ENV_TINE20_DB_USERNAME}' contains invalid characters."
        exit 1
    fi
    if ! [[ "${ENV_TINE20_DB_USERPASS}" =~ ^[0-9a-zA-Z.]+$ ]]; then
        echo >&2 "Error: Provided database user password '${ENV_TINE20_DB_USERPASS}' contains invalid characters."
        exit 1
    fi
    if ! [[ "${ENV_TINE20_LOG_LEVEL}" =~ ^[0-9]+$ ]]; then
        echo >&2 "Error: Provided tine log level '${ENV_TINE20_LOG_LEVEL}' contains invalid characters."
        exit 1
    fi
    if ! [[ "${ENV_TINE20_ADMIN_NAME}" =~ ^[0-9a-zA-Z.]+$ ]]; then
        echo >&2 "Error: Provided admin user name '${ENV_TINE20_ADMIN_NAME}' contains invalid characters."
        exit 1
    fi
    if ! [[ "${ENV_TINE20_ADMIN_PASS}" =~ ^[0-9a-zA-Z.]+$ ]]; then
        echo >&2 "Error: Provided admin user  password '${ENV_TINE20_ADMIN_PASS}' contains invalid characters."
        exit 1
    fi
    if ! [[ "${ENV_TINE20_SETUP_NAME}" =~ ^[0-9a-zA-Z.]+$ ]]; then
        echo >&2 "Error: Provided setup user name '${ENV_TINE20_SETUP_NAME}' contains invalid characters."
        exit 1
    fi
    if ! [[ "${ENV_TINE20_SETUP_PASS}" =~ ^[0-9a-zA-Z.]+$ ]]; then
        echo >&2 "Error: Provided setup user password '${ENV_TINE20_SETUP_PASS}' contains invalid characters."
        exit 1
    fi
    if ! [[ "${ENV_SERVER_NAME}" =~ ^[0-9a-zA-Z.]+$ ]]; then
        echo >&2 "Error: Provided server name '${ENV_SERVER_NAME}' contains invalid characters."
        exit 1
    fi
    echo " * Checking validity of environment variables ... done"
}

function ensure_correct_ownership_of_tine20_log_and_lib_directory() {
    echo " * Setting correct ownership for /var/log/tine20/ and /var/lib/tine20/ ..."
    chown www-data:www-data     /var/log/tine20 \
 && chown www-data:www-data -R  /var/lib/tine20
    echo " * Setting correct ownership for /var/log/tine20/ and /var/lib/tine20/ ... done"
}

function ensure_correct_ownership_of_tine20_etc_directory() {
    echo " * Setting correct ownership for /etc/tine20/ ..."
    chown www-data:www-data -R  /etc/tine20
    echo " * Setting correct ownership for /etc/tine20/ ... done"
}

function generate_timezone_information() {
    echo " * Generating timezone information ..."
    ln -fns "/usr/share/zoneinfo/${ENV_TIMEZONE}" "/etc/localtime"
    echo "${ENV_TIMEZONE}" >                      "/etc/timezone"
    echo " * Generating timezone information ... done"
}

function is_directory_empty() {
    local VAR_PATH_TO_DIRECTORY=${1}

    if [ ! -d ${VAR_PATH_TO_DIRECTORY} ] || [ -z "$( ls -A ${VAR_PATH_TO_DIRECTORY} )" ];
    then
        echo "true"
    else
        echo "false"
    fi
}

function import_tine20_configuration_directory_if_necessary() {
    echo " * Importing tine20 configuration directory ..."

    local VAR_IS_EMPTY=$( is_directory_empty /etc/tine20 )

    if [ "${VAR_IS_EMPTY}" = "true" ];
    then
        cp -pr /import/etc/tine20/. /etc/tine20
        echo " * Importing tine20 configuration directory ... done"
    else
        echo " * Importing tine20 configuration directory ... skipped"
    fi
}

function generate_tine20_php_configuration_file() {
    echo " * Generating tine20 php configuration file ..."
    mkdir -p "/usr/share/tine20"
    sed -e "s/\${TINE20_DB_USERNAME}/${ENV_TINE20_DB_USERNAME}/g"       \
        -e "s/\${TINE20_DB_USERPASS}/${ENV_TINE20_DB_USERPASS}/"        \
        -e "s/\${TINE20_DB_LOCATION}/${ENV_TINE20_DB_LOCATION}/"        \
        -e "s/\${TINE20_DB_NAME}/${ENV_TINE20_DB_NAME}/"                \
        -e "s/\${TINE20_LOG_LEVEL}/${ENV_TINE20_LOG_LEVEL}/"            \
        -e "s/\${TINE20_SETUP_USERNAME}/${ENV_TINE20_SETUP_NAME}/"      \
        -e "s/\${TINE20_SETUP_USERPASS}/${ENV_TINE20_SETUP_PASS}/"      \
        -e "s/\${SERVER_SCHEME}/${ENV_SERVER_SCHEME}/"                  \
        -e "s/\${SERVER_NAME}/${ENV_SERVER_NAME}/"                      \
        "/templates/config.inc.php.dist"                                \
        > "/etc/tine20/config.inc.php"
    echo " * Generating tine20 php configuration file ... done"
}

function generate_tine20_apache_configuration_file() {
    echo " * Generating tine20 apache configuration file ..."
    sed -e "s/\${SERVER_NAME}/${ENV_SERVER_NAME}/g" \
        "/templates/apache.conf"                    \
        > "/etc/tine20/apache.conf"
    echo " * Generating tine20 apache configuration file ... done"
}

function import_pre_configured_database_configuration_if_database_directory_is_empty() {
    local VAR_IS_DATABASE_DIRECTORY_EMPTY=${1}

    if [ "${VAR_IS_DATABASE_DIRECTORY_EMPTY}" = "true" ];
    then
        echo " * Importing pre-configured mysql database configuration ..."
        cp -pr "/import/var/lib/mysql/." "/var/lib/mysql/"
        echo " * Importing pre-configured mysql database configuration ... done"
    fi
}

function create_tine20_database_if_database_directory_is_empty() {
    local VAR_IS_DATABASE_DIRECTORY_EMPTY=${1}

    if [ "${VAR_IS_DATABASE_DIRECTORY_EMPTY}" = "true" ];
    then
        echo " * Creating tine20 database '${ENV_TINE20_DB_NAME}' ..."
        service mysql restart                                                                                                                                                      \
        && mysql --execute="CREATE DATABASE ${ENV_TINE20_DB_NAME} DEFAULT CHARACTER SET 'UTF8';"                                                                                   \
        && mysql --execute="GRANT ALL PRIVILEGES ON ${ENV_TINE20_DB_NAME}.* TO '${ENV_TINE20_DB_USERNAME}'@'${ENV_TINE20_DB_LOCATION}' IDENTIFIED BY '${ENV_TINE20_DB_USERPASS}';"
        echo " * Creating tine20 database '${ENV_TINE20_DB_NAME}' ... done"
    fi
}

function install_tine20_applications() {
    echo " * Installing tine20 applications ..."
    sudo -u www-data php "/usr/share/tine20/setup.php"   \
            --config=/etc/tine20/config.inc.php          \
            --install                                    \
            -- adminLoginName="${ENV_TINE20_ADMIN_NAME}" \
               adminPassword="${ENV_TINE20_ADMIN_PASS}"  \
               acceptedTermsVersion=100
    echo " * Installing tine20 applications ... done"
}

function enable_tine20_apache_configuration() {
    ln --symbolic --force                      \
       /etc/tine20/apache.conf                 \
       /etc/apache2/conf-available/tine20.conf \
 && ln --symbolic --force                      \
       /etc/apache2/conf-available/tine20.conf \
       /etc/apache2/conf-enabled/tine20.conf
}

function configure_apache2_server_name() {
    echo " * Configuring apache2 server name ..."
    echo "ServerName ${ENV_SERVER_NAME}" \
      >> "/etc/apache2/apache2.conf"
    echo " * Configuring apache2 server name ... done"
}

echo "Preparing tine20 environment ..."

check_system_environment
check_system_environment_validity

ensure_correct_ownership_of_tine20_log_and_lib_directory
generate_timezone_information

echo "Preparing tine20 environment ... done"

CONST_MARKER_FOR_SUCCESSFUL_SETUP="/var/lib/tine20/setup/.setup-was-successful"

if [ ! -f "${CONST_MARKER_FOR_SUCCESSFUL_SETUP}" ];
then
    echo "Performing tine20 setup ..."

    VAR_IS_DATABASE_DIRECTORY_EMPTY="$( is_directory_empty /var/lib/mysql )"

    generate_timezone_information
    import_tine20_configuration_directory_if_necessary
    generate_tine20_php_configuration_file
    generate_tine20_apache_configuration_file
    import_pre_configured_database_configuration_if_database_directory_is_empty ${VAR_IS_DATABASE_DIRECTORY_EMPTY}
    create_tine20_database_if_database_directory_is_empty                       ${VAR_IS_DATABASE_DIRECTORY_EMPTY}
    install_tine20_applications

    echo "${TINE20_VERSION}" > "${CONST_MARKER_FOR_SUCCESSFUL_SETUP}"
    echo "Performing tine20 setup ... done"
fi

echo "Starting tine20 ..."

ensure_correct_ownership_of_tine20_etc_directory
keep_timezone_information_up_to_date
enable_tine20_apache_configuration
configure_apache2_server_name

service mysql   restart
service apache2 restart

sleep infinity & \
VAR_SLEEP=${!}

echo "Starting tine20 ... done"

trap 'echo "Stopping tine20 ...";      \
      kill -TERM ${VAR_SLEEP};         \
      service apache2 stop;            \
      service mysql   stop;            \
      echo "Stopping tine20 ... done"; \
      exit 0'                          \
    SIGTERM

wait ${VAR_SLEEP}
