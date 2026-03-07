#!/bin/bash
IMAGE_NAME="nikkytechies/voting-app-vote"

echo "🚀 Building Unified Next.js Frontend..."
cd voting-frontend
# Build once, use everywhere
docker build -t $IMAGE_NAME:latest .
docker push $IMAGE_NAME:latest

cd ..
echo "🌐 Updating Swarm Stack..."
DOCKER_REGISTRY=nikkytechies VERSION=latest docker stack deploy -c docker-compose.yml -c docker-compose.prod.yml voting_stack