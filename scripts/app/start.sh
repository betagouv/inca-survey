#!/bin/bash

# Exit when any command fails
set -e

echo "Building survey_app Docker container..."
sudo docker-compose build --no-cache --pull survey_app

echo "Stopping existing Docker containers..."
docker-compose down

echo "Starting survey_db and survey_app Docker containers..."
docker-compose up -d survey_app
