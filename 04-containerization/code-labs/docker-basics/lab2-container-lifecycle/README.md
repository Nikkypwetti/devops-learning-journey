🎯 Objective

Master the complete lifecycle of containers: create, start, stop, restart, and remove.
📚 Lifecycle Commands

┌─────────┐    docker start    ┌─────────┐
│ Created │ ──────────────────> │ Running │
└─────────┘                     └─────────┘
      ^                              │
      │                              │ docker stop
      │                              │
      │                       ┌──────▼──────┐
      └───────────────────────│   Stopped   │
        docker rm              └─────────────┘

🚀 Exercises
Exercise 1: Create and Start Containers
bash

# Create a container (without starting)
docker create --name my-nginx nginx:alpine

# Check it exists but isn't running
docker ps -a | grep my-nginx

# Start the container
docker start my-nginx

# Verify it's running
docker ps | grep my-nginx

Exercise 2: Run (Create + Start)
bash

# Run a new container (create + start)
docker run -d --name my-nginx2 nginx:alpine

# Check it's running
docker ps

Exercise 3: Pause and Unpause
bash

# Pause container processes
docker pause my-nginx2

# Check status (Paused)
docker ps

# Unpause
docker unpause my-nginx2

Exercise 4: Stop and Start
bash

# Stop gracefully (sends SIGTERM)
docker stop my-nginx2

# Start again
docker start my-nginx2

# Kill immediately (sends SIGKILL)
docker kill my-nginx

Exercise 5: Remove Containers
bash

# Remove a stopped container
docker rm my-nginx

# Force remove a running container
docker rm -f my-nginx2

# Remove all stopped containers
docker container prune

# Remove all containers (running and stopped)
docker rm -f $(docker ps -aq) 2>/dev/null || true

Exercise 6: Interactive Container
bash

# Run interactive Ubuntu container
docker run -it --name my-ubuntu ubuntu:22.04 bash

# Inside the container:
#   ls -la
#   apt update
#   apt install curl
#   curl --version
#   exit

# Restart and reattach
docker start -ai my-ubuntu

# to make lifecycle-practice.sh folder executable and run
cd lifecycle-practice.sh
chmod +x lifecycle-practice.sh
cd ..

📝 Practice Challenge

Create a script that:

    Creates an nginx container named web-server

    Starts it

    Waits 5 seconds

    Stops it

    Removes it

✅ Success Criteria

    Can explain difference between create and run

    Can pause and unpause containers

    Know when to use stop vs kill

    Can remove containers safely
