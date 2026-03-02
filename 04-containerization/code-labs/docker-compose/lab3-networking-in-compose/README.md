Lab 3: Networking in Compose
🎯 Objective

Understand how Docker Compose handles networking and service discovery.
📚 Key Concepts

When you run docker compose up, Compose automatically:

    Creates a default network for your project

    Adds all containers to this network

    Makes services accessible by their service name

🚀 Exercises
Exercise 1: Default Network

Create compose.yaml:

yaml

services:
  app1:
    image: alpine
    command: ping app2
    depends_on:
      - app2
  
  app2:
    image: alpine
    command: sleep 3600

Run and observe:
bash

docker compose up
# app1 can ping app2 by name!

Exercise 2: Custom Networks
yaml

services:
  frontend:
    image: nginx:alpine
    networks:
      - frontend
      - backend
  
  api:
    image: alpine
    command: sleep 3600
    networks:
      - backend
  
  database:
    image: postgres:alpine
    environment:
      POSTGRES_PASSWORD: secret
    networks:
      - backend

networks:
  frontend:
  backend:

Exercise 3: Network Isolation
yaml

services:
  public-web:
    image: nginx:alpine
    ports:
      - "8080:80"
    networks:
      - public
  
  private-api:
    image: alpine
    command: sleep 3600
    networks:
      - private
  
  database:
    image: postgres:alpine
    environment:
      POSTGRES_PASSWORD: secret
    networks:
      - private

networks:
  public:
  private:
    internal: true  # No external access

Exercise 4: Network Aliases
yaml

services:
  db:
    image: postgres:alpine
    environment:
      POSTGRES_PASSWORD: secret
    networks:
      backend:
        aliases:
          - database
          - postgres
  
  app:
    image: alpine
    command: sh -c "ping database && ping postgres"
    networks:
      - backend

networks:
  backend:

✅ Success Criteria

    Understand default Compose networking

    Can create custom networks

    Know how to isolate services

    Can use network aliases

    Understand internal networks