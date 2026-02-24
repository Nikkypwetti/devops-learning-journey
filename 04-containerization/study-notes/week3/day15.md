For Day 15, we shift from building functionality to hardening your infrastructure. In the real world, a DevOps Engineer’s job isn't just to make things run, but to ensure they don't get hacked.

Here is your detailed guide for Day 15: Container Security Fundamentals.
1. 📺 Video Insight (18 mins)

Topic: Docker Security Best Practices
The video emphasizes the "Defense in Depth" strategy. Key takeaways include:

    The Daemon Danger: The Docker daemon (dockerd) usually runs as root. Anyone with access to the Docker socket can essentially take over your entire host machine.

    Image Provenance: Never pull random images from Docker Hub. Use Official Images or verified publishers.

    Layer Minimization: Each layer in your Dockerfile is a potential attack surface. Keep images "slim" (using Alpine or Distroless) to reduce the tools an attacker can use if they get inside.

2. 📖 Core Concepts: Docker Security Docs

The Official Docker Security Documentation highlights four major areas of security:
A. Kernel Namespaces

This is the primary wall between containers. It ensures that a process in Container A cannot see or affect processes in Container B or the Host.
B. Control Groups (cgroups)

This protects against Denial of Service (DoS) attacks. It prevents a single container from consuming all the RAM or CPU on your host, which would crash your other services.
C. Docker Daemon Attack Surface

Since the daemon runs as root, you must protect the Docker Socket (/var/run/docker.sock).

    Never mount the docker socket inside a public-facing container unless absolutely necessary.

D. Linux Kernel Capabilities

By default, Docker drops most "root" powers. For example, a container "root" user cannot usually restart the physical host machine or modify the host's network hardware.
3. 🛠️ Practice: Non-Root User Management

The most common security mistake is running your application as the root user inside the container. If a hacker exploits your Node.js app, they start with root privileges.
The "Standard" Secure Dockerfile Pattern

Apply this to your project's backend/Dockerfile or frontend/Dockerfile:
Dockerfile

# 1. Use a specific, slim version
FROM node:18-alpine

# 2. Set the working directory
WORKDIR /app

# 3. Create a system group and user (DevOps Best Practice)
# -S creates a system user, -G adds them to a group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# 4. Copy files and CHANGE OWNERSHIP immediately
# This ensures the non-root user can actually read the files
COPY --chown=appuser:appgroup . .

# 5. Install dependencies as the user
RUN npm install --only=production

# 6. Switch to the non-root user
# All commands after this line run as 'appuser'
USER appuser

EXPOSE 5000

CMD ["node", "index.js"]

🚀 Your Day 15 Lab Tasks

Task 1: The "WhoAmI" Test
Run your current container and check the user:
Bash

docker compose exec backend whoami

If it says root, your container is insecure. If it says appuser (or the name you chose), you passed!

Task 2: Limit Resources
Update your docker-compose.yml to prevent a container from "stealing" all your computer's power:
YAML

services:
  backend:
    image: ...
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M

Task 3: Read-Only Filesystem
In production, your code shouldn't change while running. Try making your container filesystem "Read-Only" in your docker-compose.yml:
YAML

  frontend:
    image: ...
    read_only: true
    volumes:
      - /tmp  # Nginx needs a place to write temp files

🧠 DevOps Mindset Check

When you finish Day 15, you should be able to answer: "If a hacker finds a bug in my code, what is the smallest amount of damage they can do?" By using Non-root users, Resource limits, and Nginx Proxies, you have made that "damage" almost zero. Ready to start hardening your DevOps Lab?