#!/bin/bash
echo "🧪 Testing Flask + Redis App"
Start services

echo -e "\n1️⃣ Starting services..."
docker compose up -d
Wait for app to start

sleep 3
Test endpoint

echo -e "\n2️⃣ Testing web app:"
curl -s http://localhost:8000

echo -e "\n\n3️⃣ Refreshing (count should increase):"
curl -s http://localhost:8000
Show logs

echo -e "\n\n4️⃣ Service logs:"
docker compose logs --tail=5 web
Stop services

echo -e "\n5️⃣ Stopping services..."
docker compose down

echo -e "\n✅ Test complete!"