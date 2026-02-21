📚 Daily Learning Note: Day 9
Topic: Docker Compose File Structure
1. 📺 Video Key Takeaways

Link: NetworkChuck - Docker Compose

    The "One Command" Power: Docker Compose is a tool for defining and running multi-container applications. It replaces long, manual docker run commands with a single yaml file.

    Indentation Matters: YAML is sensitive to spaces. Services, networks, and volumes must be perfectly aligned for the file to be valid.

    Lifecycle Management: Commands like up -d (start) and down (cleanup) manage the entire stack's life.

    Naming Convention: By default, Compose uses the directory name as a prefix for all containers and networks it creates.

2. 📖 Reading Highlights

Link: Docker Compose File Reference

    Services Block: Defines the configuration for each container (Image, Ports, Environment, Build).

    Networks Block: Defines how containers talk to each other. Using internal: true prevents outside access to sensitive containers like databases.

    Volumes Block: Defines persistent storage. Named volumes are preferred over bind mounts for database data.

    Depends_on: Controls the startup order. Using the condition: service_healthy flag is the pro way to wait for a DB to be ready.

3. 🛠️ Practice: Hands-on Implementation

Project Application: 3-Tier Portfolio App

To master Day 9, apply these changes to your project structure:

    Network Isolation: * Create a frontend-nw (Public) and a backend-nw (Private).

        Move the db into backend-nw only.

    Security (The .env file):

        Remove hardcoded passwords from docker-compose.yml.

        Reference them as ${DB_USER} and ${DB_PASSWORD}.

    File Organization:

        Create a backups/ folder.

        Save your Day 8 file as backups/docker-compose.v8.yml.

4. 📝 Personal Progress Check

    [ ] Can I explain why the database doesn't need ports: mapped to the host anymore?

    [ ] Does my docker compose ps show the database as (healthy)?

    [ ] Does my .env file successfully pass secrets to the containers?

Day 9: Compose File Structure
What I Learned

    Service Granularity: I learned that a Compose file is a collection of "Services" that represent individual containers. Each service can have its own specific build context, networking, and security settings.

    Network Isolation: By defining custom networks (frontend vs. backend), I can prevent the database from being exposed to the public internet while still allowing the backend to communicate with it.

    Persistence with Named Volumes: Using named volumes instead of just paths ensures that MongoDB data is managed by Docker and persists even if I run docker compose down.

    Environment Variable Integration: I learned how to use a .env file to store sensitive data like DB_PASSWORD, keeping the main docker-compose.yml clean and safe for GitHub.

Commands Practice
Bash

# 1. Back up the old version
mkdir -p backups && cp docker-compose.yml backups/docker-compose.v8.yml

# 2. Start the isolated stack
docker compose up -d --build

# 3. Check network connectivity
docker network inspect three-tier-app-configuration_backend-nw

# 4. Total cleanup (including volumes)
docker compose down -v

Containers Created

    three-tier-app-configuration-db-1 - Purpose: Persistent MongoDB storage, isolated from public access.

    three-tier-app-configuration-backend-1 - Purpose: Node.js API that acts as a bridge between the frontend and the database.

    three-tier-app-configuration-frontend-1 - Purpose: Nginx server serving the UI to the user on Port 80.

Dockerfile Written (Backend)
Dockerfile

FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3001
CMD ["node", "index.js"]

Challenges

    Problem: The depends_on syntax failed because of a dash formatting error (-db instead of db).

    Solution: Corrected the YAML indentation and removed the dash to properly reference the service name.

    Problem: The "Reset" button was incrementing the database to 1 instead of 0.

    Solution: Refactored the backend logic to separate the "status check" (GET) from the "visit log" (POST).

Resources

    Video Tutorial: NetworkChuck - Docker Compose

    Documentation: Docker Compose File Reference

Tomorrow's Plan

    Introduction to Kubernetes (K8s): Moving from Compose to Cluster orchestration.

    Minikube Setup: Getting a local K8s environment running on the EliteBook.

Day 9: Compose File Structure
What I Learned

    Network Segregation: I learned how to separate "public" traffic (Frontend) from "private" traffic (Database) using multiple user-defined networks in one file.

    Service Health Checks: I discovered how to use healthcheck to make the Backend wait until MongoDB is truly ready to accept connections, not just "started."

    Internal Networks: I used the internal: true flag to ensure my database has zero visibility to anything outside the Docker network.

    YAML Mapping: I practiced mapping environment variables from a .env file into the container runtime, allowing for dynamic configuration without changing the code.

Commands Practice
Bash

# 1. Back up the old version to see progress
mkdir -p backups && cp docker-compose.yml backups/docker-compose.v8.yml

# 2. Check if the .env variables are being picked up
docker compose config

# 3. Start the professional-grade stack
docker compose up -d --build

