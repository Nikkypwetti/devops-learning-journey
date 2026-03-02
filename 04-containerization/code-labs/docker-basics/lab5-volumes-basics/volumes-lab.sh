#!/bin/bash
echo "💾 Volume Basics Lab"
echo "===================="
Clean up

docker volume rm test-data 2>/dev/null || true
Create volume

echo -e "\n1️⃣ Creating volume..."
docker volume create test-data
Write data

echo -e "\n2️⃣ Writing data to volume..."
docker run --rm
-v test-data:/data
alpine sh -c "echo 'Hello Volume!' > /data/test.txt && ls -la /data/"
Read data

echo -e "\n3️⃣ Reading data from volume..."
docker run --rm
-v test-data:/data
alpine cat /data/test.txt
Inspect volume

echo -e "\n4️⃣ Volume info:"
docker volume inspect test-data | jq '.[0].Mountpoint'
Clean up

echo -e "\n5️⃣ Cleaning up..."
docker volume rm test-data

echo -e "\n✅ Lab complete!"