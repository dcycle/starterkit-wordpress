#!/bin/bash
#
# Generate a UUID.
#
set -e

docker run --rm wordpress:fpm-alpine /bin/bash -c 'cat /proc/sys/kernel/random/uuid'
