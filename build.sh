#!/bin/bash

set -ex

USERNAME=emzian7
IMAGE=aws-cli

DOCKER_BUILDKIT=1 docker build -t ${USERNAME}/${IMAGE}:latest .