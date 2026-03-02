#!/bin/bash
echo "🔧 Environment Variables Lab"
echo "============================="
Create test env file

cat > test.env << 'END'
APP_ENV=development
APP_DEBUG=true
DB_HOST=localhost
DB_NAME=testdb
END

echo -e "\n1️⃣ Environment file contents:"
cat test.env

echo -e "\n2️⃣ Running container with env file:"
docker run --rm --env-file test.env alpine env | grep -E "APP_|DB_"

echo -e "\n3️⃣ Overriding single variable:"
docker run --rm
--env-file test.env
-e APP_ENV=production
alpine env | grep APP_ENV
Clean up

rm test.env

echo -e "\n✅ Lab complete!"