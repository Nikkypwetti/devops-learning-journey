Day 20: Docker Production Best Practices 🚀

Yesterday, you saw the "heartbeat" of your application through cAdvisor. Today, we solidify everything you’ve learned by applying Production-Grade configurations. In a professional DevOps environment, a "working" container isn't enough—it must be resilient, restricted, and traceable.
1. Health Checks: The "Self-Healing" Mechanism

By default, Docker only checks if the process inside the container is running. If your Backend process is alive but the database connection has timed out and it’s returning "500 Errors," Docker will still think it's "Up."

The Pro Approach: Use the HEALTHCHECK instruction to verify the application's actual functionality.

    For your Backend: Check if the API endpoint responds.

    For your Database: Use the internal tool pg_isready.

Why it matters: This allows Docker to automatically restart a "zombie" container that is running but not serving requests.
2. Resource Limits: The "Anti-Crash" Guardrail

In production, one "leaky" container can steal all the RAM from your host, causing the entire server (and all other containers) to crash.

    Limits: The absolute maximum a container can take. If it hits the memory limit, it gets OOMKilled (Out of Memory Killed).

    Reservations: The guaranteed minimum the container gets.

DevOps Rule of Thumb: * DB: High Memory, Low CPU.

    Backend: Medium Memory, Medium CPU.

    Frontend (Nginx): Very Low Memory, Very Low CPU.

3. Logging: The "Black Box" Recorder

When a container crashes in production, it's gone. If you haven't configured logging correctly, the reason for the crash disappears with it.

    Standard Streams: Ensure your apps log to STDOUT and STDERR.

    Log Rotation: In production, you must limit log sizes so they don't fill up your server's hard drive.

4. Practical Implementation: The "Perfect" Production Compose

Let’s apply these three pillars to your project. Update your docker-compose.yml with these production settings:
YAML

services:
  db:
    image: postgres:15-alpine
    deploy:
      resources:
        limits:
          memory: 512M
    # Healthcheck ensures the DB is actually accepting connections
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER} -d ${DB_NAME}"]
      interval: 10s
      timeout: 5s
      retries: 5

  backend:
    image: ${DOCKERHUB_USERNAME}/fullstack-backend:latest
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: 256M
    # Logging best practice: prevent logs from eating disk space
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:5000/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  frontend:
    image: ${DOCKERHUB_USERNAME}/fullstack-frontend:latest
    read_only: true
    deploy:
      resources:
        limits:
          memory: 64M # Optimized Nginx needs very little

Day 20 Practice Tasks

    Verify the Health Status:
    Run docker ps. You should see (healthy) next to your container status. If it says (unhealthy), your test command in the Compose file is likely wrong.

    Inspect Resource Enforcement:
    While your stress test (from yesterday) is running, run:
    Bash

    docker inspect fullstack-app-backend-1 | grep -i "Memory"

    This confirms that the Linux Kernel is actually enforcing the 256MB limit you set.

    Check Log Rotation:
    Navigate to /var/lib/docker/containers/<container_id>/ (requires sudo) to see the json-file logs. Note how they are capped at 10MB.

Summary of Day 20
Feature | Professional Goal | Your Status
Health Checks | Self-healing apps. | Implemented
Resource Limits | Prevent Host crashes. | Implemented
Log Rotation | Prevent Disk exhaustion. | Implemented
Non-Root User | Security (Least Privilege) | Implemented