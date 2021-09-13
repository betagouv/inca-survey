#!/bin/sh

# Exit when any command fails
set -e

echo "Stopping existing Docker containers..."
docker-compose down

echo "Starting db and app Docker containers (development)..."
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up app
