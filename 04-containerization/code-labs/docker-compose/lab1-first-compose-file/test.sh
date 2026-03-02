#!/bin/bash
echo "🧪 Testing First Compose File"
Create compose file

cat > compose.yaml << 'END'
services:
test-web:
image: nginx:alpine
ports:

    "8080:80"
    END

Start service

echo -e "\n1️⃣ Starting service..."
docker compose up -d
Check status

echo -e "\n2️⃣ Service status:"
docker compose ps
Test endpoint

echo -e "\n3️⃣ Testing web server..."
curl -s -o /dev/null -w "Status: %{http_code}\n" http://localhost:8080
Stop service

echo -e "\n4️⃣ Stopping service..."
docker compose down
Clean up

rm compose.yaml

echo -e "\n✅ Test complete!"