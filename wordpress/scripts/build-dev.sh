#!/bin/sh
#
# Build the Wordpress dev image.
#
set -e

/scripts/build.sh

# Make sure opcache is disabled during development so that our changes
# to PHP are reflected immediately.
echo 'opcache.enable=0' >> /usr/local/etc/php/php.ini
