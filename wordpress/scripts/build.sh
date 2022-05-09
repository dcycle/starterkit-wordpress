#!/bin/sh
#
# Build the Wordpress image.
#
set -e

# Avoid memory limits with large database imports.
echo 'memory_limit = 512M' >> /usr/local/etc/php/php.ini

# Avoid memory limits with large database imports.
echo 'upload_max_filesize = 25M' >> /usr/local/etc/php/php.ini
echo 'post_max_size = 25M' >> /usr/local/etc/php/php.ini

apk add --no-cache less
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
