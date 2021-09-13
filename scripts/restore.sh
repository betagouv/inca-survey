#!/bin/sh

# Exit when any command fails
set -e

# Read .env file
export $(egrep -v '^#' ./.env | xargs)

LAST_BACKUP_FILE_NAME=$(ls -p ./backups | grep -v / | sort -V | tail -n 1)
echo $LAST_BACKUP_FILE_NAME

docker-compose exec -i db sh -c \
  'exec mysql -u root --password="${MARIADB_ROOT_PASSWORD}"' < "./backups/${LAST_BACKUP_FILE_NAME}"
