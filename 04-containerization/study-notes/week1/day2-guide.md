## 📘 Day 2: Docker Core Concepts & Commands

## 🎯 Learning Objectives

    Master Docker command-line interface

    Understand container lifecycle

    Work with Docker images

    Practice container management

## 📚 Morning Resources (6:00-6:30 AM)

Video Tutorial (15 mins):

    Docker Commands Tutorial

    Key Takeaways:

        Container lifecycle commands

        Image management

        Port mapping and networking

Reading Material (10 mins):

    Docker CLI Reference

    Focus on:

        Container management commands

        Image commands

        System commands

Command Examples (5 mins):
bash

# Lifecycle commands

docker create    # Create container without starting
docker start     # Start existing container
docker restart   # Restart container
docker pause     # Pause processes
docker unpause   # Unpause processes

# Container inspection

docker inspect   # Detailed container info
docker top       # Running processes
docker stats     # Live performance stats
docker diff      # Filesystem changes

💻 Evening Practice (6:30-8:00 PM)
Project: Container Management Lab (75 mins)
bash

# Create practice directory

mkdir -p ~/docker-practice/day2
cd ~/docker-practice/day2

# Step 1: Run multiple containers

# 1. Nginx web server

docker run -d --name web1 -p 8081:80 nginx:alpine
docker run -d --name web2 -p 8082:80 nginx:alpine
docker run -d --name web3 -p 8083:80 nginx:alpine

# 2. Check running containers

docker ps
docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"

# Step 2: Container inspection

docker inspect web1 | jq '.[0].NetworkSettings.Networks'
docker inspect web1 | jq '.[0].Config.Image'
docker inspect web1 | jq '.[0].State'

# Step 3: Resource management

# View resource usage

docker stats --no-stream
docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"

# Set resource limits on new container

docker run -d --name limited-container \
  --memory=512m \
  --cpus=1.5 \
  --memory-swap=1g \
  nginx:alpine

docker stats limited-container

# Step 4: Container networking

# Create custom network

docker network create my-network

# Run containers in custom network

docker run -d --name app1 --network my-network nginx:alpine
docker run -d --name app2 --network my-network nginx:alpine

# Test connectivity

docker exec app1 ping -c 2 app2
docker exec app2 ping -c 2 app1

# View network details

docker network inspect my-network

# Step 5: Port mapping variations

# Map specific host IP

docker run -d --name web-ip -p 127.0.0.1:8084:80 nginx:alpine

# Map random host port

docker run -d --name web-random -p 80 nginx:alpine
docker port web-random

# Map multiple ports

docker run -d --name multi-port \
  -p 8085:80 \
  -p 8443:443 \
  nginx:alpine

# Step 6: Environment variables

# Set environment variables

docker run -d --name env-app \
  -e NGINX_PORT=8080 \
  -e APP_ENV=production \
  nginx:alpine

docker exec env-app env | grep NGINX

# Step 7: Data management

# Create a volume

docker volume create my-data

# Use volume in container

docker run -d --name data-container \
  -v my-data:/data \
  -v $(pwd)/host-data:/host-data \
  nginx:alpine

# List volumes

docker volume ls
docker volume inspect my-data

# Step 8: Cleanup with filters

# Stop all containers

docker stop $(docker ps -q)

# Remove all stopped containers

docker container prune

# Remove unused volumes

docker volume prune

# Remove unused images

docker image prune

# Remove everything

docker system prune -a

Interactive Challenge (15 mins):
bash

# Challenge: Create a container with specific requirements

# Requirements:

# 1. Name: challenge-app
# 2. Port: Map host 9090 to container 80
# 3. Environment: APP_MODE=test, DEBUG=true
# 4. Volume: Mount ./data to /app/data
# 5. Network: Use custom network "challenge-net"
# 6. Resource limits: 256MB memory, 1 CPU

# Create network if not exists

docker network create challenge-net

# Create data directory

mkdir -p data

# Your solution:

docker run -d \
  --name challenge-app \
  -p 9090:80 \
  -e APP_MODE=test \
  -e DEBUG=true \
  -v $(pwd)/data:/app/data \
  --network challenge-net \
  --memory=256m \
  --cpus=1 \
  nginx:alpine

# Verify

docker inspect challenge-app | jq '.[0].Config.Env'
docker port challenge-app