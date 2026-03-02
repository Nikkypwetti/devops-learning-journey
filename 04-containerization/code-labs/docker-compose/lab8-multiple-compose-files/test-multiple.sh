#!/bin/bash
echo "📚 Multiple Compose Files Test"
Create base compose file

cat > compose.base.yaml << 'END'
services:
app:
image: alpine
command: sh -c "echo 'Base config - environment: ${ENV:-unknown}' && sleep 10"
environment:

    SHARED_VAR=from_base
    END

Create dev override

cat > compose.dev.yaml << 'END'
services:
app:
environment:

    ENV=development

    DEV_VAR=from_dev
    END

Create prod override

cat > compose.prod.yaml << 'END'
services:
app:
environment:

    ENV=production

    PROD_VAR=from_prod
    restart: always
    END

echo -e "\n1️⃣ Testing base + dev:"
docker compose -f compose.base.yaml -f compose.dev.yaml up -d
docker compose -f compose.base.yaml -f compose.dev.yaml logs app --tail 10
docker compose -f compose.base.yaml -f compose.dev.yaml down

echo -e "\n2️⃣ Testing base + prod:"
docker compose -f compose.base.yaml -f compose.prod.yaml up -d
docker compose -f compose.base.yaml -f compose.prod.yaml logs app --tail 10
docker compose -f compose.base.yaml -f compose.prod.yaml down
Clean up

rm compose.base.yaml compose.dev.yaml compose.prod.yaml

echo -e "\n✅ Test complete