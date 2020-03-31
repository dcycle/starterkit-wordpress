#!/bin/bash
#
# Get a previously remembered docker-compose container.
#
set -e

if [ ! -f ./.docker-compose-info ]; then
  ./scripts/docker-compose-remember-info.sh
fi

source ./.docker-compose-info

if [ "$1" == 'wordpress' ]; then
  echo "$CONTAINER_WORDPRESS"
elif [ "$1" == 'mail' ]; then
  echo "$CONTAINER_MAIL"
elif [ "$1" == 'mysql' ]; then
  echo "$CONTAINER_MYSQL"
else
  >&2 echo 'Please specify wordpress or mail or mysql';
  exit 1
fi
