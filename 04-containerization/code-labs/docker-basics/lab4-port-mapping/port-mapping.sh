#!/bin/bash
echo "🌐 Port Mapping Practice"
echo "========================"
Clean up any existing containers

docker rm -f nginx1 nginx2 nginx3 2>/dev/null || true
Run three web servers

echo -e "\n1️⃣ Starting three web servers..."
docker run -d --name nginx1 -p 8081:80 nginx:alpine
docker run -d --name nginx2 -p 8082:80 nginx:alpine
docker run -d --name nginx3 -p 8083:80 nginx:alpine
Test each

echo -e "\n2️⃣ Testing each server..."
for port in 8081 8082 8083; do
echo -n "Port $port: "
curl -s -o /dev/null -w "%{http_code}" http://localhost:$port
echo ""
done
Show mappings

echo -e "\n3️⃣ Port mappings:"
docker ps --format "table {{.Names}}\t{{.Ports}}"
Clean up

echo -e "\n4️⃣ Cleaning up..."
docker rm -f nginx1 nginx2 nginx3

echo -e "\n✅ Practice complete!"