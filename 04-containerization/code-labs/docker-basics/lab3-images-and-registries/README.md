🎯 Objective

Master Docker image management: pulling, pushing, tagging, and understanding image layers.
📚 Key Concepts

    Image: A read-only template with instructions for creating containers

    Registry: A storage and distribution system for Docker images (Docker Hub)

    Repository: A collection of related images (same name, different tags)

    Tag: A label applied to an image (e.g., nginx:1.25, nginx:alpine)

    Layer: Each instruction in a Dockerfile creates a layer

🚀 Exercises
Exercise 1: Pulling Images

# Pull specific versions
docker pull nginx:1.25
docker pull nginx:alpine
docker pull ubuntu:22.04
docker pull python:3.11-slim

# Pull without tag (defaults to 'latest')
docker pull redis

# See downloaded images
docker images

Exercise 2: Exploring Image Details
bash

# View image history (layers)
docker history nginx:alpine

# Inspect image metadata
docker inspect nginx:alpine

# See image size
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

Exercise 3: Tagging Images
bash

# Pull an image
docker pull alpine:3.19

# Tag it multiple ways
docker tag alpine:3.19 my-alpine:v1
docker tag alpine:3.19 my-alpine:latest
docker tag alpine:3.19 myregistry.com/my-alpine:prod

# See all tags
docker images | grep alpine

Exercise 4: Searching Registries
bash

# Search Docker Hub
docker search nginx
docker search --filter stars=1000 --limit 5 postgres

# View official images (with stars count)
docker search --filter is-official=true nginx

Exercise 5: Saving and Loading Images
bash

# Save image to tar file
docker save -o nginx-alpine.tar nginx:alpine

# Check file size
ls -lh nginx-alpine.tar

# Load image from tar (simulate on another machine)
docker load -i nginx-alpine.tar

# Remove original image
docker rmi nginx:alpine

# Verify image was removed
docker images | grep nginx

# Load it back
docker load -i nginx-alpine.tar

Exercise 6: Image Size Comparison
bash

# Pull different variants
docker pull nginx:latest       # Debian-based (~187MB)
docker pull nginx:alpine       # Alpine-based (~42MB)
docker pull nginx:alpine-slim  # Even smaller (~35MB)

# Compare sizes
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | grep nginx

Exercise 7: Pushing to Registry (Optional)
bash

# Login to Docker Hub (create account first)
docker login

# Tag your image with username
docker tag nginx:alpine yourusername/my-nginx:v1

# Push to Docker Hub
docker push yourusername/my-nginx:v1

# View on Docker Hub website

📝 Layer Caching Exercise
bash

# Create a simple Dockerfile
cat > Dockerfile << 'END'
FROM alpine:3.19
RUN echo "Layer 1: $(date)" > /layer1.txt
RUN echo "Layer 2: $(date)" > /layer2.txt
CMD cat /layer*.txt
END

# Build first time (both layers created)
docker build -t layer-test .

# Build again (layers cached - same timestamps)
docker build -t layer-test .

# Change first line and rebuild
sed -i 's/Layer 1/First Layer/' Dockerfile
docker build -t layer-test .

# Run to see output
docker run --rm layer-test

# to make images-labs.sh folder executable and run
cd images-labs.sh
chmod +x images-labs.sh
cd ..

✅ Success Criteria

    Can pull images from Docker Hub

    Understand image tagging

    Can save and load images

    Understand why Alpine images are smaller

    Grasp layer caching concept