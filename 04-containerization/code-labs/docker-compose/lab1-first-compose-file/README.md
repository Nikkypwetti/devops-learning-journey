# Lab 1: First Compose File

## 🎯 Objective
Create and run your first Docker Compose file to understand the basics.

## 📚 What is Docker Compose? [citation:2][citation:3]

Docker Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a YAML file to configure your application's services, networks, and volumes. Then, with a single command, you create and start all the services from your configuration.

## 🚀 Exercises

### Exercise 1: Simple Web Server

Create `compose.yaml`:
```yaml
services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"

Method:2

services:
  web-server:
    image: nginx:alpine
    container_name: lab1-nginx-container # Always name your containers for easier debugging
    ports:
      - "8080:80" # Map Host Port 8080 to Container Port 80
    restart: always # Ensures the container restarts if it crashes or the host reboots
    environment:
      - NGINX_HOST=localhost
      - NGINX_PORT=80

Run it:
bash

# Start the service
docker compose up -d

# Check status
docker compose ps

# View logs
docker compose logs

# Stop the service
docker compose down

Exercise 2: Multiple Services

Create compose.yaml:
yaml

services:
  web1:
    image: nginx:alpine
    ports:
      - "8081:80"
  
  web2:
    image: nginx:alpine
    ports:
      - "8082:80"
  
  web3:
    image: nginx:alpine
    ports:
      - "8083:80"

Run and test:
bash

docker compose up -d
curl http://localhost:8081
curl http://localhost:8082
curl http://localhost:8083
docker compose down

Exercise 3: Building from Dockerfile

Create Dockerfile:
dockerfile

FROM nginx:alpine
COPY index.html /usr/share/nginx/html/

Create index.html:
html

<h1>Hello from Compose Build!</h1>

Create compose.yaml:
yaml

services:
  web:
    build: .
    ports:
      - "8080:80"

Run:
bash

docker compose up -d
curl http://localhost:8080

✅ Success Criteria

    Can start services with docker compose up

    Can view running services with docker compose ps

    Can stop services with docker compose down

    Understand difference between image and build