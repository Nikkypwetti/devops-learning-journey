Lab 5: Volumes Basics
🎯 Objective

Understand data persistence in Docker using volumes and bind mounts.
📚 Volume Types

    Named Volumes: Managed by Docker, stored in /var/lib/docker/volumes/

    Bind Mounts: Map any host directory to container

    tmpfs Mounts: In-memory storage (ephemeral)

🚀 Exercises
Exercise 1: Named Volumes

# Create a named volume
docker volume create my-data

# List volumes
docker volume ls

# Inspect volume
docker volume inspect my-data

# Run container with volume
docker run -d \
  --name db1 \
  -v my-data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=secret \
  mysql:8

# Data persists even if container removed
docker rm -f db1

# Create new container with same volume
docker run -d \
  --name db2 \
  -v my-data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=secret \
  mysql:8

# Data from db1 is still there!

Exercise 2: Bind Mounts
bash

# Create a directory on host
mkdir -p ~/docker-data/html

# Create an index.html file
echo "<h1>Hello from Bind Mount!</h1>" > ~/docker-data/html/index.html

# Mount it to nginx
docker run -d \
  --name web-bind \
  -p 8080:80 \
  -v ~/docker-data/html:/usr/share/nginx/html:ro \
  nginx:alpine

# Test
curl http://localhost:8080

# Modify file on host
echo "<h1>Updated Content!</h1>" > ~/docker-data/html/index.html

# Refresh browser - content updated without rebuilding!

Exercise 3: Anonymous Volumes
bash

# Anonymous volume (random name)
docker run -d \
  --name temp-db \
  -v /var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=secret \
  mysql:8

# Find the volume
docker volume ls

# Clean up (volume will be orphaned)
docker rm -f temp-db

# Remove orphaned volume
docker volume prune

Exercise 4: tmpfs Mounts (RAM)
bash

# Run with tmpfs (in-memory storage)
docker run -d \
  --name redis-tmpfs \
  --tmpfs /data:rw,noexec,nosuid,size=100m \
  redis:alpine

# Check mount
docker inspect redis-tmpfs | jq '.[0].HostConfig.Tmpfs'

# Data is lost when container stops
docker stop redis-tmpfs
docker rm redis-tmpfs

Exercise 5: Sharing Data Between Containers
bash

# Create volume
docker volume create shared-data

# Container A writes data
docker run --name writer \
  -v shared-data:/data \
  alpine sh -c "echo 'Hello from A' > /data/message.txt"

# Container B reads data
docker run --rm \
  -v shared-data:/data \
  alpine cat /data/message.txt

Exercise 6: Backup and Restore Volumes
bash

# Create data
docker run --name data-container \
  -v myapp-data:/app/data \
  alpine sh -c "echo 'Important data' > /app/data/file.txt"

# Backup volume
docker run --rm \
  -v myapp-data:/source:ro \
  -v $(pwd):/backup \
  alpine tar czf /backup/data-backup.tar.gz -C /source .

# Restore to new volume
docker volume create new-data
docker run --rm \
  -v new-data:/target \
  -v $(pwd):/backup:ro \
  alpine tar xzf /backup/data-backup.tar.gz -C /target

📝 Practice Challenge

Build a simple note-taking app:

    Create a volume notes-data

    Run an alpine container that writes notes to /notes/notes.txt

    Verify data persists after container removal

    Create second container that reads the notes

✅ Success Criteria

    Understand difference between volume types

    Can create and use named volumes

    Can use bind mounts for development

    Know how to share data between containers

    Can backup and restore volumes