ARG ALPINE_VERSION=latest
ARG AWS_CLI_VERSION=1.16.79
ARG CONTAINER_USER="awscli"
ARG SECRETS_DIR="/etc/secrets"

FROM alpine:${ALPINE_VERSION}

LABEL maintainer="Ishan Dassanayake" 
LABEL Version=1.0.0

ARG AWS_CLI_VERSION
ARG CONTAINER_USER
ARG SECRETS_DIR

RUN apk --no-cache update && \
    apk --no-cache add python py-pip py-setuptools ca-certificates groff less shadow && \
    rm -rf /var/cache/apk/* 

RUN useradd -K MAIL_DIR=/var/mail -ms /bin/sh ${CONTAINER_USER}

USER ${CONTAINER_USER}

# Versions: https://pypi.org/project/awscli/#history
ENV PATH ${PATH}:/home/${CONTAINER_USER}/.local/bin

ENV AWS_ACCESS_KEY_ID {{DOCKER-SECRET:AWS_ACCESS_KEY_ID}}
ENV AWS_SECRET_ACCESS_KEY {{DOCKER-SECRET:AWS_SECRET_ACCESS_KEY}}

ENV CONTAINER_USER ${CONTAINER_USER}

WORKDIR /home/${CONTAINER_USER}

RUN pip --no-cache-dir install awscli==${AWS_CLI_VERSION} --user

COPY scripts .scripts
COPY docker-entrypoint.sh .
COPY VERSION .

ENTRYPOINT [ "./docker-entrypoint.sh" ]