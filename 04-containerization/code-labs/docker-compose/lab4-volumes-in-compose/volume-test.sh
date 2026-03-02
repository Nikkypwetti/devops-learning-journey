#!/bin/bash
echo "💾 Compose Volume Test"
Create test directory

mkdir -p test-data

cat > compose.yaml << 'END'
services:
writer:
image: alpine
command: sh -c "echo 'Test data' > /data/test.txt && echo 'Data written'"
volumes:

    test-data:/data

reader:
image: alpine
command: cat /data/test.txt
volumes:

    test-data:/data:ro
    depends_on:
    writer:
    condition: service_completed_successfully

volumes:
test-data:
END

echo -e "\n1️⃣ Running writer and reader..."
docker compose up reader

echo -e "\n2️⃣ Cleaning up..."
docker compose down -v

rm compose.yaml
rmdir test-data 2>/dev/null

echo -e "\n✅ Test complete!"