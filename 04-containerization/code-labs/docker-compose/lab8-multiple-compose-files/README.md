Lab 8: Multiple Compose Files
🎯 Objective

Learn to use multiple Compose files for different environments and configurations.
📚 Why Multiple Files?

    Base configuration: Shared across environments

    Overrides: Environment-specific settings

    Extensions: Add services for specific use cases

    Include: Compose files can include others

🚀 Exercises
Exercise 1: Base + Override Pattern

Create compose.base.yaml (base config):

yaml

services:
  app:
    image: myapp:latest
    environment:
      - NODE_ENV=production
  
  db:
    image: postgres:alpine
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD}

Create compose.dev.yaml (development overrides):
yaml

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
    volumes:
      - .:/app
  
  db:
    ports:
      - "5432:5432"

Use together:
bash

docker compose -f compose.base.yaml -f compose.dev.yaml up -d

Exercise 2: Environment-Specific Files

Create compose.yaml (base):
yaml

services:
  app:
    build: .
    ports:
      - "${PORT:-3000}:3000"
  
  db:
    image: postgres:alpine
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD}

Create compose.prod.yaml:
yaml

services:
  app:
    environment:
      - NODE_ENV=production
    restart: always
    deploy:
      resources:
        limits:
          memory: 512M
  
  db:
    volumes:
      - db-data:/var/lib/postgresql/data

volumes:
  db-data:

Create compose.test.yaml:
yaml

services:
  app:
    environment:
      - NODE_ENV=test
    command: npm test
  
  db:
    tmpfs: /var/lib/postgresql/data

Exercise 3: Using include

Create compose.infra.yaml:
yaml

services:
  redis:
    image: redis:alpine
  
  postgres:
    image: postgres:alpine
    environment:
      POSTGRES_PASSWORD: secret

Create compose.app.yaml:
yaml

include:
  - compose.infra.yaml

services:
  web:
    build: .
    ports:
      - "3000:3000"
    depends_on:
      - redis
      - postgres

Exercise 4: Extending Services
yaml

# compose.base.yaml
services:
  api:
    image: api:latest
    environment:
      - LOG_LEVEL=info

# compose.staging.yaml
services:
  api:
    extends:
      file: compose.base.yaml
      service: api
    environment:
      - LOG_LEVEL=debug
      - DEBUG=true

Exercise 5: Config Example

Project structure:
project/
├── compose.yaml
├── compose.prod.yaml
├── compose.dev.yaml
├── .env
├── .env.prod
└── .env.dev

Run different environments:
bash

# Development
docker compose -f compose.yaml -f compose.dev.yaml --env-file .env.dev up

# Production
docker compose -f compose.yaml -f compose.prod.yaml --env-file .env.prod up

✅ Success Criteria

    Can use multiple Compose files

    Understand override order (last takes precedence)

    Can use include for shared configs

    Know how to manage environment-specific files

    Can organize complex projects