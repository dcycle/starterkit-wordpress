#!/bin/bash
#
# Remember docker-compose ports due to
# https://github.com/docker/compose/issues/4748.
#
set -e

RESULT=$(./scripts/docker-compose.sh ps)
echo "$RESULT"
CONTAINER_WORDPRESS=$(echo "$RESULT" | grep _wordpress_ | grep -o '^[-a-zA-Z0-9_]*')
{
  echo CONTAINER_WORDPRESS="$CONTAINER_WORDPRESS"
} > ./.docker-compose-info
CONTAINER_MYSQL=$(echo "$RESULT" | grep _mysql_ | grep -o '^[-a-zA-Z0-9_]*')
{
  echo CONTAINER_MYSQL="$CONTAINER_MYSQL"
} >> ./.docker-compose-info

source ./.env
EXTRA="./scripts/$CURRENT_TARGET_ENV/docker-compose-remember-info.source.sh"
if [ -f "$EXTRA" ]; then
  source "$EXTRA"
fi
