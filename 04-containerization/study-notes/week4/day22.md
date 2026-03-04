# 📘 My Docker Multi-Stage Builds Study Notes

## 📅 Understanding the Problem & Basic Solution

### 🤔 What I Learned Today

So I kept hearing about "huge Docker images" and finally understand why! When I build a Python app normally, my image ends up with all the build tools, pip cache, and temporary files I don't need to RUN the app. It's like buying a whole bakery just to eat one cookie!

The Problem with Regular Docker builds:
text

My Python app (10MB code) + Python SDK + pip + build tools + cache = 1GB image! 😱

💡 The Magic: Multi-Stage Builds

Multi-stage builds let me use multiple FROM statements in one Dockerfile. Each FROM is a new "stage" and I can copy ONLY what I need from earlier stages.

My First Multi-Stage Dockerfile (for a Go app):
dockerfile

## Stage 1: The Construction Zone 🏗️

FROM golang:1.25 AS builder
WORKDIR /src
COPY main.go .
RUN go build -o /bin/myapp main.go

## Stage 2: The Final Product 🎁

FROM scratch  # Tiny empty image!
COPY --from=builder /bin/myapp /bin/myapp
CMD ["/bin/myapp"]

What's happening here?

    Stage 1 uses BIG golang image (has compiler, tools)

    Stage 2 uses TINY scratch image (literally nothing!)

    COPY --from=builder reaches back to Stage 1 and grabs JUST my compiled app

    Final image = ONLY my app (maybe 10MB instead of 800MB!)

## 🎯 Why This is Awesome

Before | After
800MB image | 15MB image
Contains compilers, SDKs | Only runtime binaries
Security risks (extra tools) | Smaller attack surface
Slow to push/pull | Fast deployments

## 📅 Leveling Up with Advanced Techniques

### 🏷️ Naming My Stages (So Much Cleaner!)

Instead of using numbers (--from=0), I can name stages. This is way better because:

    Easier to read

    Won't break if I reorder stages later

dockerfile

## BEFORE: Confusing numbers

FROM python:3.9 AS builder
RUN pip install flask
FROM python:3.9-slim
COPY --from=0 /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

## AFTER: Clear names!

FROM python:3.9 AS dependency-installer
RUN pip install flask

FROM python:3.9-slim AS runtime
COPY --from=dependency-installer /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

### 🎯 Stopping at Specific Stages (Debug Mode!)

This is a GAME CHANGER for debugging. I can build just the stage I want:
bash

# Build everything (normal)
docker build -t myapp:latest .

# Stop after 'builder' stage (great for testing if compilation works!)
docker build --target builder -t myapp:debug .

# Stop at 'test' stage (run tests without building final image)
docker build --target test -t myapp:testing .

Real example from my notes:
dockerfile

FROM node:18 AS dependencies
WORKDIR /app
COPY package*.json ./
RUN npm install

FROM dependencies AS tester
COPY . .
RUN npm test  # I can stop here to run tests

FROM dependencies AS production
COPY --from=tester /app/dist /app/dist
CMD ["node", "dist/index.js"]

## 📦 Copying from External Images (Mind = Blown!)

I can copy files from ANY image on Docker Hub, not just my own stages:
dockerfile

# Copy nginx config from official nginx image
COPY --from=nginx:latest /etc/nginx/nginx.conf ./nginx.conf

# Copy SSL certificates from a certbot image
COPY --from=certbot/certbot:latest /etc/letsencrypt ./ssl

⚡ BuildKit vs Old Builder (Speed Comparison)

The Old Way (Legacy Builder):
bash

DOCKER_BUILDKIT=0 docker build .
# Builds EVERY stage even if not needed = slow 😴

The New Way (BuildKit - Default now):
bash

# No need to set anything, it's default!
docker build .
# Only builds stages I actually need = fast 🚀

Example: If I have stage1, stage2, stage3 but my target only needs stage1 and stage3:

    Legacy: builds stage1, stage2, stage3

    BuildKit: builds stage1, stage3 (skips stage2!)

## 📅 Hands-On Practice - Building Microservices

## 🏗️ Project: User & Order Microservices

