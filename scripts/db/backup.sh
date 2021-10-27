#!/bin/sh

# Exit when any command fails
set -e

# Read .env file
export $(egrep -v '^(#|TELLME_)' ./.env | xargs)

# Today in YYYY-MM-DD
# https://stackoverflow.com/a/1401495/2736233
printf -v NOW "%(%Y-%m-%d)T" -1

docker-compose exec -i survey_db \
  /usr/bin/mongodump \
    --username $MONGO_ROOT_USERNAME \
    --password $MONGO_ROOT_PASSWORD \
    --authenticationDatabase admin \
    --db $MONGO_DATABASE \
    --out "./backups/${NOW}"

docker compose cp "survey_db:/backups/${NOW}" "./backups/${NOW}"
