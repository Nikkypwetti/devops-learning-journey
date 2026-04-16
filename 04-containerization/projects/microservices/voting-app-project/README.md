# 🗳️ Real-Time Microservices Voting System (Docker Swarm)

## 📌 Project Overview

A distributed, high-availability voting application designed to demonstrate a complete Modern DevOps Lifecycle. This project transitions a legacy monolithic concept into a 5-tier microservices architecture orchestrated via Docker Swarm, featuring real-time data propagation and hardened security protocols.

## 🏗️ System Architecture

The application is split into five functional components:

    Vote UI (Next.js/Python): The frontend gateway where users cast votes.

    Message Broker (Redis): Handles high-concurrency ingestion to decouple the frontend from database writes.

    Worker Service (.NET Core): A background consumer that processes votes from Redis and persists them to the DB.

    Database (PostgreSQL): Persistent storage for vote tallies, secured via Swarm Secrets.

    Result UI (React/Node.js): A real-time dashboard that broadcasts live results via WebSockets.

## 🛠️ Key DevOps Challenges & Solutions

1. Real-Time Result Propagation (WebSocket Proxying)

Challenge: Standard Nginx configurations drop WebSocket connections, preventing the Result UI from updating without a manual refresh.
Solution: Implemented a custom Nginx map block and "Upgrade" headers to facilitate the WebSocket (Socket.io) Handshake, enabling sub-second result updates.
2. Zero-Trust Secret Management

Challenge: Hardcoded database credentials in environment variables pose a significant security risk.
Solution: Integrated Docker Swarm Secrets. Credentials are encrypted at rest and injected into containers at /run/secrets/db_password, ensuring only authorized services can access the database.
3. Database Persistence & Auth Alignment

Challenge: Password authentication failures occurred when existing volumes didn't match updated Swarm secrets.
Solution: Implemented a volume-cleanse and re-initialization workflow to ensure the PostgreSQL PGDATA correctly aligned with the db_password secret during the first-boot handshake.

## 🚀 CI/CD Pipeline (GitHub Actions)

The project features a robust automation pipeline located in .github/workflows/microservices.yml:

    Multi-Service Matrix: Simultaneously builds vote, worker, and result (voting-frontend) services.

    Security Scanning: Every build includes a Trivy scan. If a CRITICAL vulnerability is found, the pipeline fails before reaching production.

    Automated Tagging: Images are tagged with both :latest and the unique GITHUB_SHA for precise version control and rollbacks.

## 💻 Installation & Deployment

Prerequisites

    Docker Desktop or Docker Engine (Linux/Ubuntu)

    Docker Swarm initialized: docker swarm init

Step 1: Clone the Repository
Bash

git clone https://github.com/Nikkypwetti/devops-learning-journey.git
cd 04-containerization/projects/microservices/voting-app-project

Step 2: Create Docker Secrets
Bash

echo "your_secure_password" | docker secret create db_password -

Step 3: Deploy the Stack
Bash

docker stack deploy -c docker-compose.yml voting_stack

Step 4: Access the Services

    Voting UI: http://localhost:5000 (or http://localhost/ via Nginx)

    Results Dashboard: http://localhost:5001 (Real-time enabled)

## 🧪 Troubleshooting & Verification

Check Service Health:
Bash

docker stack services voting_stack

Verify Data Pipeline (SQL):
Bash

DB_ID=$(docker ps -q -f name=voting_stack_db)
docker exec -it $DB_ID psql -U postgres -c "SELECT vote, count(*) FROM votes GROUP BY vote;"

View Live Worker Logs:
Bash

docker service logs voting_stack_worker -f

## 👨‍💻 Tech Stack

    Orchestration: Docker Swarm

    CI/CD: GitHub Actions, Trivy

    Languages: Python, C# (.NET Core), JavaScript (Node.js/Next.js)

    Middleware: Nginx, Redis

    Database: PostgreSQL

## 🏗️ Technical Architecture

This project implements a Distributed Microservices Architecture designed for high availability and real-time data processing. The system is orchestrated using Docker Swarm and integrated via a custom Nginx Reverse Proxy.

### 📡 The Data Pipeline

    Traffic Entry: A Next.js (Voting) and React (Results) frontend serve as the user interface. All traffic is routed through Nginx, which is configured to handle standard HTTP requests and specialized WebSocket (WS) handshakes for real-time updates.

    Ingestion: Votes are sent to a Python/Flask API, which acts as a lightweight producer, pushing vote data into a Redis message broker to decouple the frontend from database write speeds.

    Processing: A .NET/C# Worker service acts as the consumer, constantly monitoring Redis for new entries. Once a vote is pulled, the worker processes and persists it into a PostgreSQL database.

    Broadcast: The Node.js Result Service monitors the PostgreSQL state and uses Socket.io to broadcast live totals to all connected clients instantly.

## 🛠️ DevOps Implementation & Challenges

### 🔐 Advanced Secret Management

To follow production security standards, I implemented Docker Swarm Secrets. Database credentials are never hardcoded in environment variables. Instead, they are injected at runtime into the /run/secrets/ directory of the Worker and Database containers, ensuring a zero-trust configuration.

### 🔄 Real-Time Scaling & Handshaking

A major challenge was the Nginx WebSocket Upgrade. Standard proxy configurations drop WebSocket connections. I implemented a custom map block and "Upgrade/Connection" headers in the Nginx configuration to ensure stable, long-lived connections between the Result UI and the backend.

### 🏗️ Infrastructure as Code (IaC)

The entire stack is defined in a modular docker-compose.yml file, supporting:

    Dual Networks: frontend and backend networks to isolate database traffic from public-facing services.

    Persistent Volumes: Ensuring vote data survives container restarts or service updates.

    Health Checks: Configured to ensure services only receive traffic once they are fully initialized.

## 🚀 CI/CD Pipeline

The project utilizes GitHub Actions for a fully automated CI/CD lifecycle:

    Matrix Builds: Optimized builds for multiple services (Python, .NET, Node.js) simultaneously.

    Security Auditing: Integrated Trivy to scan every Docker image for CRITICAL vulnerabilities before pushing to Docker Hub.

    Automated Tagging: Implemented semantic versioning using Git SHAs for precise rollback capabilities.