#!/bin/bash
#
# Get a one-time login link to your development environment.
#
set -e

docker exec "$(./scripts/docker-compose-container.sh wordpress)" /bin/bash -c "wp --allow-root plugin install one-time-login --activate"

echo ''
echo ' => Wordpress: '"$(docker exec "$(./scripts/docker-compose-container.sh wordpress)" /bin/bash -c "wp --allow-root user one-time-login admin")"
source ./.env
export TARGET_ENV="$CURRENT_TARGET_ENV"
source ./scripts/lib/hook.source.sh uli
echo ''
