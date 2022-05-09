#!/bin/bash
set -e

./scripts/docker-compose.sh exec mysql /bin/bash -c 'echo "drop database wordpress; create database wordpress;" | mysql -p"$MYSQL_ROOT_PASSWORD"'
./scripts/docker-compose.sh exec wordpress /bin/bash -c "wp --allow-root core install --url=http://$(docker-compose port wordpress 80) --title='WP Starterkit' --admin_user=admin --admin_email=wp_starterkit@example.com"
./scripts/uli.sh
