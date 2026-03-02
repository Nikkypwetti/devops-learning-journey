#!/bin/bash
echo "🎯 Compose Profiles Test"

cat > compose.yaml << 'END'
services:
app:
image: alpine
command: sh -c "echo 'Main app running' && sleep 10"

debug:
image: alpine
command: sh -c "echo 'Debug tools running' && sleep 10"
profiles:

    debug

database:
image: alpine
command: sh -c "echo 'Database running' && sleep 10"
profiles:

    with-db

    debug
    END

echo -e "\n1️⃣ Starting with no profile (app only)..."
docker compose up -d
docker compose ps

echo -e "\n2️⃣ Stopping..."
docker compose down

echo -e "\n3️⃣ Starting with debug profile..."
docker compose --profile debug up -d
docker compose ps

echo -e "\n4️⃣ Cleaning up..."
docker compose --profile debug down

rm compose.yaml

echo -e "\n✅ Test complete!"