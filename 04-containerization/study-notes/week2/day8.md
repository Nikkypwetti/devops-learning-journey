Week 2: Orchestration with Docker Compose - Daily Resources

📅 Week Overview

Focus: Manage multi-container applications, handle networking, and persist data with volumes

Duration: 7 days

Success Metric: Deploy a full-stack application (Frontend, Backend, DB) using a single Docker Compose file

📘 Day 8: Docker Compose Introduction
🎯 Learning Objectives

    Understand the role of Docker Compose in multi-container setups

    Learn YAML syntax for configuration

    Create your first docker-compose.yml file

    Manage the lifecycle of an application stack (Up/Down)

📚 Morning Resources (6:00-6:30 AM)
Video Tutorial (15 mins):

    Docker Compose Tutorial - Essential guide by Mosh Hamadani

    Key Takeaways:

        Simplification: Move from complex, multi-line docker run commands to a single declarative file [07:24].

        YAML Format: Docker Compose uses YAML, which relies on indentation (no curly braces or semi-colons) to define structure [11:06].

        Service Definition: Each container is treated as a "service" (e.g., web, api, db) within the Compose file [14:22].

        Automatic Networking: Compose automatically creates a dedicated network where containers can talk to each other using their service names as hostnames [27:51].

Reading Material (10 mins):

    Docker Compose Overview

    Focus on:

        The three-step process: Dockerfile -> docker-compose.yml -> docker compose up.

        Common top-level keys: version, services, networks, and volumes.

        CLI differences between docker and docker compose.

Concept Review (5 mins):

    Project Name: By default, Compose uses the name of the project folder as a prefix for images and networks [24:23].

    Declarative vs Imperative: Instead of telling Docker how to run (commands), you describe what the end state should look like (YAML).

    Detached Mode (-d): Runs the entire stack in the background [26:23].

💻 Evening Practice (6:30-8:00 PM)
Step 1: Install & Verify Compose (10 mins)

Most modern Docker installations (Desktop for Mac/Win, or the Engine plugin for Linux) include Compose by default.
Bash

# Verify you have the V2 plugin installed

docker compose version

Step 2: Create Your First docker-compose.yml (40 mins)

Create a new directory and define a simple stack with a Web UI and a Database.
YAML

# docker-compose.yml

version: "3.8" # [00:14:01]

services:
  web:
    build: ./frontend # Points to a folder with a Dockerfile [00:16:35]
    ports:
      - "3000:3000" # Map host port 3000 to container port 3000 [00:17:35]
  
  api:
    build: ./backend
    ports:
      - "3001:3001"
    environment:
      - DB_URL=mongodb://db/vidly # Using service name 'db' as hostname [00:19:00]

  db:
    image: mongo:4.0-xenial # Pull directly from Docker Hub [00:16:49]
    ports:
      - "27017:27017"
    volumes:
      - vidly-data:/data/db # Persist DB data [00:20:43]

volumes:
  vidly-data: # Define the volume at the top level [00:21:15]

Step 3: Lifecycle Management Commands (40 mins)

Practice controlling the entire application stack.
Bash

# 1. Build or rebuild services
docker compose build

# 2. Build and start the whole stack in the background
docker compose up -d

# 3. Check the status of your stack
docker compose ps

# 4. View logs for all services (or a specific one)
docker compose logs -f
docker compose logs api

# 5. Execute a command in a running service container [00:29:13]
docker compose exec web sh

# 6. Stop and remove containers, networks, and images defined in the file
docker compose down

# 7. Practice Tip: Clean up everything (use with caution!) [00:04:57]
docker system prune -a

Note: Always ensure your docker-compose.yml file is in your current working directory before running these commands.

Video Link: https://www.youtube.com/watch?v=HG6yIjZapSA

Day 8: Docker Compose Introduction and System trouble shooting
What I Learned

    Multi-Container Orchestration: I learned that Docker Compose is a tool for defining and running multi-container applications. Instead of running multiple docker run commands manually, I can define the entire stack (Frontend, Backend, Database) in a single docker-compose.yml file.

    YAML Configuration: I learned how to use YAML syntax, which relies on strict indentation rather than brackets. Key sections include version, services (the containers), networks, and volumes.

    Service Networking: Docker Compose automatically creates a default network. Containers can communicate with each other using the service name (e.g., db or api) as the hostname, which simplifies connection strings.

    Persistence with Volumes: I learned that to prevent data loss when a database container is removed, I must define a volume in the Compose file to map the container's data directory to a location on the host or a managed Docker volume.

    System Recovery: I learned how to unstick apt by removing broken kernel modules (virtualbox-dkms) that were blocking the Docker installation.

    Docker Repository Setup: I successfully added the official Docker GPG keys and repository for Ubuntu 24.04 (Noble).

    Post-Installation Steps: I learned that adding my user to the docker group is essential to avoid using sudo for every command.

    Data Persistence: I practiced backing up data from a Docker Volume using the --volumes-from flag.

Commands Practice
Bash

# Verify Docker Compose is installed
docker compose version

# Start the entire application stack in detached mode
docker compose up -d

# Check the status of containers defined in the YAML file
docker compose ps

# View real-time logs for the services
docker compose logs -f

# Stop and remove all containers and networks defined in the file
docker compose down

# Force a rebuild of the images without using cache
docker compose build --no-cache

# Fix broken packages
sudo apt --fix-broken install

# Install modern Docker Compose V2
sudo apt install docker-compose-plugin

# Run backup script
./backup.sh

1. Check the Connection Logs

To see if your backend successfully reached the MongoDB container, run:
Bash

docker compose logs -f api

What to look for:

    Success: You should see something like Connected to MongoDB or Server running on port 3001.

    Failure: If you see Connection refused, it usually means the database wasn't ready yet or the environment variable in your YAML is wrong.

2. Check All Services at Once

If you want to see how the whole family is doing, just leave out the service name:
Bash

docker compose logs -f

Note: The -f stands for "follow," meaning it will stream new logs as they happen.
3. Inspect the Internal Network

Since we talked about Docker's internal DNS today, you can actually see the network Docker Compose created for you:
Bash

docker network ls
docker network inspect three-tier-app-configuration_default

This will show you the internal IP addresses assigned to your web, api, and db containers

Containers Created

    fiddly-frontend - A React-based web interface for users to interact with the movie list.

    fiddly-backend - A Node.js API that handles the business logic and connects to the database.

    fiddly-db - A MongoDB instance used to store and persist movie data.

Dockerfile Written

(Example for the Backend service used in Compose)
Dockerfile

FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3001
CMD ["npm", "start"]

Challenges

    Problem: The backend container couldn't connect to the database, giving a "Connection Refused" error.

    Solution: I realized I was using localhost in the connection string. I changed the environment variable DB_URL to use the service name db (e.g., mongodb://db:27017/vidly), allowing Docker’s internal DNS to resolve the IP correctly.

    Problem: The docker compose command was unrecognized because the V2 plugin wasn't installed, and VirtualBox was locking the kernel.

    Solution: Purged VirtualBox, updated the kernel, and installed the docker-compose-plugin from the official Docker repo.

Resources

    Video Tutorial: Docker Compose Tutorial by Mosh

    Documentation: Docker Compose Specification

Tomorrow's Plan

    Docker Compose Volumes: Deep dive into named vs. anonymous volumes.

    Environment Variables: Managing secrets and configurations using .env files in Compose.