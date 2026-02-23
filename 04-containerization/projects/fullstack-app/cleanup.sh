#!/bin/bash
echo "Stopping containers..."
docker-compose down

echo "Removing unused volumes and networks..."
docker volume prune -f
docker network prune -f

echo "System clean!"