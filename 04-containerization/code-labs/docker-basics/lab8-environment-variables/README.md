Lab 8: Environment Variables
🎯 Objective

Learn to pass configuration to containers using environment variables.
🚀 Exercises
Exercise 1: Basic Environment Variables

bash

# Pass single variable
docker run --rm -e MY_NAME=John alpine env | grep MY_NAME

# Pass multiple variables
docker run --rm \
  -e DB_HOST=localhost \
  -e DB_PORT=5432 \
  -e DB_USER=admin \
  alpine env | grep DB_

Exercise 2: Using .env File

Create .env:
bash

APP_ENV=production
APP_DEBUG=false
DB_HOST=postgres
DB_USER=app_user
DB_PASSWORD=secret123

Load from file:
bash

docker run --rm --env-file .env alpine env

Exercise 3: Environment in Dockerfile

Create Dockerfile:
dockerfile

FROM alpine:3.19

# Set during build
ENV APP_HOME=/app
ENV NODE_ENV=production

WORKDIR $APP_HOME

# Build-time variables (not persisted)
ARG VERSION=1.0.0
RUN echo "Building version $VERSION"

# Can be overridden at runtime
ENV PORT=3000

CMD env | grep -E "APP_|NODE_|PORT|VERSION"

Build with build args:
bash

docker build --build-arg VERSION=2.1.0 -t env-test .
docker run --rm env-test

Exercise 4: Override at Runtime
bash

# Default values
docker run --rm env-test

# Override PORT
docker run --rm -e PORT=8080 env-test

# Add new variable
docker run --rm -e CUSTOM_VAR=custom_value env-test

# Unset variable
docker run --rm -e NODE_ENV= env-test

Exercise 5: MySQL Example
bash

# MySQL uses environment variables for configuration
docker run -d \
  --name mysql-db \
  -e MYSQL_ROOT_PASSWORD=rootpass \
  -e MYSQL_DATABASE=myapp \
  -e MYSQL_USER=appuser \
  -e MYSQL_PASSWORD=apppass \
  -p 3306:3306 \
  mysql:8

# Verify variables are set
docker exec mysql-db env | grep MYSQL_

Exercise 6: Environment Variable Precedence
bash

# Order of precedence (highest to lowest):
# 1. Runtime -e flags
# 2. --env-file
# 3. ENV in Dockerfile
# 4. Defaults in application

# Example: Same variable set multiple ways
export TEST_VAR=shell_value
echo "TEST_VAR=file_value" > test.env

docker run --rm \
  --env-file test.env \
  -e TEST_VAR=cli_value \
  alpine env | grep TEST_VAR
# Output: TEST_VAR=cli_value

📝 Practice Challenge

Create a PostgreSQL container with:

    Custom database name

    Custom username and password

    Verify variables are set correctly

    Connect and create a test table

✅ Success Criteria

    Can pass variables with -e flag

    Can use .env files

    Understand build args vs env vars

    Know environment variable precedence

    Can configure apps with environment