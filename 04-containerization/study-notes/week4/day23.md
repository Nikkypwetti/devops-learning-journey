📓 My Docker Database Study Notes
Day 23: Running Databases in Containers
📝 What I'm Learning Today

How to run databases (PostgreSQL, MySQL, Redis) inside Docker containers and actually understand what I'm doing!
🧠 Why This Matters

Before today, I thought databases in containers were complicated. But here's the thing - running a database in Docker is super useful for:

    Testing without installing stuff on my computer

    Having clean, separate databases for different projects

    Being able to delete and recreate databases easily

    Matching the exact database version my app uses

But wait - there's a catch! Containers are temporary. If I just run a database container and delete it, POOF - all my data is gone. That's where volumes come in...
💾 The Golden Rule: Always Use Volumes!
bash

# ❌ BAD - data dies with container
docker run --name mydb -e POSTGRES_PASSWORD=secret postgres

# ✅ GOOD - data lives forever
docker run --name mydb -e POSTGRES_PASSWORD=secret -v mydata:/var/lib/postgresql/data postgres

Think of volumes like a USB drive that I plug into my container. The container can come and go, but the USB drive keeps my files.
🐘 PostgreSQL - My First Database Container
The Simple Way (Just Testing)
bash

docker run --name my-postgres \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -d postgres

What each part means:

    --name my-postgres → I'm giving my container a name so I don't have to remember its ID

    -e POSTGRES_PASSWORD=mysecretpassword → Setting the database password (REQUIRED!)

    -d → Run in background (detached) so I can keep using my terminal

    postgres → The image I'm using

The Proper Way (With Persistence)
bash

docker run --name my-postgres \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -v postgres_data:/var/lib/postgresql/data \
  -d postgres

Wait, what's that -v thing?

    -v postgres_data:/var/lib/postgresql/data means:

        Create a volume named postgres_data on my computer

        Connect it to /var/lib/postgresql/data inside the container (where PostgreSQL stores files)

        Now my data survives even if I delete the container!

Making It Fancy (Custom User + Database)
bash

docker run --name my-postgres \
  -e POSTGRES_USER=myapp_user \
  -e POSTGRES_PASSWORD=myapp_password \
  -e POSTGRES_DB=myapp_database \
  -v postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  -d postgres

New stuff:

    POSTGRES_USER=myapp_user → Instead of default 'postgres' user, create 'myapp_user'

    POSTGRES_DB=myapp_database → Create a database called 'myapp_database' automatically

    -p 5432:5432 → Let me connect from my computer (like using TablePlus or DBeaver)

🔌 Actually USING My Database
Way 1: Jump Inside the Container
bash

# Get into the container's command line
docker exec -it my-postgres bash

# Once inside, connect to PostgreSQL
psql -U myapp_user -d myapp_database

# Now I can run SQL!
myapp_database=# CREATE TABLE todos (id SERIAL, task TEXT);
myapp_database=# INSERT INTO todos (task) VALUES ('Learn Docker');
myapp_database=# SELECT * FROM todos;

Way 2: Connect From Another Container (Like My App)
bash

# First, create a network for containers to talk to each other
docker network create my-app-network

# Run my database on that network
docker run --name my-postgres \
  --network my-app-network \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -d postgres

# Run a temporary psql client to connect
docker run -it --rm \
  --network my-app-network \
  postgres psql -h my-postgres -U postgres

Key insight: -h my-postgres works because Docker has built-in DNS on user networks! The container name becomes the hostname.
Way 3: Connect From My Local Machine
bash

# Make sure I published the port (-p 5432:5432)
docker run --name my-postgres \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -p 5432:5432 \
  -d postgres

# Now I can connect with:
# Host: localhost
# Port: 5432
# User: postgres
# Password: mysecretpassword

🚀 Pro Tips I Discovered
1. Auto-run Setup Scripts

PostgreSQL automatically runs any .sql or .sh files in /docker-entrypoint-initdb.d/ ON THE FIRST RUN ONLY.
bash

