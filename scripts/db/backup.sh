#!/bin/bash

# Exit when any command fails:
set -e

# Load .env file
if [ -f "./.env" ]; then
  export $(egrep -v '^#' ./.env | xargs) > /dev/null
fi

DOCKER_COMPOSE_SERVICE_NAME="survey_db"
DOCKER_CONTAINER_NAME="survey_db"

BACKUP_FILE_PATH="./.backups/$(date '+%Y-%m-%d').sql"

if [ ! -d ./.backups ]; then
  mkdir ./.backups
fi

docker exec -t "${DOCKER_CONTAINER_NAME}" pg_dumpall -c -U "${POSTGRES_USER}" > "${BACKUP_FILE_PATH}"
