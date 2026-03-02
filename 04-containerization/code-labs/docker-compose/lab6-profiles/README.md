Lab 6: Compose Profiles
🎯 Objective

Use profiles to selectively start services for different environments and use cases.
📚 What are Profiles?

Profiles allow you to define which services should be started in different scenarios (development, testing, production, debugging, etc.). Services with profiles are only started when that profile is activated.
🚀 Exercises
Exercise 1: Basic Profiles

yaml

services:
  app:
    image: nginx:alpine
    ports:
      - "8080:80"
  
  db:
    image: postgres:alpine
    environment:
      POSTGRES_PASSWORD: secret
    profiles:
      - with-db
  
  redis:
    image: redis:alpine
    profiles:
      - with-cache
      - with-db

Test:
bash

# Only app starts
docker compose up -d

# Start with db profile
docker compose --profile with-db up -d

# Start with multiple profiles
docker compose --profile with-db --profile with-cache up -d

Exercise 2: Development vs Production
yaml

services:
  app:
    build: .
    ports:
      - "8000:5000"
  
  # Development-only services
  adminer:
    image: adminer
    ports:
      - "8080:8080"
    profiles:
      - dev
  
  mailhog:
    image: mailhog/mailhog
    ports:
      - "8025:8025"
    profiles:
      - dev
  
  # Production-only services
  backup:
    image: alpine
    command: backup.sh
    profiles:
      - prod
  
  monitoring:
    image: prom/prometheus
    profiles:
      - prod

Exercise 3: Testing Profile
yaml

services:
  app:
    build: .
    environment:
      - NODE_ENV=development
  
  test-db:
    image: postgres:alpine
    environment:
      POSTGRES_PASSWORD: test
    tmpfs: /var/lib/postgresql/data
    profiles:
      - test
  
  test-runner:
    build:
      context: .
      dockerfile: Dockerfile.test
    depends_on:
      - test-db
    profiles:
      - test
    command: npm test

Run tests:
bash

docker compose --profile test up test-runner

Exercise 4: Debugging Profile
yaml

services:
  app:
    build: .
    ports:
      - "3000:3000"
  
  debug-tools:
    image: alpine
    command: sh -c "apk add curl && sleep infinity"
    profiles:
      - debug
    network_mode: service:app

✅ Success Criteria

    Understand how profiles work

    Can start services with specific profiles

    Can assign multiple profiles to a service

    Know use cases for profiles