# Week 1: Docker Basics & Dockerfiles - Daily Resources

## 📅 **Week Overview**

**Focus:** Master Docker fundamentals, write efficient Dockerfiles, containerize applications  
**Duration:** 7 days  
**Success Metric:** Dockerize a Node.js web application with optimized image

---

## 📘 **Day 1: Introduction to Containerization**

### **🎯 Learning Objectives**

- Understand containerization vs virtualization
- Learn Docker architecture
- Install Docker on your system
- Run your first container

### **📚 Morning Resources (6:00-6:30 AM)**

#### **Video Tutorial (15 mins):**

- [Docker in 100 Seconds](https://www.youtube.com/watch?v=Gjnup-PuquQ) - Quick overview
- [What is Docker?](https://www.youtube.com/watch?v=3c-iBn73dDE) (first 15 minutes)
- **Key Takeaways:**
  - Containers vs Virtual Machines
  - Docker benefits: consistency, isolation, portability
  - Docker components: Engine, CLI, Registry

#### **Reading Material (10 mins):**

- [Docker Overview](https://docs.docker.com/get-started/overview/)
- **Focus on:**
  - Docker architecture
  - Images vs Containers
  - Docker Hub registry

#### **Concept Review (5 mins):**

- **Container:** Running instance of an image
- **Image:** Read-only template with instructions
- **Registry:** Storage for Docker images (Docker Hub)
- **Dockerfile:** Blueprint for building images

### **💻 Evening Practice (6:30-8:00 PM)**

#### **Step 1: Install Docker (20 mins)**

```bash
# For Ubuntu/Debian (check official docs for your OS)
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify installation
sudo docker --version
sudo docker compose version

# Optional: Add user to docker group to avoid sudo
sudo usermod -aG docker $USER
# Log out and log back in for changes to take effect

Step 2: Run First Containers (40 mins)
bash

# 1. Hello World container
docker run hello-world

# 2. Run an Nginx web server
docker run -d -p 8080:80 --name my-nginx nginx:alpine

# 3. Verify it's running
docker ps
curl http://localhost:8080

# 4. View logs
docker logs my-nginx

# 5. Execute commands inside container
docker exec -it my-nginx sh
# Inside container:
# cat /etc/nginx/nginx.conf
# exit

# 6. Stop and remove container
docker stop my-nginx
docker rm my-nginx

# 7. Explore Docker Hub
docker search nginx
docker pull nginx:latest
docker images

# 8. Run interactive container
docker run -it --rm ubuntu:latest bash
# Inside container:
# apt update
# apt install -y curl
# curl --version
# exit

Step 3: Docker Basics Practice (30 mins)
bash

# Practice with different images
# 1. Run a Redis container
docker run -d --name my-redis -p 6379:6379 redis:alpine
docker exec -it my-redis redis-cli ping

# 2. Run a PostgreSQL container
docker run -d --name my-postgres -e POSTGRES_PASSWORD=secret -p 5432:5432 postgres:alpine
docker exec -it my-postgres psql -U postgres -c "SELECT version();"

# 3. Clean up all containers
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

# 4. Practice common commands
docker version
docker info
docker system df  # Disk usage
docker stats     # Live container stats