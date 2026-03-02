Lab 4: Port Mapping
🎯 Objective

Learn how to expose container ports to the host machine and understand port mapping concepts.
📚 Port Mapping Basics

┌─────────────────┐      ┌─────────────────┐
│   Host Machine  │      │   Container     │
│                 │      │                 │
│  localhost:8080 │─────>│  container:80   │
│                 │      │                 │
└─────────────────┘      └─────────────────┘

🚀 Exercises
Exercise 1: Basic Port Mapping
bash

# Run nginx with port mapping
docker run -d --name web1 -p 8080:80 nginx:alpine

# Test it
curl http://localhost:8080

Exercise 2: Multiple Port Mappings
bash

# Run with multiple ports exposed
docker run -d --name web2 \
  -p 8081:80 \
  -p 8443:443 \
  nginx:alpine

# Check mappings
docker port web2

Exercise 3: Random Host Port
bash

# Let Docker assign random host port
docker run -d --name web3 -p 80 nginx:alpine

# Find which port was assigned
docker port web3

Exercise 4: Binding to Specific IP
bash

# Bind only to localhost (not accessible from network)
docker run -d --name web4 -p 127.0.0.1:8082:80 nginx:alpine

# Try accessing
curl http://127.0.0.1:8082  # Works
# From another machine, http://YOUR_IP:8082 will FAIL

Exercise 5: Port Range
bash

# Map a range of ports
docker run -d --name web5 -p 8080-8090:80 nginx:alpine
# Note: This maps first container port 80 to first host port 8080

Exercise 6: Multiple Containers, Different Ports
bash

# Run three nginx containers on different ports
docker run -d --name nginx1 -p 8081:80 nginx:alpine
docker run -d --name nginx2 -p 8082:80 nginx:alpine
docker run -d --name nginx3 -p 8083:80 nginx:alpine

# Test each
curl http://localhost:8081
curl http://localhost:8082
curl http://localhost:8083

Exercise 7: Port Conflict
bash

# This will work
docker run -d --name app1 -p 3000:3000 node:18-alpine sleep 3600

# This will FAIL (port 3000 already used on host)
docker run -d --name app2 -p 3000:3000 node:18-alpine sleep 3600

# Fix by using different host port
docker run -d --name app2 -p 3001:3000 node:18-alpine sleep 3600

📝 Practice Challenge

Create a script that:

    Runs three different web applications:

        nginx on port 8080

        httpd (Apache) on port 8081

        python http server on port 8082

    Tests each is accessible

    Cleans up

✅ Success Criteria

    Understand -p host:container syntax

    Can map multiple ports

    Know how to find mapped ports

    Understand port conflicts

    Can bind to specific IP addresses