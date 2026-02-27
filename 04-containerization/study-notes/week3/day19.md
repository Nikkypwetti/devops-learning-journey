Today, we move from building to running. In a professional DevOps environment, you don't wait for a user to report that the site is slow; you use Monitoring to see it happening in real-time.

1. Real-Time Resource Tracking (docker stats)

The docker stats command is your first line of defense. It provides a live stream of resource usage for all running containers.

    How to use it:
    Bash

    docker stats

    What to look for (The DevOps Checklist):

        CPU %: Is your backend spiking to 100% during a database query?

        MEM USAGE / LIMIT: Is your frontend slowly consuming more memory? (A sign of a memory leak).

        NET I/O: How much data is flowing between your frontend and backend?

        BLOCK I/O: High disk activity on your db container might mean you need to optimize your database indexes.

2. Advanced Insights with cAdvisor

While docker stats is great for quick checks, cAdvisor (Container Advisor) by Google is the professional choice for a detailed, visual overview. It is a running daemon that collects, aggregates, and exports data about your containers.
Why cAdvisor?

    Web UI: Provides historical graphs (last 60 seconds) that docker stats lacks.

    Detailed Metrics: It tracks sub-second spikes that you might miss in the CLI.

    Prometheus Ready: It’s the standard way to feed container data into advanced monitoring stacks like Prometheus and Grafana.

3. Practical Task: Applying to Your Fullstack Project

Let’s add cAdvisor to your existing docker-compose.yml so you can monitor your Frontend, Backend, and Database from a single dashboard.
Step 1: Update your docker-compose.yml

Add the cadvisor service. Note the volumes; cAdvisor needs access to the host’s Docker socket and system files to "see" the other containers.
YAML

services:
  # ... your existing db, backend, and frontend services ...

  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    container_name: cadvisor
    ports:
      - "8080:8080"
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:rw
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
    restart: always

Step 2: Access the Dashboard

    Run docker compose up -d.

    Open your browser and go to: http://localhost:8080.

    Click on "Docker Containers" to see the live CPU/Memory graphs for your fullstack-frontend and fullstack-backend.

4. Logging: The "Narrative" of Your App

Metrics tell you what is happening (High CPU); Logs tell you why it is happening.

    Follow Live Logs:
    Bash

docker logs -f fullstack-backend

Check Last 50 Lines (Debug Mode):
Bash

    docker logs --tail 50 fullstack-frontend

Professional Tip: Always use Structured Logging (JSON format) in your code. It makes it 10x easier for tools like ELK or Loki to parse your logs later in your DevOps journey.
Summary of Day 19 Learning
Tool | Best Used For... | Output Format
docker stats | Quick, real-time CLI check of all containers. | Terminal Table
cAdvisor | Visualizing resource trends and exporting metrics. | Web Dashboard / API
docker logs | Debugging application errors and tracking events. | Text Stream
Runtime Metrics | Understanding the underlying cgroup behavior. | System Files

Your Day 19 Mission: 1.  Deploy the cAdvisor service in your project.
2.  Trigger a "load" (refresh your frontend 20 times quickly) and watch the CPU graph in cAdvisor.
3.  Compare the memory usage of your optimized 62MB frontend vs. your 155MB backend.

It is time to peek under the hood! Since you have cAdvisor running, click on the "Processes" tab for your fullstack-app-frontend-1 container.
1. What a "Pro" Sees in the Processes Tab

In a perfectly hardened container like yours, you should see exactly two types of processes:

    The Master Process (root or nginx): This is the "boss" of Nginx. It reads the configuration and manages the workers.

    The Worker Processes (nginx): These are the "employees" that actually handle your HTTP requests.

Why this matters for Security:
If you ever see a process like /bin/sh or npm or python inside your Production Frontend container, that is a massive red flag. It means someone has either exec'd into your container or, worse, a hacker has injected a script. A clean process list is the sign of a secure, single-purpose container.