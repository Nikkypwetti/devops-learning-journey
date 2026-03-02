#!/bin/bash
# Test script to verify Node.js Express app works correctly in both production and development Docker images
echo "🧪 Testing Node.js Docker App"

# Build production image
echo -e "\n📦 Building production image..."
docker build --target production -t node-app:prod .

# Build development image
echo -e "\n📦 Building development image..."
docker build --target development -t node-app:dev .

# Test production
echo -e "\n🚀 Testing production container..."
docker run -d --name test-prod -p 3001:3000 node-app:prod
sleep 3
curl -s http://localhost:3001 | jq .
docker stop test-prod && docker rm test-prod

# Show image sizes
echo -e "\n📊 Image sizes:"
docker images node-app:*