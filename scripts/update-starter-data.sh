#!/bin/bash
#
# Make the starter database correspond to what's on your environment.
#
set -e

echo " => "
echo " => Updating the database at ./wordpress/starter-data/initial.sql"
echo " => from the live database."
echo " => "

echo " => Truncating cache tables for a smaller footprint."
docker exec "$(docker-compose ps -q wordpress)" /bin/bash -c 'echo "show tables" | drush sqlc | grep cache_ | xargs -I {} echo "truncate {};" | drush sqlc'
echo " => Updating starter db."
docker exec "$(docker-compose ps -q wordpress)" /bin/bash -c 'drush sql-dump' > ./wordpress/starter-data/initial.sql
echo "[info] Adding newline between , and ( making it easier to read code diffs."
# shellcheck disable=SC1004
sed -i -e 's/,(/,\
(/g' ./wordpress/starter-data/initial.sql
rm ./wordpress/starter-data/initial.sql-e
echo " => Done updating starter db."

echo " => "
echo " => Updating the files at ./wordpress/starter-data/files from live files on" echo " => the container."
echo " => "
rm -rf ./wordpress/starter-data/files
docker exec "$(docker-compose ps -q wordpress)" /bin/bash -c 'cp -r /var/www/html/sites/default/files /starter-data/files'
docker exec "$(docker-compose ps -q wordpress)" /bin/bash -c 'rm -rf /starter-data/files/css /starter-data/files/js /starter-data/files/php /starter-data/files/styles /starter-data/files/.htaccess'
