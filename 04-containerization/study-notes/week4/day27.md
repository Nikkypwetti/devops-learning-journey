📝 My Docker Swarm Study Notes - Day 27
🎯 What I'm Learning Today

Docker Swarm = way to cluster multiple Docker engines together into one big super Docker host!
🤔 First Things First: What IS a Swarm?

Imagine I have 3 computers running Docker. Instead of managing them separately, I can connect them into a SWARM (cluster). Now they act like ONE giant computer with more power!

Think of it like:

    Regular Docker = one chef in one kitchen

    Docker Swarm = many chefs across multiple kitchens, all coordinated by a head chef

Super Important! 🔥
There are TWO different things called "Docker Swarm" (confusing, right?):

    ❌ Docker Classic Swarm = old version, don't use (dead project)

    ✅ Docker Swarm MODE = built into Docker Engine NOW, use this!

🏗️ The Architecture: Managers and Workers

Every swarm has two types of "nodes" (nodes = computers in the cluster):
👔 Manager Nodes (The Bosses)

    They're in charge! Control the whole cluster

    Handle commands, assign work, maintain order

    For safety, always have odd number of managers (3, 5, etc.)

    They use something called "Raft consensus" to agree on decisions (like voting)

🔧 Worker Nodes (The Workers)

    Just do the work assigned by managers

    Run the actual containers

    Don't make decisions, just follow orders

text

My Swarm Setup:
┌─────────────────┐
│  Manager Node   │ ← The boss
│  (Captain)      │
└────────┬────────┘
         │
    ┌────┴────┬──────────┐
    ▼         ▼          ▼
┌────────┐ ┌────────┐ ┌────────┐
│Worker 1│ │Worker 2│ │Worker 3│
│(Does   │ │(Does   │ │(Does   │
│ work)  │ │ work)  │ │ work)  │
└────────┘ └────────┘ └────────┘

✨ Cool Features I Need to Know
1. Declarative Model (Fancy term, simple concept)

    I say WHAT I want: "I want 3 copies of my web app running"

    Swarm figures out HOW: finds computers, starts containers, keeps them running

2. Self-Healing (My favorite!)

    If a worker computer crashes, swarm automatically starts new containers elsewhere

    It constantly checks: "Is everything how it should be?" If not, fixes it!

3. Multi-Host Networking (Magic!)

    Containers on different computers can talk to each other like they're neighbors

    Uses "overlay networks" (like creating a virtual LAN across machines)

4. Built-in Load Balancing

    When I ask for "my-web-app", swarm automatically spreads traffic across all copies

    No extra setup needed!

5. Secure by Default 🔒

    All communication between nodes is encrypted

    Uses certificates and TLS (fancy security stuff)

    I don't have to do anything - it's automatic!

6. Rolling Updates (Zero Downtime!)

    When updating my app, swarm updates them one by one

    If something breaks, it automatically rolls back

    My users never see an error!

📚 Key Vocabulary (Must Remember!)
Term	What It Means
Swarm	The whole cluster of Docker engines
Node	A single computer in the swarm
Manager	A node that controls the swarm
Worker	A node that runs containers
Service	The definition of what I want to run (like a blueprint)
Task	An actual running container (the real thing)
Replicas	How many copies of a service I want
Overlay Network	Virtual network connecting containers across nodes
🖥️ Commands I Must Practice (With Notes!)
Initializing a Swarm (Starting Point)
bash

# On my first computer - make it the manager
docker swarm init --advertise-addr 192.168.1.10

📝 After running this, it gives me a token - I need to save this!
Adding Worker Nodes
bash

# On other computers - join them as workers
docker swarm join --token SWMTKN-1-abc123... 192.168.1.10:2377

📝 Port 2377 is the default swarm management port
Checking My Swarm
bash

# On manager node - see all computers in my swarm
docker node ls

This shows:

    Which nodes are managers vs workers

    If they're online/healthy

    The manager with the * is the current leader

🎮 My Practice Plan (Step by Step)
Setup (Need at least 2 computers/VMs)

    Computer A - Will be manager

    Computer B - Will be worker

    (Optional) Computer C - Another worker

Step 1: Create the Swarm

On Computer A:
bash