# Create a setup.sql file
echo "CREATE DATABASE myapp;" > setup.sql

# Mount it into the container
docker run --name my-postgres \
  -e POSTGRES_PASSWORD=secret \
  -v $(pwd)/setup.sql:/docker-entrypoint-initdb.d/setup.sql \
  -v postgres_data:/var/lib/postgresql/data \
  -d postgres

Perfect for creating tables, users, or inserting seed data!
2. Check What's Running
bash

# See all containers
docker ps -a

# See just running containers
docker ps

# Check logs if something's wrong
docker logs my-postgres

# See how much space my volume is using
docker system df

3. Stop and Start Without Losing Data
bash

# Stop the container (data is safe in volume)
docker stop my-postgres

# Start it again later (all data still there!)
docker start my-postgres

# Remove and recreate with same volume (data persists!)
docker rm my-postgres
docker run --name my-postgres -v postgres_data:/var/lib/postgresql/data -e POSTGRES_PASSWORD=secret -d postgres

🗄️ Quick Reference: Other Databases
MySQL (very similar to PostgreSQL)
bash

# Run MySQL
docker run --name my-mysql \
  -e MYSQL_ROOT_PASSWORD=rootsecret \
  -e MYSQL_DATABASE=myapp \
  -e MYSQL_USER=myuser \
  -e MYSQL_PASSWORD=mypass \
  -v mysql_data:/var/lib/mysql \
  -p 3306:3306 \
  -d mysql

# Connect to it
docker exec -it my-mysql mysql -u root -p

Redis (super simple key-value store)
bash

# Run Redis
docker run --name my-redis \
  -v redis_data:/data \
  -p 6379:6379 \
  -d redis redis-server --appendonly yes

# Connect with redis-cli
docker exec -it my-redis redis-cli

# Try it out
127.0.0.1:6379> SET name "Docker"
127.0.0.1:6379> GET name
" Docker"

📋 Docker Compose - The Easy Way

Instead of typing long docker run commands, I can write everything in a file:
yaml

# docker-compose.yml
version: '3.8'

services:
  # PostgreSQL database
  postgres:
    image: postgres:15
    container_name: my_postgres
    environment:
      POSTGRES_USER: myuser
      POSTGRES_PASSWORD: mypassword
      POSTGRES_DB: mydb
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./init:/docker-entrypoint-initdb.d
    networks:
      - app_network

  # MySQL database  
  mysql:
    image: mysql:8
    container_name: my_mysql
    environment:
      MYSQL_ROOT_PASSWORD: rootpass
      MYSQL_DATABASE: mydb
      MYSQL_USER: myuser
      MYSQL_PASSWORD: mypass
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
    networks:
      - app_network

  # Redis cache
  redis:
    image: redis:7
    container_name: my_redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    command: redis-server --appendonly yes
    networks:
      - app_network

  # Adminer - web-based database manager (super handy!)
  adminer:
    image: adminer
    container_name: my_adminer
    ports:
      - "8080:8080"
    networks:
      - app_network

# Define all volumes
volumes:
  postgres_data:
  mysql_data:
  redis_data:

# Define network for services to talk to each other
networks:
  app_network:
    driver: bridge

To use it:
bash

# Start everything
docker-compose up -d

# See what's running
docker-compose ps

# Stop everything
docker-compose down

# Stop AND delete volumes (CAREFUL - loses data!)
docker-compose down -v

🎯 My Practice Checklist

    Run PostgreSQL: docker run --name test-postgres -e POSTGRES_PASSWORD=test -d postgres

    Add a volume: Stop, remove, and rerun with -v pgdata:/var/lib/postgresql/data

    Create some data: docker exec -it test-postgres psql -U postgres and run CREATE TABLE test (id int);

    Prove persistence: Remove container, run new one with same volume, check if table exists

    Try MySQL: Run MySQL container, connect, create a database

    Try Redis: Run Redis, set a key, get it back

    Use Docker Compose: Create a compose file with all three databases

