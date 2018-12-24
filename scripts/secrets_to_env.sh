#!/bin/sh

: ${SECRETS_DIR:=/run/secrets}

function print_debug_msg()
{
    if [[ ! -z "$SECRETS_TO_ENV_DEBUG" ]]; then
        echo -e "\033[1m$@\033[0m"
    fi
}

expand_secret() {
    var="$1"
    eval val=\$$var
    if secret_name=$(expr match "$val" "{{DOCKER-SECRET:\([^}]\+\)}}$"); then
        secret="${SECRETS_DIR}/${secret_name}"
        print_debug_msg "Secret file for $var: $secret"
        if [[ -f "$secret" ]]; then
            val=$(cat "${secret}")
            export "$var"="$val"
            print_debug_msg "Expanded variable: $var=$val"
        else
            print_debug_msg "Secret file does not exist! $secret"
        fi
    fi
}

expand_secrets() {
    for env_var in $(printenv | cut -f1 -d"=")
    do
        expand_secret $env_var
    done

    if [[ ! -z "$SECRETS_TO_ENV_DEBUG" ]]; then
        echo -e "\n\033[1mExpanded environment variables\033[0m"
        printenv
    fi
}

expand_secrets