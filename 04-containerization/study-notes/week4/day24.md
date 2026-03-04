📝 My Nginx + Docker Study Notes - Day 24
🎯 What I'm Learning Today

Topic: Using Nginx as a Reverse Proxy with Docker
📌 First Things First - What is Nginx?

Think of Nginx as a smart traffic controller for web applications. It can do lots of jobs:

    Serve websites (like showing HTML pages)

    Act as a middleman between users and my apps (this is the reverse proxy thing!)

    Spread out traffic so no single server gets overwhelmed

    Remember responses to make things faster (caching)

🐳 Getting Started with Nginx in Docker
The Easy Way - Running My First Container

I learned that the official Nginx image is like a trusted recipe - it follows best practices!

Basic command to run Nginx:
bash

docker run --name my-nginx -d nginx

This just runs it, but I can't access it from my browser yet...
Making It Accessible - Port Mapping
bash

docker run --name my-nginx -p 8080:80 -d nginx

What this means: Traffic on my computer's port 8080 goes to the container's port 80. Now I can visit http://localhost:8080
Serving My Own Files

Instead of the default Nginx page, I want my own content:
bash

docker run --name my-site -v /my/computer/files:/usr/share/nginx/html:ro -p 8080:80 -d nginx

Key points I noted:

    -v mounts my files into the container

    :ro means "read-only" - good for security

    The container looks for files in /usr/share/nginx/html

⚙️ Customizing Nginx Configuration

This is where it gets interesting! There are two ways to do this:
Method 1: Quick and Dirty (Mounting Config)

Step 1 - Get the default config so I can edit it:
bash

docker run --rm --entrypoint=cat nginx /etc/nginx/nginx.conf > ~/my-nginx.conf

(--rm cleans up after itself, --entrypoint=cat just prints the file)

