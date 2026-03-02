#!/bin/bash
echo "🔧 Compose Environment Test"
Create .env file

cat > .env << 'END'
TEST_VAR=hello_from_env
APP_MODE=testing
END
Create compose file

cat > compose.yaml << 'END'
services:
tester:
image: alpine
command: sh -c "echo 'TEST_VAR =' $TEST_VAR; echo 'APP_MODE =' $APP_MODE; echo 'CUSTOM =' $CUSTOM"
environment:

    TEST_VAR=${TEST_VAR}

    APP_MODE=${APP_MODE}

    CUSTOM=${CUSTOM:-default_value}
    END

echo -e "\n1️⃣ Running with .env values..."
docker compose run --rm tester

echo -e "\n2️⃣ Overriding single variable..."
CUSTOM=override_value docker compose run --rm tester
Clean up

docker compose down
rm .env compose.yaml

echo -e "\n✅ Test complete!"