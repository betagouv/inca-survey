#!/bin/bash

# Exit when any command fails
set -e

echo "Backing up database..."
make backup

echo "Building survey_app Docker container..."
docker compose build --no-cache --pull app

echo "Stopping existing Docker containers..."
docker compose down

echo "Starting survey_db and survey_app Docker containers..."
docker compose up -d app
