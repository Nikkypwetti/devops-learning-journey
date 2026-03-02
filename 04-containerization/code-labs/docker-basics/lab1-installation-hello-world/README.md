# Lab 1: Installation & Hello World

## 🎯 Objective

Verify Docker installation and run your first container.

## 📚 Concepts Covered

- Docker installation verification
- Docker architecture overview
- Hello World container
- Understanding docker run

## 🚀 Exercises

### Exercise 1: Verify Installation

```bash
# Check Docker version
docker --version

# Check Docker system info
docker info

# Verify Docker can run containers
docker run hello-world

# See images on your system
docker images

# See containers (including stopped ones)
docker ps -a

# See disk usage
docker system df

# Cleanup
docker rmi hello-world -f

# to make test.sh folder executable and run
cd test.sh
chmod +x test.sh
cd ..