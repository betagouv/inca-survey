#!/bin/bash

# Exit when any command fails:
set -e

# Load .env file
if [ -f "./.env" ]; then
  export $(egrep -v '^(#|TELLME_EDDSA_PRIVATE_KEY|TELLME_NEXT_PUBLIC_EDDSA_PUBLIC_KEY)' ./.env | xargs) > /dev/null
fi

DOCKER_COMPOSE_SERVICE_NAME="db"
DOCKER_CONTAINER_NAME="survey_db"

LAST_BACKUP_FILE_NAME=$(ls -p ./.backups | grep -v / | sort -V | tail -n 1)
LAST_BACKUP_FILE_PATH="./.backups/${LAST_BACKUP_FILE_NAME}"

echo "Removing old Docker containers with their volumes…"
docker compose down -v

echo "Starting ${DOCKER_COMPOSE_SERVICE_NAME} Docker container…"
docker compose up -d --wait "${DOCKER_COMPOSE_SERVICE_NAME}"

echo "Waiting for database to be ready…"
# https://stackoverflow.com/a/63011266/2736233
timeout 90s bash -c "until docker exec ${DOCKER_CONTAINER_NAME} pg_isready ; do sleep 1 ; done"

echo "Restoring backup '${LAST_BACKUP_FILE_PATH}'…"
cat "${LAST_BACKUP_FILE_PATH}" \
  | docker exec -i "${DOCKER_CONTAINER_NAME}" psql -d "${POSTGRES_DB}" -U "${POSTGRES_USER}"
