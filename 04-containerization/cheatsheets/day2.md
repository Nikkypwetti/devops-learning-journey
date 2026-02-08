# Docker Commands Cheatsheet

## CONTAINER MANAGEMENT

## Lifecycle

docker create IMAGE          # Create container
docker run IMAGE            # Create and start
docker start CONTAINER      # Start stopped
docker stop CONTAINER       # Stop running
docker restart CONTAINER    # Restart
docker pause CONTAINER      # Suspend
docker unpause CONTAINER    # Resume
docker kill CONTAINER       # Force stop
docker rm CONTAINER         # Remove stopped
docker exec CONTAINER CMD   # Execute command

## Inspection

docker ps                   # List running
docker ps -a                # List all
docker logs CONTAINER       # View logs
docker inspect CONTAINER    # Details
docker top CONTAINER        # Processes
docker stats                # Performance
docker diff CONTAINER       # FS changes
docker port CONTAINER       # Port mapping

## IMAGE MANAGEMENT

docker images               # List images
docker pull IMAGE           # Download
docker push IMAGE           # Upload
docker rmi IMAGE            # Remove
docker build PATH           # Build from Dockerfile
docker history IMAGE        # Image layers
docker tag IMAGE NEW_TAG    # Tag image

## SYSTEM & CLEANUP

docker version              # Version info
docker info                 # System info
docker system df            # Disk usage
docker system prune         # Clean unused
docker volume prune         # Clean volumes
docker network prune        # Clean networks

## VOLUMES

docker volume ls            # List volumes
docker volume create NAME   # Create
docker volume inspect NAME  # Details
docker volume rm NAME       # Remove

## NETWORKS

docker network ls           # List networks
docker network create NAME  # Create
docker network connect NET CONTAINER  # Connect
docker network disconnect NET CONTAINER # Disconnect
docker network inspect NET  # Details

## USEFUL FLAGS

-d                         # Detached mode
-it                        # Interactive
--name NAME                # Container name
-p HOST:CONTAINER          # Port mapping
-v HOST:CONTAINER          # Volume mount
-e KEY=VALUE               # Environment var
--rm                       # Auto-remove
--restart POLICY           # Restart policy
--memory LIMIT             # Memory limit
--cpus VALUE               # CPU limit

## 🔗 Additional Resources

    Docker Run Reference

    Docker Networking

    Docker Storage