# 4. Confirm the DB is isolated (should show no ports)
docker compose ps

Containers Created

    three-tier-app-configuration-db-1 - Purpose: Secured MongoDB instance sitting on an internal-only backend network.

    three-tier-app-configuration-backend-1 - Purpose: The bridge API that connects to both networks to pass data safely.

    three-tier-app-configuration-frontend-1 - Purpose: The public-facing entry point serving the UI on Port 80.

Dockerfile Written (Frontend)
Dockerfile

FROM nginx:alpine
# Copy our custom HTML to the default Nginx location
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80

Challenges

    Problem: Encountered tls: bad record MAC during build due to network instability.

    Solution: Used docker builder prune -f and retried the build to ensure fresh, uncorrupted layers were pulled.

    Problem: The depends_on syntax error was causing the project to be "invalid."

    Solution: Reformatted the YAML to remove the illegal dash - prefix before the service name when using the condition attribute.

Resources

    Video Tutorial: NetworkChuck - Docker Compose

    Documentation: Docker Compose File Reference

Day 9: Compose File Structure (Consolidated)
What I Learned

    Microservices Architecture: I learned that a professional docker-compose.yml is a blueprint for an entire ecosystem. It allows for the orchestration of frontend, backend, and database services as a single unit.

    Network Isolation & "Zero-Trust": I implemented a dual-network strategy. By creating a private backend-nw and a public frontend-nw, I ensured that the database is completely hidden from the host and the internet, accessible only by the backend.

    Internal DNS & Service Discovery: I discovered that containers within a Compose network don't need IP addresses to talk; they use the Service Name (e.g., http://backend:3001) via Docker's internal DNS.

    Service Health Synchronization: I mastered the use of healthcheck paired with depends_on. This ensures the Backend waits until MongoDB is "Healthy" (responding to pings) before it attempts to connect, preventing startup crashes.

    Environment Variable Security: I practiced using a .env file to inject secrets (DB_USER, DB_PASSWORD) into the containers, keeping my main code safe for GitHub.

    CI/CD & Versioning: I learned how to link my local development to GitHub Actions, implementing a multi-tagging strategy (latest, v17, and Git-SHA) to track releases on Docker Hub.

    Maintenance & Pruning: I practiced analyzing disk usage with docker system df and learned the difference between Anonymous volumes (removable via prune) and Named volumes (protected by Docker).

Commands Practice
Bash

# --- Deployment & Syncing ---
# Pull the verified images from Docker Hub (nikkytechies account)
docker compose pull

# Start the stack and recreate containers with the newest images
docker compose up -d

# --- Verification & Security ---
# Test the 'Healthy' status and port mappings
docker compose ps

# Verify internal connectivity from the frontend container
docker compose exec frontend curl http://backend:3001/status

# Confirm network isolation (This SHOULD fail from the host)
curl localhost:3001/status

# --- Storage Cleanup ---
# Reclaim space from unused images and networks
docker system prune -a

# Specifically remove orphaned volumes to save disk space
docker volume prune

Containers Created

    three-tier-app-configuration-db-1 Purpose: Secured MongoDB storage.

    Network: backend-nw (Isolated).

    Volume: three-tier-app-configuration_mongo_data.

    three-tier-app-configuration-backend-1 Purpose: Node.js API logic.

    Network: Bridge (Connected to both backend-nw and frontend-nw).

    Version: nikkytechies/fiddly-backend:latest (Synced with v17).

    three-tier-app-configuration-frontend-1 Purpose: Nginx UI server.

    Network: frontend-nw.

    Ports: Exposed on 80:80 for public access.

Dockerfiles Used
Backend (/backend/Dockerfile)
Dockerfile

FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3001
CMD ["node", "index.js"]

Frontend (/frontend/Dockerfile)
Dockerfile

FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80

Challenges

    Naming Conventions: Encountered Access Denied and Manifest Unknown errors.

    Solution: Identified a typo in the username (nikky-techies vs nikkytechies) and the tag name (vlatest vs latest). Standardized the namespace across all files.

    Host Connectivity: curl failed when hitting Port 3001 from the laptop.

    Solution: Validated that this is a security feature of the "Zero-Trust" network design. Verified internal connectivity using docker compose exec.

    Space Management: The HP EliteBook showed 1.8GB of reclaimable volume space.

    Solution: Used docker volume prune to remove anonymous volumes while preserving named volumes for future projects.

    GitHub Action Tags: Docker Hub initially only showed the latest tag.

    Solution: Updated the main.yml workflow to include a list of tags: ${{ github.sha }} and v${{ github.run_number }}.

Resources

    Video Tutorial: NetworkChuck - Docker Compose tutorial

    Reading: Docker Compose Networking & Volumes Documentation

    Documentation: Docker Hub Repository Management