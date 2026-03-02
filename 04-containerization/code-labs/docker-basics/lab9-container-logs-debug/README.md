Lab 9: Container Logs & Debugging
🎯 Objective

Learn to monitor, debug, and troubleshoot Docker containers.
🚀 Exercises
Exercise 1: Basic Log Commands

bash

# Run a container that generates logs
docker run -d --name logger alpine sh -c "while true; do echo 'Log entry at $(date)'; sleep 5; done"

# View logs
docker logs logger

# Follow logs
docker logs -f logger

# Tail last 10 lines
docker logs --tail 10 logger

# Include timestamps
docker logs -t logger

# Since timestamp
docker logs --since 5m logger

# Until timestamp
docker logs --until 30m logger

Exercise 2: Debug with Exec
bash

# Run web server
docker run -d --name web-debug -p 8080:80 nginx:alpine

# Exec into container
docker exec -it web-debug sh

# Inside container:
#   ls -la /usr/share/nginx/html/
#   cat /etc/nginx/nginx.conf
#   ps aux
#   exit

# Run single command
docker exec web-debug nginx -T

Exercise 3: Inspect Container Details
bash

# Get all details
docker inspect web-debug

# Filter specific info
docker inspect web-debug --format='{{.State.Status}}'
docker inspect web-debug --format='{{.NetworkSettings.IPAddress}}'
docker inspect web-debug --format='{{.Config.Image}}'

# Using jq for JSON parsing
docker inspect web-debug | jq '.[0].NetworkSettings.Ports'

Exercise 4: Container Stats
bash

# Real-time stats
docker stats

# One-time stats
docker stats --no-stream

# Specific container
docker stats web-debug --no-stream

# Format output
docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"

Exercise 5: Debugging with Events
bash

# Watch Docker events in one terminal
docker events &

# In another terminal, create some activity
docker run --rm alpine echo "test"
docker pause web-debug
docker unpause web-debug
docker stop web-debug

# Filter events
docker events --filter 'type=container' --filter 'event=stop'

Exercise 6: Debugging Failed Containers
bash

# Run container that will fail
docker run --name failing -d alpine sh -c "exit 1"

# Check status (Exited)
docker ps -a | grep failing

# See why it failed
docker logs failing

# Check exit code
docker inspect failing --format='{{.State.ExitCode}}'

# Run with auto-remove to see exit code
docker run --rm alpine sh -c "exit 42"
echo "Exit code: $?"

Exercise 7: Resource Usage Debug
bash

# Run with resource limits
docker run -d \
  --name limited \
  --memory 256m \
  --cpus 0.5 \
  nginx:alpine

# Check limits applied
docker inspect limited | jq '.[0].HostConfig | {Memory: .Memory, NanoCpus: .NanoCpus}'

# Monitor usage
docker stats --no-stream limited

Exercise 8: Debugging Network Issues
bash

# Create network
docker network create debug-net

# Run containers
docker run -d --name app1 --network debug-net nginx:alpine
docker run -d --name app2 --network debug-net nginx:alpine

# Test connectivity
docker exec app1 ping -c 2 app2

# If fails, check:
docker network inspect debug-net
docker exec app1 cat /etc/hosts
docker exec app1 nslookup app2

Exercise 9: Docker Top and Diff
bash

# See processes in container
docker top app1

# See filesystem changes
docker diff app1

📝 Debugging Cheatsheet
bash

# Quick checks
docker ps -a                    # All containers
docker logs CONTAINER           # Application logs
docker inspect CONTAINER         # Detailed info
docker exec -it CONTAINER sh    # Shell access
docker stats                     # Resource usage
docker events                    # System events
docker system df                 # Disk usage

# Common issues:
# "port already allocated" - check docker ps
# "no space left" - docker system prune
# "cannot connect" - check docker network ls
# "permission denied" - check user in container

✅ Success Criteria

    Can view and follow logs

    Can exec into running containers

    Can inspect container details

    Can monitor resource usage

    Can debug common issues