Step 2 - Edit the file (I'll need to learn nginx config syntax later)

Step 3 - Run with my config:
bash

docker run --name my-custom-nginx -v ~/my-nginx.conf:/etc/nginx/nginx.conf:ro -d nginx

Method 2: The Professional Way (Building an Image)

This is better because I can share it with others!

Create a file called Dockerfile:
dockerfile

FROM nginx
COPY my-nginx.conf /etc/nginx/nginx.conf

Build and run:
bash

docker build -t my-custom-nginx .
docker run --name my-custom-nginx -d my-custom-nginx

🚀 Cool Trick: Using Environment Variables

This blew my mind! Since Nginx 1.19, I can use variables in config files.

1. Create a template file default.conf.template:
nginx

server {
    listen       ${MY_PORT};
    server_name  ${MY_DOMAIN};
    # rest of config...
}

2. Run the container with variables:
bash

docker run -p 8080:80 \
  -v ./templates:/etc/nginx/templates \
  -e MY_PORT=80 \
  -e MY_DOMAIN=example.com \
  -d nginx

Why this is awesome: I can use the same config for development (localhost) and production (myrealdomain.com) just by changing variables!
🔒 Security Stuff I Need to Remember
Running in Read-Only Mode (Super Secure)
bash

docker run -d -p 80:80 --read-only \
  -v nginx-cache:/var/cache/nginx \
  -v nginx-pid:/var/run \
  nginx

Why: The container's filesystem is read-only except for places where Nginx absolutely needs to write
Running as Non-Root User

By default, Nginx creates worker processes as user nginx (UID 101). If I want to run the whole container as a different user, I need to:

    Change these in my config:

nginx

pid        /tmp/nginx.pid;

http {
    client_body_temp_path /tmp/client_temp;
    proxy_temp_path       /tmp/proxy_temp_path;
    # ... other temp paths
}

🐛 Debugging Tips

When things go wrong:

Run in debug mode:
bash

docker run --name debug-nginx -v ./nginx.conf:/etc/nginx/nginx.conf:ro -d nginx nginx-debug -g 'daemon off;'

Quiet the startup logs:
bash

docker run -d -e NGINX_ENTRYPOINT_QUIET_LOGS=1 nginx

📦 Different Flavors of Nginx Images

I have choices depending on my needs:
Tag	When to Use	Size
nginx:latest	General purpose, not sure what to pick	~70MB
nginx:alpine	When size matters (tiny!)	~23MB
nginx:perl	If I need Perl scripting	~80MB
nginx:slim	Minimal Debian-based	~40MB
🛠️ My Practice Plan
Task 1: Static Website
bash

# Create my content
mkdir ~/my-website
echo "<h1>My First Docker Nginx Site</h1>" > ~/my-website/index.html

# Run it
docker run --name practice-site \
  -v ~/my-website:/usr/share/nginx/html:ro \
  -p 8888:80 \
  -d nginx

# Test: Open browser to http://localhost:8888

Task 2: Simple Reverse Proxy Setup

Goal: Make Nginx forward requests to another container

    Run a simple web app container (like a basic Python server)

    Configure Nginx to proxy requests to it

    Test that visiting Nginx shows the app's content

Config idea for reverse proxy:
nginx

server {
    listen 80;
    location / {
        proxy_pass http://my-app-container:5000;
        proxy_set_header Host $host;
    }
}

📝 Key Takeaways

    Nginx in Docker is just like regular Nginx but packaged neatly

    Mounting files is my friend for development

    Building custom images is better for production

    Environment variables make configs flexible

    Security matters - use read-only mounts and proper user permissions

❓ Questions I Still Have

    How do I make Nginx reload config without restarting the container?

    What's the best way to handle SSL certificates?

    How do I connect multiple containers with Nginx as the entry point?

## Note to self: Come back and add more details about actual reverse proxy configs once I watch the video

## Note i jotte down while watching the video and reading the docs.

🗒️ My Study Notes: Day 24 – Nginx Reverse Proxy

1. What actually is a Reverse Proxy? (The "Big Picture")

I used to get confused between a Forward and Reverse proxy. Here is the easy way to remember:

    Forward Proxy: Hides the Client (Me ➡️ Proxy ➡️ Internet). Like a VPN.

    Reverse Proxy: Hides the Server (Internet ➡️ Proxy ➡️ Backend Apps).

        Real-world analogy: It’s like a receptionist at a big company. You talk to the receptionist; you don't go wandering through the back offices yourself.

2. Why do we bother with this in DevOps?

    Security: My backend apps (Node, Python, Go) are exposed only to Nginx, not the whole internet.

    One Port to Rule Them All: I can have 10 different apps running on different internal ports, but the user only sees Port 80 or 443.

    SSL Termination: I don't want to configure SSL/TLS on every single app. I do it once on Nginx, and it talks "plain HTTP" to the backends internally.

3. Deep Dive: The proxy_pass Directive

This is the "magic" line. It tells Nginx: "If someone hits this URL, go grab the data from here."

The basic setup in default.conf:
Nginx

location /app1 {
    proxy_pass http://127.0.0.1:5000;  # The internal address of my app
}

⚠️ Pro Tip: Don't forget the Headers!
If I just use proxy_pass, the backend app thinks the request came from Nginx (the proxy's IP). To make sure the app knows the real user's IP, I must add:

    proxy_set_header Host $host;

    proxy_set_header X-Real-IP $remote_addr;

4. Nginx + Docker (The Modern Way)

In production, I'm not installing Nginx on the OS. I'm running it in a container.

The "DevOps Workflow" for this:

    Pull the image: docker pull nginx:alpine (Alpine is smaller and faster).

    Write the config: Create a my-nginx.conf locally.

    Mount it: Map my local config into the container's config folder.

Docker Compose is my best friend here:
YAML

services:
  my-api:
    image: my-python-api:v1
    # No ports mapped here! It stays private.

  proxy:
    image: nginx:alpine
    ports:
      - "80:80"  # Public port
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      - my-api

Note: In the Nginx config, I can now use proxy_pass http://my-api:8000; because Docker handles the DNS for service names!
5. Troubleshooting Checklist (When it breaks)

    Check Syntax: Run nginx -t inside the container. If there's a missing semicolon, it will tell me exactly where.

    Check Logs: docker logs <nginx_container_name> is the first place to look.

    502 Bad Gateway: This usually means Nginx is working, but it can't "see" the backend app. Is the app container running? Are they on the same Docker network?

✅ Next Steps to "Perfect" This:

    Load Balancing: Try adding an upstream block to send traffic to two app containers instead of one.

    Custom Errors: Create a pretty 404.html and tell Nginx to serve it.