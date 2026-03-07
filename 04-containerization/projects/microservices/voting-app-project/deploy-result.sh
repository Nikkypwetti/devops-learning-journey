#!/bin/bash

# Configuration - EXACTLY matching what Swarm is looking for
IMAGE_NAME="nikkytechies/voting-app-result"
VERSION="latest"

echo "🚀 Building Advanced Result UI..."

# Change this to the actual folder name of your result app
cd voting-result 

# Build with the specific tag Swarm expects
docker build -t $IMAGE_NAME:$VERSION .

echo "📦 Pushing Result Image to Docker Hub..."
docker push $IMAGE_NAME:$VERSION

cd ..
echo "🌐 Updating Swarm..."
DOCKER_REGISTRY=nikkytechies VERSION=$VERSION docker stack deploy -c docker-compose.yml -c docker-compose.prod.yml voting_stack