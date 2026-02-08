# Docker Day 1 Cheatsheet

## Basic Commands:

- `docker --version` - Check Docker version
- `docker run IMAGE` - Run a container from image
- `docker ps` - List running containers
- `docker ps -a` - List all containers
- `docker stop CONTAINER` - Stop a container
- `docker rm CONTAINER` - Remove a container
- `docker images` - List images
- `docker rmi IMAGE` - Remove an image
- `docker pull IMAGE` - Download image
- `docker exec -it CONTAINER COMMAND` - Execute command in container
- `docker logs CONTAINER` - View container logs

## Common Flags:

- `-d` - Run in detached mode (background)
- `-p HOST:CONTAINER` - Port mapping
- `--name NAME` - Assign container name
- `-it` - Interactive terminal
- `--rm` - Remove container after exit
- `-v HOST:CONTAINER` - Volume mount
- `-e KEY=VALUE` - Set environment variable

## Key Concepts:

- **Image**: Template/blueprint for containers
- **Container**: Running instance of an image
- **Registry**: Store for images (Docker Hub)
- **Dockerfile**: Instructions to build an image

🔗 Additional Resources

    Docker Getting Started

    Play with Docker

    Docker Command Reference