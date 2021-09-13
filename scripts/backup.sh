#!/bin/sh

# Exit when any command fails
set -e

# Read .env file
export $(egrep -v '^#' ./.env | xargs)

# Today in YYYY-MM-DD
# https://stackoverflow.com/a/1401495/2736233
printf -v NOW "%(%Y-%m-%d)T" -1

docker-compose exec db sh -c \
  'exec mysqldump -u root --password="${MARIADB_ROOT_PASSWORD}" --all-databases' > "./backups/${NOW}.sql"
