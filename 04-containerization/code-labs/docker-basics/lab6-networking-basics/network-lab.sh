#!/bin/bash
echo "🌐 Networking Lab"
echo "================="
Clean up

docker network rm test-net 2>/dev/null || true
Create network

echo -e "\n1️⃣ Creating custom network..."
docker network create test-net
Run two containers

echo -e "\n2️⃣ Starting containers on custom network..."
docker run -d --name server1 --network test-net alpine sleep 3600
docker run -d --name server2 --network test-net alpine sleep 3600
Test DNS resolution

echo -e "\n3️⃣ Testing DNS resolution..."
docker exec server1 ping -c 2 server2
Connect third container later

echo -e "\n4️⃣ Adding third container..."
docker run -d --name server3 alpine sleep 3600
docker network connect test-net server3
Test connectivity

echo -e "\n5️⃣ Testing all connections..."
docker exec server1 ping -c 2 server3
docker exec server3 ping -c 2 server2
Clean up

echo -e "\n6️⃣ Cleaning up..."
docker rm -f server1 server2 server3
docker network rm test-net

echo -e "\n✅ Lab complete!"