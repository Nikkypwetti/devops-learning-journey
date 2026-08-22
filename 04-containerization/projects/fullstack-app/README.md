# Multi-Tier Containerized Full-Stack Application

A hands-on DevOps project demonstrating how a React frontend, Node.js/Express API and PostgreSQL database can be containerized and operated as a multi-service application using Docker Compose.

The project focuses on container networking, service health, persistent data, image automation, security controls and CI/CD.

## Architecture

```text
Browser
  ↓
React + Nginx
  ↓
Node.js / Express API
  ↓
PostgreSQL
```

The application is separated into frontend, backend and database layers.

- The frontend is exposed to the host through Nginx.
- The backend communicates with both the frontend and database networks.
- PostgreSQL is placed on an internal backend network.
- Database data is persisted using a Docker volume.
- cAdvisor provides container monitoring.

## Technology Stack

| Area | Technology |
| --- | --- |
| Frontend | React, Nginx |
| Backend | Node.js, Express |
| Database | PostgreSQL 15 |
| Containers | Docker, Docker Compose |
| Networking | Docker bridge networks |
| CI/CD | GitHub Actions |
| Registry | Docker Hub |
| Security Scanning | Trivy |
| Monitoring | cAdvisor |

## Container Architecture

The Docker Compose configuration runs four services:

```text
frontend
backend
db
cadvisor
```

### Frontend

The React frontend is served through Nginx and exposed locally at:

```text
http://localhost:3000
```

The container listens on port `8080`:

```yaml
ports:
  - "3000:8080"
```

The frontend filesystem is configured as read-only, with temporary writable directories provided using `tmpfs`.

### Backend

The Node.js/Express backend:

- Connects to the frontend and backend networks
- Uses a read-only filesystem
- Uses `/tmp` as temporary writable storage
- Waits for the database health check before starting
- Includes a `/health` container health check
- Uses Docker logging limits to control log growth

### Database

PostgreSQL:

- Runs using `postgres:15-alpine`
- Stores data in a persistent Docker volume
- Uses `pg_isready` for health checks
- Runs on the internal backend network
- Reads its password from a Docker Compose secret

## Network Isolation

Two Docker networks separate application traffic:

```text
frontend-network
backend-network
```

The backend network is configured as internal:

```yaml
backend-network:
  internal: true
```

This keeps the database layer away from direct host exposure while allowing the backend service to communicate with it.

## Health Checks

PostgreSQL uses:

```text
pg_isready
```

The backend uses:

```text
http://localhost:5000/health
```

Docker Compose waits for PostgreSQL to report healthy before starting the backend.

## Persistent Storage

PostgreSQL data is stored in the named volume:

```text
postgres_data
```

This allows database data to survive container recreation.

## Container Security

The project includes several container-focused controls:

- Internal database networking
- Read-only frontend and backend filesystems
- Temporary writable directories with `tmpfs`
- Docker Compose secrets for the PostgreSQL password
- Resource limits
- Container health checks
- Trivy image scanning in CI/CD

## Monitoring

The Compose stack includes cAdvisor for container-level monitoring.

After starting the stack, cAdvisor is available at:

```text
http://localhost:8080
```

## CI/CD Pipeline

The GitHub Actions workflow builds the backend and frontend container images and pushes them to Docker Hub.

The pipeline:

1. Checks out the repository
2. Authenticates with Docker Hub
3. Configures Docker Buildx
4. Generates a short Git commit SHA
5. Builds and pushes the backend image
6. Runs a Trivy critical-vulnerability scan
7. Builds and pushes the frontend image
8. Runs a Trivy critical-vulnerability scan
9. Tags images with both `latest` and the short Git SHA

Example tags:

```text
fullstack-backend:latest
fullstack-backend:a1b2c3d

fullstack-frontend:latest
fullstack-frontend:a1b2c3d
```

## Local Setup

Create the local environment file:

```bash
cp .env.example .env
```

Configure the required values:

```text
DB_USER=
DB_PASSWORD=
DB_NAME=
PORT=5000
NODE_ENV=
DOCKERHUB_USERNAME=
```

Create the local database-password file used by Docker Compose:

```bash
printf '%s\n' 'your-local-password' > db_password.txt
```

Do not commit `.env` or `db_password.txt`.

Start the stack:

```bash
docker compose up -d
```

Check the containers:

```bash
docker compose ps
```

Open the application:

```text
http://localhost:3000
```

Stop the stack:

```bash
docker compose down
```

## Engineering Skills Demonstrated

This project provides hands-on evidence of:

- Multi-container application architecture
- Docker Compose orchestration
- Container networking
- Nginx reverse proxy configuration
- Persistent database storage
- Health-check dependency management
- Read-only container filesystems
- Docker Compose secrets
- CI/CD with GitHub Actions
- Docker image versioning
- Container vulnerability scanning
- Basic container monitoring
- Troubleshooting across frontend, API and database layers

## Repository Context

This project is part of my broader Cloud, DevOps and Infrastructure Engineering portfolio.

[Back to the main DevOps portfolio](../../../README.md)