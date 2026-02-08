## 📘 Day 5: Dockerfile Fundamentals

# 🎯 Learning Objectives

    Understand Dockerfile structure and instructions

    Write basic Dockerfiles

    Build custom Docker images

    Practice with different base images

# 📚 Morning Resources (6:00-6:30 AM)

Video Tutorial (15 mins):

    Dockerfile Tutorial

    Key Takeaways:

        Dockerfile instructions order

        COPY vs ADD

        CMD vs ENTRYPOINT

        Layer caching strategy

Reading Material (10 mins):

    Dockerfile Reference

    Focus on:

        FROM instruction

        RUN, COPY, ADD

        CMD and ENTRYPOINT

        EXPOSE and WORKDIR

Dockerfile Examples (5 mins):
dockerfile

# Simple Dockerfile

FROM ubuntu:22.04
LABEL maintainer="you@example.com"
RUN apt update && apt install -y nginx
COPY index.html /var/www/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

💻 Evening Practice (6:30-8:00 PM)
Project: Create Custom Docker Images (75 mins)
bash

# Create project directory

mkdir -p ~/docker-practice/day3
cd ~/docker-practice/day3

# Step 1: Simple web server Dockerfile

mkdir simple-web && cd simple-web

# Create HTML file

cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Docker Day 3</title>
    <style>
        body { font-family: Arial; padding: 50px; }
        .container { max-width: 800px; margin: 0 auto; }
        h1 { color: #333; }
        .docker-badge { 
            background: #2496ed; 
            color: white; 
            padding: 5px 10px; 
            border-radius: 3px; 
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🐳 Docker Day 3 Practice</h1>
        <p>This page is served from a custom Docker container!</p>
        <p class="docker-badge">Built with Dockerfile</p>
        <h2>Instructions Used:</h2>
        <ul>
            <li>FROM - Base image</li>
            <li>RUN - Install packages</li>
            <li>COPY - Add files</li>
            <li>EXPOSE - Port declaration</li>
            <li>CMD - Default command</li>
        </ul>
        <p><strong>Container ID:</strong> <span id="container-id">Loading...</span></p>
    </div>
    <script>
        fetch('/hostname')
            .then(r => r.text())
            .then(id => document.getElementById('container-id').textContent = id)
            .catch(e => console.error(e));
    </script>
</body>
</html>
EOF

# Create Dockerfile

cat > Dockerfile << 'EOF'

# Use official Nginx base image

FROM nginx:alpine

# Label for metadata

LABEL maintainer="docker-learner@example.com"
LABEL version="1.0"
LABEL description="Simple web server for Docker practice"

# Set working directory

WORKDIR /usr/share/nginx/html

# Copy custom HTML file

COPY index.html .

# Create a simple script to show hostname

RUN echo '#!/bin/sh' > /docker-entrypoint.d/99-hostname.sh && \
    echo 'echo $HOSTNAME > /usr/share/nginx/html/hostname' >> /docker-entrypoint.d/99-hostname.sh && \
    chmod +x /docker-entrypoint.d/99-hostname.sh

# Expose port 80

EXPOSE 80

# Health check (optional)

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:80/ || exit 1

# Nginx runs in foreground (already in base image)

EOF

# Build the image

docker build -t my-webapp:1.0 .

# Check image details

docker image ls | grep my-webapp
docker image inspect my-webapp:1.0 | jq '.[0].Config.Labels'

# Run the container

docker run -d --name web-app -p 8080:80 my-webapp:1.0

# Test

curl http://localhost:8080
curl http://localhost:8080/hostname

# Step 2: Python application Dockerfile

cd ~/docker-practice/day3
mkdir python-app && cd python-app

# Create Python app

cat > app.py << 'EOF'
from flask import Flask, jsonify
import socket
import os

app = Flask(__name__)

@app.route('/')
def home():
    return '''
    <h1>Python Flask in Docker</h1>
    <p>Container: {}</p>
    <p>Python: {}</p>
    <ul>
        <li><a href="/health">Health Check</a></li>
        <li><a href="/info">Container Info</a></li>
        <li><a href="/env">Environment</a></li>
    </ul>
    '''.format(socket.gethostname(), os.sys.version)

@app.route('/health')
def health():
    return jsonify({"status": "healthy", "timestamp": os.times()})

@app.route('/info')
def info():
    return jsonify({
        "hostname": socket.gethostname(),
        "python_version": os.sys.version,
        "cpu_count": os.cpu_count(),
        "cwd": os.getcwd()
    })

@app.route('/env')
def environment():
    return jsonify(dict(os.environ))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
EOF

cat > requirements.txt << 'EOF'
Flask==2.3.3
gunicorn==20.1.0
EOF

# Create Dockerfile

cat > Dockerfile << 'EOF'

# Use official Python slim image

FROM python:3.11-slim

# Set environment variables

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV FLASK_APP=app.py
ENV FLASK_ENV=production

# Set working directory

WORKDIR /app

# Install system dependencies

RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code

COPY app.py .

# Create non-root user

RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# Expose port

EXPOSE 5000

# Health check

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s \
  CMD python -c "import requests; requests.get('http://localhost:5000/health')"

# Run with gunicorn

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
EOF

# Build and run

docker build -t python-app:1.0 .
docker run -d --name flask-app -p 5000:5000 python-app:1.0

# Test

curl http://localhost:5000
curl http://localhost:5000/info | jq .

# Step 3: Multi-stage build example

cd ~/docker-practice/day3
mkdir multi-stage && cd multi-stage

# Create simple Go app (or use any compiled language)

cat > main.go << 'EOF'
package main

import (
    "fmt"
    "net/http"
    "os"
    "runtime"
)

func main() {
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(w, `
        <h1>Go Multi-stage Docker Build</h1>
        <p><strong>Hostname:</strong> %s</p>
        <p><strong>Go Version:</strong> %s</p>
        <p><strong>OS/Arch:</strong> %s/%s</p>
        <p><strong>Message:</strong> Small container from multi-stage build!</p>
        `, os.Getenv("HOSTNAME"), runtime.Version(), runtime.GOOS, runtime.GOARCH)
    })

    port := ":8080"
    fmt.Printf("Server starting on port %s\n", port)
    http.ListenAndServe(port, nil)
}
EOF