docker swarm init --advertise-addr (Computer A's IP)
# COPY THE OUTPUT TOKEN!

Step 2: Add Workers

On Computer B and C:
bash

docker swarm join --token (paste token here) (Computer A's IP):2377

Step 3: Verify

Back on Computer A:
bash

docker node ls
# Should see all computers listed

Step 4: Deploy My First Service
bash

# Run 3 copies of nginx across my swarm
docker service create --name my-web \
  --replicas 3 \
  -p 80:80 \
  nginx

Step 5: Check It Worked
bash

# See where my containers are running
docker service ps my-web

# See service details
docker service ls

💡 My "AHA!" Moments

Swarm vs Compose:

    Docker Compose = run multiple containers on ONE machine

    Docker Swarm = run containers across MULTIPLE machines

It's Built-In! I don't need to install anything extra - it's already in my Docker Engine!

Why Use Swarm? Because if one computer crashes, my app keeps running on others. Reliability!
❗ Common Gotchas (Learn from Others' Mistakes)

    Firewall ports must be open:

        2377 - cluster management

        7946 - node communication

        4789 - overlay network traffic

    Time sync matters! All nodes need synchronized clocks (use NTP)

    Don't make every node a manager - managers do extra work, can slow down cluster

    Always use odd number of managers - 1, 3, 5, never 2 or 4

✅ Quick Quiz to Test Myself

    Can I explain difference between manager and worker?

    Do I know what happens if a worker crashes?

    Can I initialize a swarm from memory?

    Do I understand what "desired state reconciliation" means?

    Can I add a worker to an existing swarm?

🔗 Resources I Used

    Official Docs: https://docs.docker.com/engine/swarm/

    Video: Docker Swarm Mode Walkthrough (15 mins)

## Note i jotte down while watching the video and reading the docs.
 
📓 My Study Notes: Docker Swarm (Day 27)
💡 The Big Picture

I used to just run docker run on one machine. Docker Swarm is how I run containers across a whole fleet of machines. It turns 5 or 10 servers into one giant "Super Docker" computer.
🏗️ The Team (Nodes)

There are two roles a server can have in my cluster:

    The Manager: The "Boss." It keeps the blueprint of how many containers should be running. It’s the only one I talk to (using CLI commands).

    The Worker: The "Employee." It just sits there and runs whatever containers the Manager tells it to. It doesn't make decisions.

    Note to self: If I'm in a Manager node, I use docker node ls to see who is on my team.

🛠️ Setting it Up (The "2-Command" Cluster)

I don't need fancy software. It’s already built into Docker.

    On Machine A (The Boss):
    docker swarm init --advertise-addr <IP-of-this-box>

        Result: It gives me a "Join Token" (like a secret password).

    On Machine B & C (The Workers):
    docker swarm join --token <THE-TOKEN-FROM-ABOVE> <IP-of-Boss>:2377

        Result: They are now part of the family.

📦 Services (The "New" way to run things)

In a Swarm, I don't "run containers." I "create services."

    The Command: docker service create --name my-app --replicas 3 -p 80:80 nginx

    Why this is better: I’m telling the Manager: "I want 3 copies of Nginx running somewhere in the cluster. I don't care which server they are on, just make it happen."

🛡️ Why DevOps Pros Love This (The "Cool" Features)

    Self-Healing: If a Worker node "dies" (unplugged/crashed), the Manager notices. It immediately starts new containers on the other healthy nodes to get back to my 3 replicas. Zero manual work for me.

    Scaling: If my app gets famous, I just run:
    docker service scale my-app=50

        Boom. 50 containers spinning up across the whole cluster in seconds.

    The "Routing Mesh": This is magic. I can hit the IP address of any node in the cluster, and it will find my app, even if the container is actually running on a different node.

🚦 Quick Troubleshooting / Verification

    docker node ls → "Who is in my cluster and are they healthy?"

    docker service ls → "What apps am I running right now?"

    docker service ps <name> → "Where exactly is each copy of my app running?"

🧪 Practice Checklist for Today:

    [ ] Initialize the Manager.

    [ ] Add at least one Worker (use a second VM or a cloud instance).

    [ ] Deploy a service with replicas 2.

    [ ] The "Crash Test": Manually stop a container on the worker and watch the Manager immediately start a replacement.

Here are my jotted notes for setting this up on AWS.
☁️ AWS Lab Setup: "The Real-World Cluster"

1. The Hardware (EC2 Instances)

    Spin up 3 EC2 Instances (t2.micro/t3.micro is fine—keep it in the free tier!).

    Naming Tip: Name them Swarm-Manager, Swarm-Worker-01, and Swarm-Worker-02.

    Security Group (Crucial!): Make sure they are in the same Security Group and open these ports for "Custom TCP": 2377, 7946, 4789 (and 80 for your web app).

🚀 Implementation Steps (My CLI Cheat Sheet)

Step 1: Install Docker on all 3 nodes
Bash

# Run this on all three
sudo apt update && sudo apt install docker.io -y
sudo systemctl start docker
sudo usermod -aG docker ubuntu  # So I don't have to type 'sudo' every time

(Logout and log back in for the group change to work!)

Step 2: Initialize the Manager
Go to the Swarm-Manager terminal:
Bash

docker swarm init --advertise-addr <PRIVATE-IP-OF-MANAGER>

    Note: Use the Private IP because nodes talk over the internal AWS network (faster and cheaper).

    Copy the output: It looks like docker swarm join --token SWMTKN...

Step 3: Join the Workers
Paste that command into both Swarm-Worker-01 and 02:
Bash

docker swarm join --token <TOKEN> <MANAGER-PRIVATE-IP>:2377

Step 4: Confirm the Fleet
Back on the Manager:
Bash

docker node ls

    I should see 3 nodes listed. The Manager should say "Leader."

🏗️ Deploying a "Production" App

Now, instead of just a test, I'll deploy a visualizer tool so I can see the swarm working.
Bash

docker service create \
  --name swarm-viz \
  --publish 8080:8080 \
  --constraint 'node.role == manager' \
  --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  dockersamples/visualizer

Why this command?

    --constraint: This tool must run on a manager to see the cluster data.

    --mount: It needs to "talk" to the Docker engine directly.

    Test it: Open my browser to <MANAGER-PUBLIC-IP>:8080. I’ll see a map of my nodes!

🧹 Cleaning Up (Don't waste AWS credits!)

When I'm done studying:

    On workers: docker swarm leave

    On manager: docker swarm leave --force

    STOP or Terminate the EC2 instances in the AWS Console.

Here are my jotted notes on how to deploy a full stack to your AWS Swarm.
📂 The "Stack" Note: Deploying Everything at Once

The Concept:
A "Stack" is just a collection of services that make up an app (e.g., WordPress + MySQL). Instead of docker-compose up, in Swarm mode, we use docker stack deploy.
📝 My docker-compose.yml (The Blueprint)

I’ll create this file on the Manager Node. It defines a web app and a database.
YAML

version: '3.8'

services:
  web:
    image: nginx:latest
    ports:
      - "80:80"
    deploy:
      replicas: 4
      update_config:
        parallelism: 2
        delay: 10s
      restart_policy:
        condition: on-failure

  db:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: mysecretpassword
    deploy:
      placement:
        constraints:
          - "node.role == worker" # Keep the DB off the manager node

What did I just write?

    replicas: 4: Even if I have 3 nodes, Swarm will balance these 4 containers across them.

    parallelism: 2: When I update the app, it updates 2 containers at a time (so the site never goes down).

    constraints: I'm telling Swarm to only put the Database on a Worker node for better security/isolation.

🚀 The "Magic" Command

On the Manager Node, I run this to launch the whole thing:
Bash

docker stack deploy -c docker-compose.yml my_project

    Check the status: docker stack ps my_project

    See the services: docker stack services my_project

🔄 Real-World Scenario: The "Rolling Update"

Imagine I need to update the web image to a new version. In a professional setting, I can't have downtime.

My Jotted Step:

    Edit the docker-compose.yml with the new image version.

    Run the same command again: docker stack deploy -c docker-compose.yml my_project

    Watch the magic: Swarm will kill 2 old containers, start 2 new ones, wait 10 seconds (the delay I set), then do the next 2. Zero downtime.

🧠 Things to Remember (The "Gotchas")

    Images: All nodes must be able to pull the image. If it’s a private image, I need to log in to Docker Hub on all nodes or use the --with-registry-auth flag.

    Volumes: This is tricky. If the db container moves from Worker 1 to Worker 2, its data doesn't follow it automatically. (In the real world, we use NFS or cloud storage like AWS EFS for this).

🧪 Practice Task:

    [ ] Create a docker-compose.yml on your AWS Manager.

    [ ] Deploy it as a stack.

    [ ] Use docker service scale my_project_web=6 to see it expand across your AWS instances.

    [ ] Delete everything with one command: docker stack rm my_project.
