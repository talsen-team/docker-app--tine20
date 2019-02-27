#!/bin/bash

set -euo pipefail

function export_user_to_environment() {
    echo " * Exporting environment variable USER ..."

    export USER=$( whoami )

    echo " * Exporting environment variable USER ... done"
}

function install_ssmtp() {
    echo " * Installing ssmtp ..."

    apt-get install --yes --no-install-recommends \
                ssmtp

    echo " * Installing ssmtp ... done"
}

function generate_ssmtp_configuration() {
    echo " * Generating ssmtp configuration ..."

    echo "${USER}=${ENV_SSMTP_MAIL_AUTH_USER}"             > /etc/ssmtp/ssmtp.conf
    echo "mailhub=${ENV_SSMTP_MAIL_HUB}"                  >> /etc/ssmtp/ssmtp.conf
    echo "hostname=$( hostname )"                         >> /etc/ssmtp/ssmtp.conf
    echo "AuthUser=${ENV_SSMTP_MAIL_AUTH_USER}"           >> /etc/ssmtp/ssmtp.conf
    echo "AuthPass=${ENV_SSMTP_MAIL_AUTH_PASS}"           >> /etc/ssmtp/ssmtp.conf
    echo "AuthMethod=${ENV_SSMTP_MAIL_AUTH_METHOD}"       >> /etc/ssmtp/ssmtp.conf
    echo "TLS_CA_FILE=/etc/ssl/certs/ca-certificates.crt" >> /etc/ssmtp/ssmtp.conf
    set +u
    if [ "${ENV_SSMTP_MAIL_USE_TLS}" = "YES" ];
    then
    echo "UseTLS=YES"                                     >> /etc/ssmtp/ssmtp.conf
    fi
    if [ "${ENV_SSMTP_MAIL_USE_START_TLS}" = "YES" ];
    then
    echo "UseSTARTTLS=YES"                                >> /etc/ssmtp/ssmtp.conf
    fi
    set -u

    echo " * Generating ssmtp configuration ... done"

    echo " * Generating ssmtp reverse alias configuration ..."

    echo "${USER}:${ENV_SSMTP_MAIL_AUTH_USER}:${ENV_SSMTP_MAIL_HUB}" > /etc/ssmtp/revaliases

    echo " * Generating ssmtp reverse alias configuration ... done"
}

function generate_test_mail() {
    echo " * Generating test mail ..."

    echo "To: ${ENV_SSMTP_MAIL_AUTH_USER}"       > /tmp/mail.txt
    echo "From: ${ENV_SSMTP_MAIL_AUTH_USER}"    >> /tmp/mail.txt
    echo "Subject: Test"                        >> /tmp/mail.txt
    echo ""                                     >> /tmp/mail.txt
    echo "This is a test mail sent from ssmtp." >> /tmp/mail.txt

    echo " * Generating test mail ... done"
}

function send_test_mail() {
    echo " * Sending test mail ..."

    ssmtp ${ENV_SSMTP_MAIL_AUTH_USER} < /tmp/mail.txt

    echo " * Sending test mail ... done"
}

function remove_generated_test_mail() {
    echo " * Removing generated test mail ..."

    rm /tmp/mail.txt

    echo " * Removing generated test mail ... done"
}

export_user_to_environment
install_ssmtp
generate_ssmtp_configuration
generate_test_mail
send_test_mail
remove_generated_test_mail