Today I'm building TWO microservices with proper multi-stage Dockerfiles!
Service 1: Python User Service

My user-service/app.py:
python

from flask import Flask, jsonify
app = Flask(__name__)

@app.route('/users')
def users():
    return jsonify([
        {"id": 1, "name": "Alice"}, 
        {"id": 2, "name": "Bob"}
    ])

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

My user-service/requirements.txt:
text

Flask==2.3.2

My user-service/Dockerfile (I'm proud of this!):
dockerfile

# STAGE 1: Install dependencies
FROM python:3.9-slim AS dependency-builder
WORKDIR /app

# Copy only requirements first (leverages Docker cache)
COPY requirements.txt .
RUN pip install --user -r requirements.txt

# STAGE 2: Build final image
FROM python:3.9-slim
WORKDIR /app

# Copy Python packages from builder
COPY --from=dependency-builder /root/.local /root/.local

# Copy my code
COPY app.py .

# Make sure scripts in .local are usable
ENV PATH=/root/.local/bin:$PATH

# Run the app
CMD ["python", "app.py"]

Service 2: Node.js Order Service

My order-service/index.js:
javascript

const express = require('express')
const app = express()
const port = 3000

app.get('/orders', (req, res) => {
  res.json([
    {"id": 101, "item": "Laptop", "userId": 1},
    {"id": 102, "item": "Mouse", "userId": 2}
  ])
})

app.listen(port, () => {
  console.log(`Order service running on port ${port}`)
})

My order-service/package.json:
json

{
  "name": "order-service",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.2"
  }
}

My order-service/Dockerfile:
dockerfile

# STAGE 1: Install dependencies
FROM node:18-alpine AS dependency-builder
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies (clean install for consistency)
RUN npm ci --only=production

# STAGE 2: Runtime
FROM node:18-alpine
WORKDIR /app

# Copy node_modules from builder
COPY --from=dependency-builder /app/node_modules ./node_modules

# Copy app code
COPY index.js .

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001
USER nodejs

CMD ["node", "index.js"]

## 📅 Docker Compose & Putting It All Together

## 🎼 Docker Compose - My Orchestra Conductor

My docker-compose.yml:
yaml

version: '3.8'

services:
  # User API Service
  user-api:
    build:
      context: ./user-service
      dockerfile: Dockerfile
    ports:
      - "5000:5000"
    container_name: user-microservice
    networks:
      - microservices-net

  # Order API Service  
  order-api:
    build:
      context: ./order-service
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    container_name: order-microservice
    depends_on:
      - user-api
    networks:
      - microservices-net

networks:
  microservices-net:
    driver: bridge

## 🚀 Running Everything

bash

# Build and start all services
docker-compose up --build

# Check if they're running
docker-compose ps

# See logs
docker-compose logs -f

# Test the endpoints!
curl http://localhost:5000/users
curl http://localhost:3000/orders

# Stop everything
docker-compose down

## 📊 Image Size Comparison (The Proof!)

bash

# Check how small my images are!
docker images | grep microservice

# Without multi-stage: ~900MB per service
# With multi-stage:
# user-microservice    ~130MB  (Python runtime only!)
# order-microservice   ~120MB  (Node alpine + deps only!)

## 🎓 My Key Takeaways

## ✅ What I'll Always Remember

    ALWAYS use multi-stage for production images - No excuses!

    Name your stages - Future me will thank present me

    Use --target for debugging - Saves so much time

    Copy only what you need - Like a minimalist moving house

    BuildKit is my friend - It's smart about what it builds

## 📝 My Cheat Sheet

dockerfile

# Basic template I'll reuse
FROM something AS builder
# Build stuff here

FROM something-small AS final
COPY --from=builder /built-stuff /place-to-put-it
CMD ["run", "my-app"]

## 🔥 Pro Tips I Discovered

    Order matters: Put things that change less often (like dependency installation) EARLIER in the Dockerfile to leverage cache

    Use .dockerignore: Don't copy node_modules or __pycache__ into the builder!

    Security: Always create and use a non-root user in final stage

