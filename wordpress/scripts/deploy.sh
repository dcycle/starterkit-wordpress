#!/bin/bash
#
# This script is run when the Drupal docker container is ready. It prepares
# an environment for development or testing, which contains a full Drupal
# 8 installation with a running website and our custom modules.
#
set -e

if [ -z "$WORDPRESS_DB_PASSWORD" ]; then
  >&2 echo 'WORDPRESS_DB_PASSWORD should always be set; please destroy your'
  >&2 echo 'environment using "docker-compose down -v", then restart it'
  >&2 echo 'using ./scripts/deploy.sh, which should create a password in'
  >&2 echo 'the ./.env file.'
  exit 2;
fi

echo "Will try to connect to MySQL container until it is up. This can take about 15 seconds."
OUTPUT="ERROR"
while [[ "$OUTPUT" == *"ERROR"* ]]
do
  OUTPUT=$(echo 'show databases'|{ mysql -h mysql -u root --password="$WORDPRESS_DB_PASSWORD" 2>&1 || true; })
  if [[ "$OUTPUT" == *"ERROR"* ]]; then
    echo "MySQL container is not available yet. Should not be long..."
    sleep 1
  else
    echo "MySQL is up! Moving on..."
  fi
done

OUTPUT=$(echo 'select * from users limit 1'|{ mysql --user=root --password="$WORDPRESS_DB_PASSWORD" --database=drupal --host=mysql 2>&1 || true; })
if [[ "$OUTPUT" == *"ERROR"* ]]; then
  echo "Using starter data because we did not find an entry in the users table."
  echo "Instaling the starter database..."
  # drush sqlc < /starter-data/initial.sql
  echo "Instaling the starter files such as images..."
  # cp -r /starter-data/files/* /var/www/html/sites/default/files/
  echo "Done installing starter data."
else
  echo "Assuming Drupal is already running, because there is a users table with at least one entry."
fi
# mkdir -p /var/www/html/sites/default/files
# chown -R www-data:www-data /var/www/html/sites/default/files
# cp /scripts/public-htaccess-file.txt /var/www/html/sites/default/files/.htaccess
