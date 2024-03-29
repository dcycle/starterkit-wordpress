#!/bin/bash
#
# Assuming you have the latest version Docker installed, this script will
# fully create or update your environment.
#
set -e

export BASE="$(pwd)"

# See http://patorjk.com/software/taag/#p=display&f=Ivrit&t=D8%20Starterkit%0A
cat ./scripts/lib/my-ascii-art.txt

echo ''
echo '-----'
echo 'Ensuring the integrity of the .env file.'
source ./scripts/lib/assert-env.source.sh

echo ''
echo '-----'
echo 'About to try to get the latest version of images including'
echo 'https://hub.docker.com/r/dcycle/drupal/ from the Docker hub. This image'
echo 'is updated automatically every Wednesday with the latest version of'
echo 'Drupal and Drush. If the image has changed since the latest deployment,'
echo 'the environment will be completely rebuilt based on this image.'
docker pull wordpress:fpm-alpine
docker pull mariadb

docker build -f="Dockerfile-wordpress-base" -t local-starterkit-wordpress-base .
source ./scripts/lib/hook.source.sh pull-extra-images
source ./scripts/lib/hook.source.sh post-pull-steps

echo ''
echo '-----'
echo 'About to create the starterkit_wordpress_default network if it does'
echo 'exist, because we need it to have a predictable name when we try to'
echo 'connect other containers to it (for example browser testers).'
echo 'The network is then referenced in docker-compose.yml.'
echo 'See https://github.com/docker/compose/issues/3736.'
docker network ls | grep starterkit_wordpress_default || docker network create starterkit_wordpress_default

echo ''
echo '---DETERMINE LOCAL DOMAIN---'
echo 'The local domain variable, used by https-deploy.sh does not need to be'
echo 'set during non-https deployment, however we will set it anyway because'
echo 'otherwise docker-compose up will complain that the variable is not set.'
source ./scripts/lib/set-local-domain.sh

echo ''
echo '-----'
echo 'About to start persistent (-d) containers based on the images defined'
echo 'in ./Dockerfile and ./docker-compose.yml. We are also telling'
echo 'docker-compose to rebuild the images if they are out of date.'
# Cannot quote $DOCKER_COMPOSE_FILES here
echo 'Docker-compose files are '"$DOCKER_COMPOSE_FILES"
# shellcheck disable=SC2086
docker-compose $DOCKER_COMPOSE_FILES up -d --build

echo ''
echo '-----'
echo 'Running the deploy script on the running containers. This installs'
echo 'Wordpress if it is not yet installed.'
docker exec "$(docker-compose ps -q mysql)" /scripts/deploy.sh

# If you need to do stuff after deployment such as set a state variable, do it
# here.

echo ''
echo '-----'
echo 'Running the update script on the container.'
docker exec "$(docker-compose ps -q wordpress)" /scripts/update.sh $(docker-compose port wordpress 80)
echo ''
echo '-----'
echo ''
echo 'If all went well you can now access your site at:'
./scripts/uli.sh
echo '-----'
echo ''
echo 'You might want to visit /admin/reports/status and fix any problems.'
echo ''
