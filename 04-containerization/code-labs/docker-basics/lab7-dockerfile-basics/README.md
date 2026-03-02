Lab 7: Dockerfile Basics
🎯 Objective

Learn to create custom images using Dockerfiles.
📚 Dockerfile Instructions

FROM        # Base image
RUN         # Execute commands during build
COPY        # Copy files from host
ADD         # Copy with extra features (URL, tar)
WORKDIR     # Set working directory
ENV         # Set environment variables
EXPOSE      # Document ports
CMD         # Default command
ENTRYPOINT  # Main command (harder to override)

🚀 Exercises
Exercise 1: Simple Web Server

Create Dockerfile.simple:
dockerfile

FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
EXPOSE 80

Create index.html:
html

<!DOCTYPE html>
<html>
<head><title>My Docker Image</title></head>
<body>
<h1>Hello from my custom image!</h1>
<p>Built with Dockerfile</p>
</body>
</html>

Build and run:
bash

docker build -f Dockerfile.simple -t my-nginx .
docker run -d -p 8080:80 --name my-web my-nginx
curl http://localhost:8080

Exercise 2: Python App

Create app.py:
python

from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def hello():
    return f"Hello from container! Host: {os.uname()[1]}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

Create requirements.txt:
text

flask==2.3.3

Create Dockerfile.python:
dockerfile

FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]

Build and run:
bash

docker build -f Dockerfile.python -t flask-app .
docker run -d -p 5000:5000 --name my-flask flask-app
curl http://localhost:5000

Exercise 3: Multi-stage Build Example

Create Dockerfile.multistage:
dockerfile

# Build stage
FROM alpine:3.19 AS builder
RUN apk add --no-cache wget
WORKDIR /build
RUN wget https://example.com/file.txt

# Final stage
FROM alpine:3.19
COPY --from=builder /build/file.txt /app/
WORKDIR /app
CMD ["cat", "file.txt"]

Exercise 4: Understanding Layers

Create Dockerfile.layers:
dockerfile

FROM alpine:3.19
RUN echo "Layer 1: $(date)" > /layer1.txt
RUN echo "Layer 2: $(date)" > /layer2.txt
RUN echo "Layer 3: $(date)" > /layer3.txt
CMD cat /layer*.txt

Build and observe caching:
bash

docker build -f Dockerfile.layers -t layers .
docker history layers

Exercise 5: CMD vs ENTRYPOINT

Create Dockerfile.cmd:
dockerfile

FROM alpine:3.19
CMD ["echo", "Default message"]

Create Dockerfile.entrypoint:
dockerfile

FROM alpine:3.19
ENTRYPOINT ["echo"]
CMD ["Default message"]

Test differences:
bash

# CMD can be overridden entirely
docker run cmd-test
docker run cmd-test echo "Override"  # Works

# ENTRYPOINT fixed, CMD can be overridden
docker run entrypoint-test
docker run entrypoint-test "Override"  # Appends to echo

📝 Practice Challenge

Create a Dockerfile for a static website:

    Use nginx:alpine base

    Copy custom HTML files

    Expose port 80

    Add health check

    Run as non-root user

✅ Success Criteria

    Can write basic Dockerfiles

    Understand layer caching

    Know difference between CMD and ENTRYPOINT

    Can optimize image size

    Can build and run custom images