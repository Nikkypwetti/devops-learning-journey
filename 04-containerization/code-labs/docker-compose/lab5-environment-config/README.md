Lab 5: Environment Configuration
🎯 Objective

Master environment configuration in Docker Compose using variables, env files, and interpolation.
📚 Methods

    Inline: environment: in compose file

    Env file: env_file: directive

    Shell variables: ${VARIABLE} interpolation

    .env file: Automatic variable loading

🚀 Exercises
Exercise 1: Inline Environment Variables

yaml

services:
  app:
    image: alpine
    command: env
    environment:
      - APP_ENV=production
      - APP_DEBUG=false
      - DB_HOST=postgres
      - DB_PORT=5432
      - DB_NAME=myapp

Exercise 2: Using .env File

Create .env:
bash

APP_ENV=development
APP_DEBUG=true
DB_HOST=localhost
DB_USER=admin
DB_PASSWORD=secret123

Use in compose.yaml:
yaml

services:
  app:
    image: alpine
    command: env
    environment:
      - APP_ENV=${APP_ENV}
      - APP_DEBUG=${APP_DEBUG}
      - DB_HOST=${DB_HOST}
      - DB_PASSWORD=${DB_PASSWORD}

Exercise 3: Env File Directive

Create app.env:
bash

NODE_ENV=production
LOG_LEVEL=info
API_URL=https://api.example.com

Create compose.yaml:
yaml

services:
  app:
    image: node:18-alpine
    command: node -e "console.log(process.env)"
    env_file:
      - app.env

Exercise 4: Default Values
yaml

services:
  app:
    image: alpine
    command: env
    environment:
      - PORT=${PORT:-3000}
      - HOST=${HOST:-0.0.0.0}
      - LOG_LEVEL=${LOG_LEVEL:-info}
      - ${DISABLE_CACHE:+DISABLE_CACHE=true}

Exercise 5: Multiple Env Files
yaml

services:
  app:
    image: alpine
    command: env
    env_file:
      - .env.base
      - .env.${ENVIRONMENT:-dev}

Create files:

    .env.base: Common variables

    .env.dev: Development overrides

    .env.prod: Production overrides

Exercise 6: Variable Substitution in Compose
yaml

services:
  app:
    image: ${REGISTRY:-docker.io}/${IMAGE_NAME:-myapp}:${TAG:-latest}
    ports:
      - "${HOST_PORT:-8080}:${CONTAINER_PORT:-80}"
    environment:
      - DATABASE_URL=postgres://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}

✅ Success Criteria

    Can use inline environment variables

    Can load variables from .env file

    Understand variable interpolation

    Can set default values

    Know how to use multiple env files