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

    Build Context Errors: I learned that the build: path in docker-compose.yml must exactly match the directory structure on my disk.

    Task Scheduling: I learned how to use crontab to schedule recurring DevOps tasks like database backups.

    The Power of chmod: I practiced making scripts executable so they can be run by the system scheduler.

    Build Context: I learned that build: ./backend requires an actual directory named backend containing a Dockerfile.

    Infrastructure Scaffolding: I learned how to "scaffold" a project by creating the necessary directory structure before running orchestration tools.

    Placeholder Strategy: Using light images like nginx:alpine is a great way to test if your Compose networking and volumes are working before writing the actual application code.

    The Compose Lifecycle: I moved from "Unknown Command" and "Broken Kernel" to a fully running 3-tier application stack.

    Orchestration Success: I successfully created a custom Network and Volume automatically using a YAML file.

    Debugging & Perseverance: I learned that DevOps is 50% configuration and 50% troubleshooting system-level issues like apt locks and broken dkms modules.

    Service Execution: I practiced using docker compose exec to run commands inside a container that is already running, which is vital for database management.

    Database Security: I learned that enabling MONGO_INITDB_ROOT_USERNAME prevents unauthorized access, requiring a db.auth() call or login flags.

    Volume Persistence: I verified that data stored in a named volume survives even when the containers are completely removed with docker compose down.

    Authentication & Security: I learned that enabling root security in MongoDB requires explicit authentication (db.auth) even after switching to a specific database.

    Volume Persistence: I successfully mapped a named volume to ensure my my_portfolio data survives container restarts.

    Authentication Scoping: I learned that root users created via Docker environment variables are stored in the admin database. To authenticate while using a different database, I must reference the admin database.

    Persistence Confirmed: I successfully proved that data survives a docker compose down and up cycle, confirming my volume configuration is correct.

    System Troubleshooting: I successfully navigated a total system recovery from a broken kernel and apt lock to a fully running 3-tier stack.

    Image Tagging: I learned that images must be tagged with my Docker Hub username before they can be pushed to a remote registry.

    Registry Push: I successfully moved my local images to the cloud (Docker Hub), making my project portable.

    System Maintenance: I practiced using docker system prune -a to manage disk space on my HP EliteBook without losing my persistent data.

    Node.js Containerization: I learned how to containerize a real Express/Mongoose app, moving away from Nginx placeholders.

    Environment Variable Injection: I practiced using process.env.DATABASE_URL in Node.js to connect to a database defined in Docker Compose.

    CI/CD Fundamentals: I created a GitHub Actions workflow to automate my image delivery to Docker Hub.

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

# Check directory structure
ls -F

# Edit the system scheduler
crontab -e

# Create directory structure
mkdir backend frontend

# Scaffold Dockerfiles
echo "FROM nginx:alpine" > backend/Dockerfile

# Enter a running container to run commands
docker compose exec db mongosh

# List databases inside the container
show dbs

# Login with credentials
docker compose exec db mongosh -u <user> -p <password>

# Create and query data
db.collection.insertOne({key: "value"})
db.collection.find()

# Database commands
use my_portfolio
db.projects.find().pretty()

# Login to a specific DB using admin credentials from the terminal
docker compose exec db mongosh -u <user> -p <password> --authenticationDatabase admin

# Authenticate inside the shell if already connected
db.getSiblingDB("admin").auth("user", "password")

# Verify record persistence after a restart
db.getSiblingDB("admin").auth("user", "password")
db.projects.find()

# Exit the shell safely
exit

# Tagging for the cloud
docker tag local-image:latest username/repo:v1

# Pushing to registry
docker push username/repo:v1

# Total system cleanup
docker system df      # Check space first
docker system prune -a # Reclaim space

#1. Check the Connection Logs

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

    Problem: docker compose failed because it couldn't find the backend folder.

    Solution: I am checking my folder naming conventions to ensure the YAML build context matches the actual project structure.

    Problem: docker compose failed with "path not found" error.

    Solution: Realized I was missing the service directories; created them with placeholder Dockerfiles to satisfy the build context requirements.

    Problem: show dbs failed with an Unauthorized error.

    Solution: Authenticated using the credentials defined in my environment variables.

    Problem: Authentication failed error after restarting the stack, even with the correct password.

    Solution: Identified that the user belongs to the admin database and used getSiblingDB to authenticate properly.

    Problem: Authentication failed because I was trying to log in directly to my_portfolio.

    Solution: Switched the authentication context to the admin database where the root user was initially created by Docker Compose.



Resources

    Video Tutorial: Docker Compose Tutorial by Mosh

    Documentation: Docker Compose Specification

Tomorrow's Plan

    Docker Compose Volumes: Deep dive into named vs. anonymous volumes.

    Environment Variables: Managing secrets and configurations using .env files in Compose.