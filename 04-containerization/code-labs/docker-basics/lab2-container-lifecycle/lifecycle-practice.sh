#!/bin/bash
echo "🔄 Container Lifecycle Practice"
echo "==============================="
Clean up any existing containers

docker rm -f web-server 2>/dev/null || true
Step 1: Create

echo -e "\n1️⃣ Creating container..."
docker create --name web-server -p 8080:80 nginx:alpine
docker ps -a | grep web-server
Step 2: Start

echo -e "\n2️⃣ Starting container..."
docker start web-server
sleep 2
docker ps | grep web-server
Step 3: Test

echo -e "\n3️⃣ Testing web server..."
curl -s -I http://localhost:8080 | head -1
Step 4: Stop

echo -e "\n4️⃣ Stopping container..."
docker stop web-server
docker ps -a | grep web-server
Step 5: Remove

echo -e "\n5️⃣ Removing container..."
docker rm web-server
docker ps -a | grep web-server || echo "✅ Container removed"

echo -e "\n✅ Practice complete!"