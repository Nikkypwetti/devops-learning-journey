Lab 6: Networking Basics
🎯 Objective

Understand Docker networking models and container communication.
📚 Network Types

┌─────────────┐     ┌─────────────┐
│   bridge    │     │    host     │
│  (default)  │     │             │
├─────────────┤     ├─────────────┤
│   overlay   │     │   none      │
│  (swarm)    │     │             │
└─────────────┘     └─────────────┘

🚀 Exercises
Exercise 1: Default Bridge Network
bash

# List networks
docker network ls

# Inspect default bridge
docker network inspect bridge

# Run two containers on default network
docker run -d --name container1 alpine sleep 3600
docker run -d --name container2 alpine sleep 3600

# They can communicate via IP, but NOT by name
docker exec container1 ping -c 2 172.17.0.3  # Find container2's IP
docker exec container1 ping -c 2 container2   # This FAILS

Exercise 2: User-Defined Bridge Network
bash

# Create custom network
docker network create my-network

# Run containers on custom network
docker run -d --name app1 --network my-network alpine sleep 3600
docker run -d --name app2 --network my-network alpine sleep 3600

# Now they can ping by name (built-in DNS)!
docker exec app1 ping -c 2 app2
docker exec app2 ping -c 2 app1

Exercise 3: Connect/Disconnect Networks
bash

# Create container on default network
docker run -d --name container3 alpine sleep 3600

# Connect to custom network
docker network connect my-network container3

# Now container3 can reach both networks
docker exec container3 ping -c 2 app1
docker exec container3 ping -c 2 app2

# Disconnect
docker network disconnect my-network container3

Exercise 4: Host Network Mode
bash

# Run with host network (shares host's network stack)
docker run -d --name host-nginx --network host nginx:alpine

# Access directly on host port (no mapping needed)
curl http://localhost:80

# Compare IP addresses
docker exec host-nginx ip addr show
# Should show same as host machine

Exercise 5: None Network (Isolated)
bash

# Run with no network
docker run -d --name isolated --network none alpine sleep 3600

# No network interfaces except loopback
docker exec isolated ip addr show
# Should only show 'lo' (loopback)

Exercise 6: Network Aliases
bash

# Create network
docker network create app-network

# Run with alias
docker run -d \
  --name db \
  --network app-network \
  --network-alias database \
  --network-alias postgres \
  postgres:alpine

# Connect via alias
docker run --rm \
  --network app-network \
  alpine nslookup database

docker run --rm \
  --network app-network \
  alpine nslookup postgres

Exercise 7: Web App with Database Example
bash

# Create network
docker network create webapp-net

# Start database
docker run -d \
  --name postgres-db \
  --network webapp-net \
  -e POSTGRES_PASSWORD=secret \
  postgres:alpine

# Start web app (simulated)
docker run -d \
  --name web-app \
  --network webapp-net \
  -p 8080:8080 \
  alpine sh -c "while true; do echo 'Connecting to postgres-db:5432'; sleep 10; done"

# Check logs
docker logs web-app --tail 5

# Connect from app to db using name
docker exec web-app ping -c 2 postgres-db

📝 Practice Challenge

Create a three-tier application network:

    Frontend network (public)

    Backend network (internal)

    Database network (private)

    Ensure proper isolation between tiers

✅ Success Criteria

    Understand different network drivers

    Can create custom networks

    Know difference between bridge and host networking

    Can use DNS for service discovery

    Understand network isolation