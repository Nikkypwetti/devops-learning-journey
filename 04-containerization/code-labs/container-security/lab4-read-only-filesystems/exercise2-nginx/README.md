### **Exercise 2: Nginx with Read-Only Filesystem**

```markdown
# Exercise 2: Nginx with Read-Only Filesystem

## The Challenge
Nginx needs to write to several locations: logs, cache, and temporary files. Let's configure it to run securely with a read-only root filesystem [citation:1].

## Step 1: Understand Nginx Requirements
Nginx typically writes to:
- `/var/log/nginx/` - Access and error logs
- `/var/cache/nginx/` - Cache directory
- `/tmp/` - Temporary files
- `/run/nginx.pid` - PID file

## Step 2: Create Required Volumes

```bash
# Create named volumes for persistent data
docker volume create nginx-logs
docker volume create nginx-cache

# Create directories for bind mounts (optional)
mkdir -p ./nginx-logs ./nginx-cache

Step 3: Run Nginx with Read-Only Root
bash

# Run Nginx with read-only root and proper mounts
docker run -d \
  --name nginx-secure \
  --read-only \
  --tmpfs /tmp:rw,noexec,nosuid,size=100m \
  --tmpfs /run:rw,noexec,nosuid,size=10m \
  -v nginx-logs:/var/log/nginx \
  -v nginx-cache:/var/cache/nginx \
  -p 8080:80 \
  nginx:alpine

# Check if it's running
docker ps | grep nginx-secure

# Test the web server
curl http://localhost:8080

# Verify read-only status
docker inspect nginx-secure | grep ReadonlyRootfs

Step 4: Docker Compose Configuration

docker-compose.secure.yml
yaml

version: '3.8'

services:
  nginx:
    image: nginx:alpine
    container_name: nginx-secure
    read_only: true
    tmpfs:
      - /tmp:rw,noexec,nosuid,size=100m
      - /run:rw,noexec,nosuid,size=10m
    volumes:
      - nginx-logs:/var/log/nginx
      - nginx-cache:/var/cache/nginx
      - ./nginx.conf:/etc/nginx/nginx.conf:ro  # Config mounted read-only
    ports:
      - "8080:80"
    restart: unless-stopped

volumes:
  nginx-logs:
  nginx-cache:

Step 5: Custom Nginx Config for Read-Only

nginx.conf
nginx

# Optimized for read-only root
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log warn;
pid /tmp/nginx.pid;  # PID in tmpfs, not /run

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    # Cache settings
    proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=my_cache:10m;

    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log main;

    sendfile on;
    keepalive_timeout 65;

    server {
        listen 80;
        server_name localhost;

        location / {
            root /usr/share/nginx/html;
            index index.html;
        }

        location /health {
            access_log off;
            return 200 "healthy\n";
        }
    }
}

Run with custom config:
bash

docker-compose -f docker-compose.secure.yml up -d

Verification Checklist ✅

    Container runs without "Read-only file system" errors

    Logs are being written to the volume

    Cache directory is writable

    PID file is created in tmpfs

    Web server responds on port 8080

Troubleshooting
bash

# Check logs for permission errors
docker logs nginx-secure

# Verify mounts
docker inspect nginx-secure | jq '.[0].Mounts'

# Test file writes
docker exec nginx-secure touch /tmp/test-file
docker exec nginx-secure touch /var/log/nginx/test-log  # Should fail (read-only?)