⚠️ Common Mistakes I'll Avoid

    Forgetting the volume → Lose all data when container dies

    Using same port for multiple databases → Can't have two things on port 5432!

    Not setting password → PostgreSQL won't even start without POSTGRES_PASSWORD

    Connecting to wrong network → Containers can't talk across networks

    Assuming data persists without volumes → It DOESN'T!

💡 My "Aha!" Moments

    The database files LIVE in the container at specific paths, but I can MOUNT a volume there to keep them safe

    Environment variables are like configuration notes I pass to the container at startup

    Each database type has its own default port (PostgreSQL=5432, MySQL=3306, Redis=6379)

    docker exec lets me "get inside" a running container

    Docker Compose is just a better way to write docker run commands

📚 What To Study Next

    Connecting my actual app code to these database containers

    Backing up and restoring database volumes

    Different volume types (bind mounts vs named volumes)

    Docker networks in more detail

Remember: The whole point is to make databases portable and easy to manage. If I'm typing more than a few commands, I'm probably doing it wrong - time for Docker Compose!

## Note i jotte down while watching the video and reading the docs.

📝 My Study Notes | Day 23: Database Containers 
🎯 The Big Picture

I don't need to clutter my laptop by installing PostgreSQL, MySQL, or Redis directly anymore. Using Docker allows me to spin them up in seconds, keep them isolated, and—most importantly—ensure the database environment on my machine matches exactly what will run in production.
🐘 PostgreSQL (The Deep Dive)

From the tutorial, here is the breakdown of the "Ultimate Postgres Run Command":
The Command I'll use:
Bash

docker run -d \
  --name pg-dev \
  -p 5432:5432 \
  -e POSTGRES_USER=nikky \
  -e POSTGRES_PASSWORD=password123 \
  -e POSTGRES_DB=my_project_db \
  -v pgdata:/var/lib/postgresql/data \
  postgres

💡 What I need to remember about these flags:

    -d: Runs it in the background so it doesn't hijack my terminal.

    -p 5432:5432: Postgres defaults to port 5432. The first number is the port on my machine, the second is inside the container.

    -e (Environment Variables): This is how I tell the container what the username and password should be before it starts up.

    -v (Persistence - CRITICAL): Containers are "ephemeral" (temporary). If I don't use this, all my data is deleted when the container stops. This flag maps a volume called pgdata to the specific folder where Postgres stores its data inside the container (/var/lib/postgresql/data).

🛠 How to actually use the DB once it's running:

    Check if it's alive: Run docker container ls to see the container ID and status.

    Jump inside: Use docker exec -it <container_id> psql -U nikky -d my_project_db.

        Note: -it stands for interactive terminal, which lets me type SQL commands directly.

🐬 MySQL & 🔴 Redis (The Practice)
MySQL Setup

Very similar to Postgres, but the environment variable name changes slightly.

    Command: docker run -d --name mysql-dev -e MYSQL_ROOT_PASSWORD=rootpass -p 3306:3306 mysql

    DevOps Tip: Always use a volume for /var/lib/mysql to keep your tables safe.

Redis Setup

Redis is a "Key-Value" store and is much faster because it lives in memory.

    Command: docker run -d --name redis-dev -p 6379:6379 redis

    Real-World Use: We usually use this for caching or session management in our apps.

🚀 Pro-Tips for my DevOps Journey

    Persistence is King: In a professional setting, we never run a database in Docker without a volume or a cloud-managed storage backend. No volume = Lost data.

    Connectivity: In the next lesson, I’ll learn Docker Compose. It's better than running these long docker run commands because I can define my App and my Database in one file and they can talk to each other by name (e.g., the app connects to db:5432 instead of localhost:5432).

    Cleanup: When I'm done studying, I'll use docker stop <name> and docker rm <name> to save my RAM.