#!/bin/bash
echo "🔍 Debugging Lab"
echo "================"
Create test containers

echo -e "\n1️⃣ Creating test containers..."
docker run -d --name test-web -p 8081:80 nginx:alpine
docker run -d --name test-logger alpine sh -c "while true; do echo 'Log test at $(date)'; sleep 2; done"
Show logs

echo -e "\n2️⃣ Showing logs (last 5 lines):"
docker logs --tail 5 test-logger
Show stats

echo -e "\n3️⃣ Container stats:"
docker stats --no-stream test-web
Inspect

echo -e "\n4️⃣ Container IP:"
docker inspect test-web --format='{{.NetworkSettings.IPAddress}}'
Exec command

echo -e "\n5️⃣ Executing command in container:"
docker exec test-web nginx -v
Clean up

echo -e "\n6️⃣ Cleaning up..."
docker rm -f test-web test-logger

echo -e "\n✅ Lab complete!"