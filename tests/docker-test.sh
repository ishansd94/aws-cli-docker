#!/bin/bash

: ${SECRETS_DIR:=/run/secrets}
: ${IMAGE_NAME:=emzian7/aws-cli}

DOCKER_BUILDKIT=1 docker build -t ${IMAGE_NAME}:test -f ../Dockerfile ../
docker push ${IMAGE_NAME}:test

docker \
    run \
    --rm \
    -v $(pwd)/AWS_ACCESS_KEY_ID:${SECRETS_DIR}/AWS_ACCESS_KEY_ID \
    -v $(pwd)/AWS_SECRET_ACCESS_KEY:${SECRETS_DIR}/AWS_SECRET_ACCESS_KEY \
    ${IMAGE_NAME}:test \
    env > env_vars

if [[ "12345" = $(cat env_vars | grep AWS_ACCESS_KEY_ID | cut -f2 -d"=") ]]; then
    echo -e "\n\033[1m Test with secrets - AWS_ACCESS_KEY_ID - passed \033[0m"
fi

if [[ "zxcasdqwe" = $(cat env_vars | grep AWS_SECRET_ACCESS_KEY | cut -f2 -d"=") ]]; then
    echo -e "\n\033[1m Test with secrets - AWS_SECRET_ACCESS_KEY - passed \033[0m"
fi

rm env_vars

docker \
    run \
    --rm \
    -e AWS_ACCESS_KEY_ID='12345' \
    -e AWS_SECRET_ACCESS_KEY='zxcasdqwe'  \
    ${IMAGE_NAME}:test \
    env > env_vars

if [[ "12345" = $(cat env_vars | grep AWS_ACCESS_KEY_ID | cut -f2 -d"=") ]]; then
    echo -e "\n\033[1m Test with env - AWS_ACCESS_KEY_ID - passed \033[0m"
fi

if [[ "zxcasdqwe" = $(cat env_vars | grep AWS_SECRET_ACCESS_KEY | cut -f2 -d"=") ]]; then
    echo -e "\n\033[1m Test with env - AWS_SECRET_ACCESS_KEY - passed \033[0m"
fi

rm env_vars