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

🛠️ Task 2: Resource Limits (Preventing Crashes)

If your backend has a memory leak or is attacked by a bot, it could consume all the RAM on your server, crashing Nginx and your Database. We set "Limits" to keep it in a "box."

Update the backend and db sections in your docker-compose.yml:
YAML

  backend:
    # ... your existing config ...
    deploy:
      resources:
        limits:
          cpus: '0.50'     # Use max 50% of 1 CPU core
          memory: 256M    # Max 256MB RAM
        reservations:
          memory: 128M    # Guaranteed minimum 128MB RAM

  db:
    # ... your existing config ...
    deploy:
      resources:
        limits:
          memory: 512M    # Databases need a bit more room than APIs

Test : The Resource Test
Check if Docker is actually enforcing the limits:
Bash

docker stats --no-stream

    Expected Result: You should see the MEM LIMIT column showing 256MiB for the backend and 512MiB for the DB.

🛡️ Task 3: Read-Only Filesystem (Immortal Mode)

A major security goal is making your container "Immutable." If a hacker manages to break in as appuser, a Read-Only filesystem prevents them from creating new scripts or modifying your code.

Update your frontend and backend in docker-compose.yml:
For the Backend:
YAML

  backend:
    # ... 
    read_only: true

For the Frontend (Nginx):

Nginx is tricky because it needs to write temp files and logs. To make it read-only, we give it a "scratchpad" in memory using tmpfs.
YAML

  frontend:
    # ...
    read_only: true
    tmpfs:
      - /var/cache/nginx
      - /var/run

🚀 The "Verification" Test

After updating your docker-compose.yml, run:
Bash

make nuclear

How to verify Task 3 (Read-Only):
Try to create a file inside your running backend. It should fail!
Bash

docker compose exec backend touch test.txt

If it says "touch: test.txt: Read-only file system", you have achieved Day 15 mastery!

🧠 DevOps Mindset Check

When you finish Day 15, you should be able to answer: "If a hacker finds a bug in my code, what is the smallest amount of damage they can do?" By using Non-root users, Resource limits, and Nginx Proxies, you have made that "damage" almost zero. Ready to start hardening your DevOps Lab?

🏆 Day 15 Summary for your Portfolio

You can now add these points to your project README:

    Immutable Infrastructure: Implemented read_only filesystems to prevent runtime tampering.

    Resource Quotas: Applied CPU and RAM limits to ensure service availability and prevent DoS.

    Service Isolation: Leveraged tmpfs for minimal writable surface area in the Nginx frontend.