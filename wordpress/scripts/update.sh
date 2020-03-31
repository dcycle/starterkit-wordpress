#!/bin/bash
#
# Update an environment to make it ready for use.
#
set -e

if [ -z "$1" ]; then
  >&2 echo 'We need as an argument the current URL, for example http://0.0.0.0:32806.'
  exit 3;
fi

wp --allow-root search-replace 'http://0.0.0.0:32806' "$1"
