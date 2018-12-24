#!/bin/sh

source ~/.scripts/secrets_to_env.sh

set -e

exec "$@"