cat > Dockerfile << 'EOF'
# Build stage

FROM golang:1.20-alpine AS builder

WORKDIR /app

# Copy go mod files

COPY go.mod ./
RUN go mod download

# Copy source

COPY *.go ./

# Build binary

RUN go build -o /app/server

# Final stage

FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy binary from builder

COPY --from=builder /app/server .

# Expose port

EXPOSE 8080

# Run binary

CMD ["./server"]
EOF

# Note: For Go, we need go.mod file

cat > go.mod << 'EOF'
module docker-practice

go 1.20
EOF

# Build and compare sizes

docker build -t go-app:single .
# Create non-multi-stage for comparison

cat > Dockerfile.single << 'EOF'
FROM golang:1.20-alpine

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY *.go ./

RUN go build -o server

EXPOSE 8080

CMD ["./server"]
EOF

docker build -f Dockerfile.single -t go-app:single-stage .
docker image ls | grep go-app

# Compare sizes

echo "Multi-stage build size:"
docker image inspect go-app:single --format='{{.Size}}' | numfmt --to=iec
echo "Single-stage build size:"
docker image inspect go-app:single-stage --format='{{.Size}}' | numfmt --to=iec

Dockerfile Challenge (15 mins):
bash

# Challenge: Create a Dockerfile with these requirements:

# 1. Base image: node:18-alpine
# 2. Install: curl, git, and your-app dependencies
# 3. Copy: package.json and package-lock.json first
# 4. Install dependencies with npm ci --only=production
# 5. Copy app files
# 6. Run as non-root user (node)
# 7. Expose port 3000
# 8. Health check that hits /health endpoint
# 9. Set NODE_ENV=production
# 10. Start with npm start

# Create challenge directory

mkdir ~/docker-practice/day3/challenge
cd ~/docker-practice/day3/challenge

# Create package.json

cat > package.json << 'EOF'
{
  "name": "docker-challenge-app",
  "version": "1.0.0",
  "description": "Docker Day 3 Challenge",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
EOF

# Create server.js

cat > server.js << 'EOF'
const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send(`
    <h1>Docker Challenge Success! 🎉</h1>
    <p><strong>Container:</strong> ${process.env.HOSTNAME}</p>
    <p><strong>Node:</strong> ${process.version}</p>
    <p><strong>Environment:</strong> ${process.env.NODE_ENV}</p>
  `);
});

app.get('/health', (req, res) => {
  res.json({ 
    status: 'healthy',
    timestamp: new Date().toISOString(),
    container: process.env.HOSTNAME
  });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
EOF

# Create Dockerfile solution

cat > Dockerfile << 'EOF'
FROM node:18-alpine

# Install system dependencies

RUN apk add --no-cache curl git

# Create non-root user

RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Set working directory

WORKDIR /app

# Copy package files

COPY package*.json ./

# Install dependencies

RUN npm ci --only=production

# Copy application

COPY --chown=nodejs:nodejs . .

# Switch to non-root user

USER nodejs

# Environment variables

ENV NODE_ENV=production \
    PORT=3000

# Expose port

EXPOSE 3000

# Health check

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
  CMD curl -f http://localhost:3000/health || exit 1

# Start application

CMD ["npm", "start"]
EOF

# Build and test

docker build -t challenge-app:latest .
docker run -d --name challenge -p 3000:3000 challenge-app:latest
curl http://localhost:3000
curl http://localhost:3000/health

## Youtube tutorial

https://www.youtube.com/watch?v=LQjaJINkQXY

1. What is Dockerfile
2. How to create Dockerfile
3. How to build image from Dockerfile
4. Basic Commands

# TIPS & TRICKS

**Dockerfile**

A text file with instructions to build image
Automation of Docker Image Creation

FROM
RUN
CMD

Step 1 : Create a file named Dockerfile

Step 2 : Add instructions in Dockerfile

Step 3 : Build dockerfile to create image

Step 4 : Run image to create container

COMMANDS
: docker build 
: docker build -t ImageName:Tag directoryOfDocekrfile

: docker run image

References:
https://github.com/wsargent/docker-ch...
https://docs.docker.com/engine/refere...

https://www.google.co.in/search?q=doc...