## 🎯 Next Things to Try

    Add a database service (PostgreSQL) to my compose setup

    Make order-service actually CALL user-service

    Add environment variables for configuration

    Try with different languages (Rust, Java, Go)

    Set up CI/CD pipeline using these multi-stage builds

## Study Session Complete! 🎉

These notes are my goto reference now. The key insight that clicked for me: "Build in a kitchen, serve on a plate" - use a full-featured image to cook/prepare, then transfer just the final dish to a clean plate for serving!

Time to celebrate with a coffee ☕ while my tiny, efficient images deploy in seconds!

## Your Challenge: Create the Dockerfiles:

    For user-service/Dockerfile (Python/Flask):

        Stage 1 (Builder): Use python:3.9-slim as the base. Set a working directory. Copy requirements.txt and install dependencies into a local folder (e.g., /install).

        Stage 2 (Final): Use python:3.9-slim again (a smaller runtime base). Copy the installed dependencies from the builder stage. Copy your app.py. Set the command to run the app with Python.

    For order-service/Dockerfile (Node.js/Express):

        Stage 1 (Builder): Use node:18-alpine as the base. Set a working directory. Copy package.json and run npm install.

        Stage 2 (Final): Use node:18-alpine again. Copy the node_modules folder from the builder stage. Copy your index.js. Set the command to run node index.js.

Bringing It All Together with Docker Compose:

    Create a docker-compose.yml file in the root microservices-practice folder.

    Define two services: user-api and order-api.

    For each service, specify the build context (path to the folder containing its Dockerfile).

    Map the container ports (5000, 3000) to available ports on your host machine (e.g., "5000:5000").

    Run docker-compose up --build to build and run both microservices. Test them by visiting http://localhost:5000/users and http://localhost:3000/orders in your browser.


## Note i jotte down while watching the video and reading the docs.

🗒️ My Study Notes: Docker Multi-Stage Builds

Goal: Build "Heavy," Ship "Light."

1. The "Aha!" Moment

    Problem: Usually, my Docker image has compilers, source code, and build tools (like maven, npm, gcc). This makes the image huge (1GB+) and insecure.

    Solution: Use Multi-Stage Builds. I can use one "stage" to compile my code and a second "stage" to just run the final app. I only "ship" the second stage.

    Key Command: COPY --from=<stage_name> is the magic that moves files from the "Builder" to the "Runner."

2. How the Dockerfile looks (Professional Pattern)
Dockerfile

# STAGE 1: The "Construction Site" (Builder)
# Use a full image with all the tools needed to compile
FROM node:20 AS builder  
WORKDIR /app
COPY . . 
RUN npm install && npm run build 

# STAGE 2: The "Finished House" (Runner)
# Use a tiny, secure image (Alpine or Distroless)
FROM node:20-alpine AS runner
WORKDIR /app
# I ONLY copy the 'dist' folder from the 'builder' stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json .

# This image won't have the source code or 'npm install' tools!
CMD ["node", "dist/main.js"]

3. Professional Tips to Remember

    Naming is King: Always use AS <name> (e.g., AS builder). It makes the code readable. If I don't name it, I have to use numbers like --from=0, which is confusing.

    The "Target" Trick: I can stop the build early.

        docker build --target builder -t my-app:dev .

        Why? Great for debugging or running tests in CI/CD before the final image is made.

    External Images: I can copy files from anywhere, even other images on Docker Hub!

        Example: COPY --from=nginx:latest /etc/nginx/nginx.conf .

4. Real-World DevOps Checklist

When dockerizing microservices, I must check:

    [ ] Size: Is the final image significantly smaller than the builder? (Goal: 50MB–200MB instead of 1GB).

    [ ] Security: Does the final image contain git or ssh keys? (It shouldn't!).

    [ ] User: Am I running as root? (Professional DevOps always use USER node or a non-root user).

5. Summary Table for Quick Review

Feature | Single Stage | Multi-Stage
Image Size | Massive (includes all tools) | Tiny (only production files)
Security | Low (attackers have more tools) | High (minimal footprint)
Build Speed | Standard | Faster (Parallelized by BuildKit)
Readability | Messy (lots of cleanup rm -rf) | Clean (separate logical steps)
