#!/bin/bash
echo "🌐 Compose Networking Test"

cat > compose.yaml << 'END'
services:
server:
image: alpine
command: sh -c "echo 'Server running' && sleep 3600"
networks:

    test-net

client:
image: alpine
command: sh -c "ping -c 3 server && echo 'Network works!'"
networks:

    test-net
    depends_on:

    server

networks:
test-net:
END

echo -e "\n1️⃣ Starting services..."
docker compose up client

echo -e "\n2️⃣ Cleaning up..."
docker compose down

rm compose.yaml
echo -e "\n✅ Test complete!"