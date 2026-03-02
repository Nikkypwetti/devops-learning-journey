### **📘 Day 9: Compose File Structure**

```markdown
# Day 9: Compose File Structure

## 🎯 Learning Objectives
- Master docker-compose.yml syntax
- Configure services, networks, volumes
- Use environment variables
- Implement health checks

## 📚 Morning Resources (6:00-6:30 AM)
### Video Tutorial (15 mins):
- [**Docker Compose File Explained**](https://www.youtube.com/watch?v=DM65_JyGxCo) by Traversy Media
- **Alternative:** [**Docker Compose Tutorial**](https://www.youtube.com/watch?v=Qw9zlE3t8Ko) by TechWorld with Nana
- **Key Takeaways:**
  - Service definitions
  - Network configurations
  - Volume management

### Reading Material (10 mins):
- [Compose File Reference](https://docs.docker.com/compose/compose-file/)
- **Focus on:**
  - Service configuration options
  - Network types
  - Volume types

### Syntax Examples (5 mins):
```yaml
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.prod
      args:
        NODE_ENV: production
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgres://user:pass@db:5432/db
    depends_on:
      - db
      - redis
    networks:
      - backend
    volumes:
      - ./app:/app
      - app-logs:/var/log
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3

💻 Evening Practice (6:30-8:00 PM)
Project: Advanced Compose Configuration (75 mins)

# Create project directory
mkdir -p ~/docker-practice/day9
cd ~/docker-practice/day9

# Step 1: Create a complex docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  # Main application
  app:
    build:
      context: ./app
      dockerfile: Dockerfile
      args:
        NODE_ENV: ${NODE_ENV:-development}
    image: myapp:${APP_VERSION:-latest}
    container_name: ${APP_NAME:-webapp}
    hostname: ${APP_HOSTNAME:-app.local}
    ports:
      - "${APP_PORT:-3000}:3000"
    expose:
      - "3000"
    environment:
      - NODE_ENV=${NODE_ENV:-development}
      - DATABASE_URL=postgres://${DB_USER}:${DB_PASSWORD}@db:5432/${DB_NAME}
      - REDIS_URL=redis://redis:6379
      - APP_SECRET=${APP_SECRET}
    env_file:
      - .env
      - .env.local
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy
    networks:
      frontend:
        aliases:
          - webapp.local
      backend:
    volumes:
      - ./app:/app:ro
      - app-data:/data
      - /app/node_modules
    tmpfs:
      - /tmp:size=100m,mode=1777
    restart: unless-stopped
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
    healthcheck:
      test: ["CMD", "node", "healthcheck.js"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M
    secrets:
      - db_password
      - app_secret

  # Database
  db:
    image: postgres:15-alpine
    container_name: postgres_db
    environment:
      POSTGRES_DB: ${DB_NAME:-appdb}
      POSTGRES_USER: ${DB_USER:-postgres}
      POSTGRES_PASSWORD_FILE: /run/secrets/db_password
    volumes:
      - postgres-data:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - backend
    ports:
      - "${DB_PORT:-5432}:5432"
    restart: always
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER:-postgres}"]
      interval: 30s
      timeout: 10s
      retries: 3
    secrets:
      - db_password
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 1G

  # Redis cache
  redis:
    image: redis:7-alpine
    container_name: redis_cache
    command: redis-server --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis-data:/data
      - ./redis.conf:/usr/local/etc/redis/redis.conf
    networks:
      - backend
    ports:
      - "${REDIS_PORT:-6379}:6379"
    restart: always
    healthcheck:
      test: ["CMD", "redis-cli", "-a", "${REDIS_PASSWORD}", "ping"]
      interval: 30s
      timeout: 10s
      retries: 3

  # Nginx reverse proxy
  nginx:
    image: nginx:alpine
    container_name: nginx_proxy
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/conf.d:/etc/nginx/conf.d
      - ./ssl:/etc/nginx/ssl
      - ./logs/nginx:/var/log/nginx
    ports:
      - "80:80"
      - "443:443"
    networks:
      - frontend
    depends_on:
      - app
    restart: always

  # Monitoring (Prometheus)
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus_monitor
    volumes:
      - ./monitoring/prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus-data:/prometheus
    ports:
      - "9090:9090"
    networks:
      - backend
      - monitoring
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
      - '--storage.tsdb.retention.time=200h'
      - '--web.enable-lifecycle'

  # Grafana dashboard
  grafana:
    image: grafana/grafana:latest
    container_name: grafana_dashboard
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=${GRAFANA_PASSWORD:-admin}
      - GF_USERS_ALLOW_SIGN_UP=false
    volumes:
      - grafana-data:/var/lib/grafana
      - ./monitoring/dashboards:/etc/grafana/provisioning/dashboards
      - ./monitoring/datasources:/etc/grafana/provisioning/datasources
    ports:
      - "3001:3000"
    networks:
      - monitoring
    depends_on:
      - prometheus
    restart: always

  # Portainer for container management
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer_ui
    command: -H unix:///var/run/docker.sock
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer-data:/data
    ports:
      - "9000:9000"
    networks:
      - frontend
    restart: always

# Networks
networks:
  frontend:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
  backend:
    driver: bridge
    internal: true  # No external access
  monitoring:
    driver: bridge

# Volumes
volumes:
  postgres-data:
    driver: local
    driver_opts:
      type: none
      device: ${PWD}/data/postgres
      o: bind
  redis-data:
  prometheus-data:
  grafana-data:
  portainer-data:
  app-data:

# Secrets
secrets:
  db_password:
    file: ./secrets/db_password.txt
  app_secret:
    file: ./secrets/app_secret.txt
EOF

# Step 2: Create supporting files and directories
mkdir -p {app,nginx,monitoring/dashboards,monitoring/datasources,logs,data,secrets,ssl}

# Create .env file
cat > .env << 'EOF'
# Application
APP_NAME=myapp
APP_VERSION=1.0.0
APP_PORT=3000
APP_HOSTNAME=app.local
NODE_ENV=development
APP_SECRET=super_secret_key_here

# Database
DB_NAME=appdb
DB_USER=postgres
DB_PASSWORD=strong_password_here
DB_PORT=5432

# Redis
REDIS_PASSWORD=redis_password_here
REDIS_PORT=6379

# Monitoring
GRAFANA_PASSWORD=admin123
EOF

# Create .env.local for sensitive data
cat > .env.local << 'EOF'
# Local overrides (not committed to git)
APP_SECRET=local_dev_secret
DB_PASSWORD=local_dev_password
REDIS_PASSWORD=local_redis_password
EOF

# Create secrets
echo "strong_password_here" > secrets/db_password.txt
echo "super_secret_app_key" > secrets/app_secret.txt
chmod 600 secrets/*.txt

# Create app structure
cat > app/Dockerfile << 'EOF'
FROM node:18-alpine

ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}

WORKDIR /app

COPY package*.json ./

RUN if [ "$NODE_ENV" = "production" ]; then \
      npm ci --only=production; \
    else \
      npm ci; \
    fi

COPY . .

RUN chown -R node:node /app
USER node

EXPOSE 3000

CMD ["node", "server.js"]
EOF

cat > app/package.json << 'EOF'
{
  "name": "docker-compose-app",
  "version": "1.0.0",
  "description": "Docker Compose Demo App",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "pg": "^8.11.0",
    "redis": "^4.6.7",
    "dotenv": "^16.0.3"
  },
  "devDependencies": {
    "nodemon": "^2.0.22"
  }
}
EOF

cat > app/server.js << 'EOF'
const express = require('express');
const { Pool } = require('pg');
const redis = require('redis');
require('dotenv').config();

const app = express();
const port = process.env.PORT || 3000;

// Database connections
const pool = new Pool({
  connectionString: process.env.DATABASE_URL
});

const redisClient = redis.createClient({
  url: process.env.REDIS_URL
});

// Connect to Redis
redisClient.connect().catch(console.error);

// Middleware
app.use(express.json());

// Routes
app.get('/', (req, res) => {
  res.json({
    message: 'Docker Compose Demo App',
    container: process.env.HOSTNAME,
    node_env: process.env.NODE_ENV,
    timestamp: new Date().toISOString()
  });
});

app.get('/health', async (req, res) => {
  const healthcheck = {
    uptime: process.uptime(),
    message: 'OK',
    timestamp: Date.now(),
    checks: {}
  };

  try {
    // Check database
    await pool.query('SELECT 1');
    healthcheck.checks.database = 'healthy';
  } catch (error) {
    healthcheck.checks.database = 'unhealthy';
    healthcheck.message = 'Database connection failed';
  }

  try {
    // Check Redis
    await redisClient.ping();
    healthcheck.checks.redis = 'healthy';
  } catch (error) {
    healthcheck.checks.redis = 'unhealthy';
    healthcheck.message = 'Redis connection failed';
  }

  const isHealthy = Object.values(healthcheck.checks).every(v => v === 'healthy');
  const status = isHealthy ? 200 : 503;
  
  res.status(status).json(healthcheck);
});

app.get('/users', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM users LIMIT 10');
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/cache/:key', async (req, res) => {
  try {
    const value = await redisClient.get(req.params.key);
    res.json({ key: req.params.key, value });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/cache/:key', async (req, res) => {
  try {
    await redisClient.set(req.params.key, JSON.stringify(req.body));
    res.json({ message: 'Cached successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.listen(port, () => {
  console.log(`App running on port ${port} in ${process.env.NODE_ENV} mode`);
  console.log(`Container: ${process.env.HOSTNAME}`);
});
EOF

cat > app/healthcheck.js << 'EOF'
const http = require('http');

const options = {
  hostname: 'localhost',
  port: 3000,
  path: '/health',
  method: 'GET',
  timeout: 5000
};

const req = http.request(options, (res) => {
  if (res.statusCode === 200) {
    process.exit(0);
  } else {
    process.exit(1);
  }
});

req.on('error', () => {
  process.exit(1);
});

req.end();
EOF

# Create nginx configuration
mkdir -p nginx/conf.d
cat > nginx/nginx.conf << 'EOF'
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log main;

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;

    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied expired no-cache no-store private auth;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;

    include /etc/nginx/conf.d/*.conf;
}
EOF

cat > nginx/conf.d/app.conf << 'EOF'
upstream app_backend {
    server app:3000;
}

server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://app_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    location /health {
        proxy_pass http://app_backend/health;
        access_log off;
    }

    location /metrics {
        proxy_pass http://prometheus:9090;
    }

    location /grafana/ {
        proxy_pass http://grafana:3000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /portainer/ {
        proxy_pass http://portainer:9000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
EOF

# Create monitoring configuration
cat > monitoring/prometheus.yml << 'EOF'
global:
  scrape_interval: 15s
  evaluation_interval: 15s

alerting:
  alertmanagers:
    - static_configs:
        - targets:

rule_files:

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'app'
    static_configs:
      - targets: ['app:3000']

  - job_name: 'node'
    static_configs:
      - targets: ['node-exporter:9100']

  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']
EOF

cat > monitoring/datasources/prometheus.yml << 'EOF'
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: true
EOF

cat > monitoring/dashboards/dashboard.yml << 'EOF'
apiVersion: 1

providers:
  - name: 'default'
    orgId: 1
    folder: ''
    type: file
    disableDeletion: false
    updateIntervalSeconds: 10
    allowUiUpdates: true
    options:
      path: /etc/grafana/provisioning/dashboards
EOF

# Create init.sql for database
cat > init.sql << 'EOF'
-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create sample data
INSERT INTO users (username, email) VALUES
    ('alice', 'alice@example.com'),
    ('bob', 'bob@example.com'),
    ('charlie', 'charlie@example.com')
ON CONFLICT (username) DO NOTHING;

-- Create function to update timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger for updated_at
CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();
EOF

# Create redis configuration
cat > redis.conf << 'EOF'
bind 0.0.0.0
port 6379
timeout 0
tcp-keepalive 300
daemonize no
supervised no
pidfile /var/run/redis_6379.pid
loglevel notice
logfile ""
databases 16
always-show-logo no
set-proc-title yes
proc-title-template "{title} {listen-addr} {server-mode}"
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
dbfilename dump.rdb
dir ./
replica-serve-stale-data yes
repl-diskless-sync no
repl-diskless-sync-delay 5
repl-diskless-load disabled
repl-disable-tcp-nodelay no
replica-priority 100
acllog-max-len 128
lazyfree-lazy-eviction no
lazyfree-lazy-expire no
lazyfree-lazy-server-del no
replica-lazy-flush no
lazyfree-lazy-user-del no
oom-score-adj no
oom-score-adj-values 0 200 800
disable-thp yes
appendonly yes
appendfilename "appendonly.aof"
appendfsync everysec
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
aof-load-truncated yes
aof-use-rdb-preamble yes
lua-time-limit 5000
slowlog-log-slower-than 10000
slowlog-max-len 128
latency-monitor-threshold 0
notify-keyspace-events ""
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-size -2
list-compress-depth 0
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
hll-sparse-max-bytes 3000
stream-node-max-bytes 4096
stream-node-max-entries 100
activerehashing yes
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit replica 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60
hz 10
dynamic-hz yes
aof-rewrite-incremental-fsync yes
rdb-save-incremental-fsync yes
jemalloc-bg-thread yes
EOF

# Step 3: Build and run the application
echo "Building and starting the application..."
docker-compose build
docker-compose up -d

# Step 4: Verify services
echo "Checking service status..."
sleep 10  # Wait for services to start
docker-compose ps

echo "Testing application..."
curl http://localhost:80
curl http://localhost:80/health | jq .

echo "Access URLs:"
echo "- App: http://localhost"
echo "- Prometheus: http://localhost:9090"
echo "- Grafana: http://localhost:3001 (admin/admin123)"
echo "- Portainer: http://localhost:9000"
echo "- PostgreSQL: localhost:5432"
echo "- Redis: localhost:6379"

# Step 5: Test different Compose commands
echo "Testing Compose commands..."

# View logs
docker-compose logs --tail=10 app

# Execute commands in containers
docker-compose exec app node --version
docker-compose exec db psql --version

# Scale services (if needed)
# docker-compose up -d --scale app=3

# View resource usage
docker-compose top

# View configuration
docker-compose config

# Step 6: Create management scripts
cat > manage.sh << 'EOF'
#!/bin/bash

case "$1" in
    start)
        docker-compose up -d
        ;;
    stop)
        docker-compose stop
        ;;
    restart)
        docker-compose restart
        ;;
    logs)
        docker-compose logs -f
        ;;
    status)
        docker-compose ps
        ;;
    rebuild)
        docker-compose down
        docker-compose build --no-cache
        docker-compose up -d
        ;;
    clean)
        docker-compose down -v --rmi all
        ;;
    shell)
        docker-compose exec app sh
        ;;
    update)
        docker-compose pull
        docker-compose up -d
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|logs|status|rebuild|clean|shell|update}"
        exit 1
esac
EOF

chmod +x manage.sh

# Step 7: Create a simple Makefile
cat > Makefile << 'EOF'
.PHONY: help start stop restart logs status rebuild clean shell update test

help:
	@echo "Available commands:"
	@echo "  make start     - Start all services"
	@echo "  make stop      - Stop all services"
	@echo "  make restart   - Restart all services"
	@echo "  make logs      - View logs (follow)"
	@echo "  make status    - Check service status"
	@echo "  make rebuild   - Rebuild and restart"
	@echo "  make clean     - Remove all containers and volumes"
	@echo "  make shell     - Open shell in app container"
	@echo "  make update    - Pull latest images and restart"
	@echo "  make test      - Run tests"

start:
	docker-compose up -d

stop:
	docker-compose stop

restart:
	docker-compose restart

logs:
	docker-compose logs -f

status:
	docker-compose ps

rebuild:
	docker-compose down
	docker-compose build --no-cache
	docker-compose up -d

clean:
	docker-compose down -v --rmi all

shell:
	docker-compose exec app sh

update:
	docker-compose pull
	docker-compose up -d

test:
	docker-compose exec app npm test
EOF

📚 Daily Learning Note: Day 9

Topic: Docker Compose File Structure

1. 📺 Video Key Takeaways

Link: NetworkChuck - Docker Compose

    The "One Command" Power: Docker Compose is a tool for defining and running multi-container applications. It replaces long, manual docker run commands with a single yaml file.

    Indentation Matters: YAML is sensitive to spaces. Services, networks, and volumes must be perfectly aligned for the file to be valid.

    Lifecycle Management: Commands like up -d (start) and down (cleanup) manage the entire stack's life.

    Naming Convention: By default, Compose uses the directory name as a prefix for all containers and networks it creates.

2. 📖 Reading Highlights

Link: Docker Compose File Reference

    Services Block: Defines the configuration for each container (Image, Ports, Environment, Build).

    Networks Block: Defines how containers talk to each other. Using internal: true prevents outside access to sensitive containers like databases.

    Volumes Block: Defines persistent storage. Named volumes are preferred over bind mounts for database data.

    Depends_on: Controls the startup order. Using the condition: service_healthy flag is the pro way to wait for a DB to be ready.

3. 🛠️ Practice: Hands-on Implementation

Project Application: 3-Tier Portfolio App

To master Day 9, apply these changes to your project structure:

    Network Isolation: * Create a frontend-nw (Public) and a backend-nw (Private).

        Move the db into backend-nw only.

    Security (The .env file):

        Remove hardcoded passwords from docker-compose.yml.

        Reference them as ${DB_USER} and ${DB_PASSWORD}.

    File Organization:

        Create a backups/ folder.

        Save your Day 8 file as backups/docker-compose.v8.yml.

4. 📝 Personal Progress Check

    [ ] Can I explain why the database doesn't need ports: mapped to the host anymore?

    [ ] Does my docker compose ps show the database as (healthy)?

    [ ] Does my .env file successfully pass secrets to the containers?

Day 9: Compose File Structure
What I Learned

    Service Granularity: I learned that a Compose file is a collection of "Services" that represent individual containers. Each service can have its own specific build context, networking, and security settings.

    Network Isolation: By defining custom networks (frontend vs. backend), I can prevent the database from being exposed to the public internet while still allowing the backend to communicate with it.

    Persistence with Named Volumes: Using named volumes instead of just paths ensures that MongoDB data is managed by Docker and persists even if I run docker compose down.

    Environment Variable Integration: I learned how to use a .env file to store sensitive data like DB_PASSWORD, keeping the main docker-compose.yml clean and safe for GitHub.

Commands Practice
Bash

# 1. Back up the old version
mkdir -p backups && cp docker-compose.yml backups/docker-compose.v8.yml

# 2. Start the isolated stack
docker compose up -d --build

# 3. Check network connectivity
docker network inspect three-tier-app-configuration_backend-nw

# 4. Total cleanup (including volumes)
docker compose down -v

Containers Created

    three-tier-app-configuration-db-1 - Purpose: Persistent MongoDB storage, isolated from public access.

    three-tier-app-configuration-backend-1 - Purpose: Node.js API that acts as a bridge between the frontend and the database.

    three-tier-app-configuration-frontend-1 - Purpose: Nginx server serving the UI to the user on Port 80.

Dockerfile Written (Backend)
Dockerfile

FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3001
CMD ["node", "index.js"]

Challenges

    Problem: The depends_on syntax failed because of a dash formatting error (-db instead of db).

    Solution: Corrected the YAML indentation and removed the dash to properly reference the service name.

    Problem: The "Reset" button was incrementing the database to 1 instead of 0.

    Solution: Refactored the backend logic to separate the "status check" (GET) from the "visit log" (POST).

Resources

    Video Tutorial: NetworkChuck - Docker Compose

    Documentation: Docker Compose File Reference

Tomorrow's Plan

    Introduction to Kubernetes (K8s): Moving from Compose to Cluster orchestration.

    Minikube Setup: Getting a local K8s environment running on the EliteBook.

Day 9: Compose File Structure
What I Learned

    Network Segregation: I learned how to separate "public" traffic (Frontend) from "private" traffic (Database) using multiple user-defined networks in one file.

    Service Health Checks: I discovered how to use healthcheck to make the Backend wait until MongoDB is truly ready to accept connections, not just "started."

    Internal Networks: I used the internal: true flag to ensure my database has zero visibility to anything outside the Docker network.

    YAML Mapping: I practiced mapping environment variables from a .env file into the container runtime, allowing for dynamic configuration without changing the code.

Commands Practice
Bash

# 1. Back up the old version to see progress
mkdir -p backups && cp docker-compose.yml backups/docker-compose.v8.yml

# 2. Check if the .env variables are being picked up
docker compose config

# 3. Start the professional-grade stack
docker compose up -d --build

# 4. Confirm the DB is isolated (should show no ports)
docker compose ps

Containers Created

    three-tier-app-configuration-db-1 - Purpose: Secured MongoDB instance sitting on an internal-only backend network.

    three-tier-app-configuration-backend-1 - Purpose: The bridge API that connects to both networks to pass data safely.

    three-tier-app-configuration-frontend-1 - Purpose: The public-facing entry point serving the UI on Port 80.

Dockerfile Written (Frontend)
Dockerfile

FROM nginx:alpine
# Copy our custom HTML to the default Nginx location
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80

Challenges

    Problem: Encountered tls: bad record MAC during build due to network instability.

    Solution: Used docker builder prune -f and retried the build to ensure fresh, uncorrupted layers were pulled.

    Problem: The depends_on syntax error was causing the project to be "invalid."

    Solution: Reformatted the YAML to remove the illegal dash - prefix before the service name when using the condition attribute.

Resources

    Video Tutorial: NetworkChuck - Docker Compose

    Documentation: Docker Compose File Reference

Day 9: Compose File Structure (Consolidated)
What I Learned

    Microservices Architecture: I learned that a professional docker-compose.yml is a blueprint for an entire ecosystem. It allows for the orchestration of frontend, backend, and database services as a single unit.

    Network Isolation & "Zero-Trust": I implemented a dual-network strategy. By creating a private backend-nw and a public frontend-nw, I ensured that the database is completely hidden from the host and the internet, accessible only by the backend.

    Internal DNS & Service Discovery: I discovered that containers within a Compose network don't need IP addresses to talk; they use the Service Name (e.g., http://backend:3001) via Docker's internal DNS.

    Service Health Synchronization: I mastered the use of healthcheck paired with depends_on. This ensures the Backend waits until MongoDB is "Healthy" (responding to pings) before it attempts to connect, preventing startup crashes.

    Environment Variable Security: I practiced using a .env file to inject secrets (DB_USER, DB_PASSWORD) into the containers, keeping my main code safe for GitHub.

    CI/CD & Versioning: I learned how to link my local development to GitHub Actions, implementing a multi-tagging strategy (latest, v17, and Git-SHA) to track releases on Docker Hub.

    Maintenance & Pruning: I practiced analyzing disk usage with docker system df and learned the difference between Anonymous volumes (removable via prune) and Named volumes (protected by Docker).

Commands Practice
Bash

# --- Deployment & Syncing ---
# Pull the verified images from Docker Hub (nikkytechies account)
docker compose pull

# Start the stack and recreate containers with the newest images
docker compose up -d

# --- Verification & Security ---
# Test the 'Healthy' status and port mappings
docker compose ps

# Verify internal connectivity from the frontend container
docker compose exec frontend curl http://backend:3001/status

# Confirm network isolation (This SHOULD fail from the host)
curl localhost:3001/status

# --- Storage Cleanup ---
# Reclaim space from unused images and networks
docker system prune -a

# Specifically remove orphaned volumes to save disk space
docker volume prune

Containers Created

    three-tier-app-configuration-db-1 Purpose: Secured MongoDB storage.

    Network: backend-nw (Isolated).

    Volume: three-tier-app-configuration_mongo_data.

    three-tier-app-configuration-backend-1 Purpose: Node.js API logic.

    Network: Bridge (Connected to both backend-nw and frontend-nw).

    Version: nikkytechies/fiddly-backend:latest (Synced with v17).

    three-tier-app-configuration-frontend-1 Purpose: Nginx UI server.

    Network: frontend-nw.

    Ports: Exposed on 80:80 for public access.

Dockerfiles Used
Backend (/backend/Dockerfile)
Dockerfile

FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3001
CMD ["node", "index.js"]

Frontend (/frontend/Dockerfile)
Dockerfile

FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80

Challenges

    Naming Conventions: Encountered Access Denied and Manifest Unknown errors.

    Solution: Identified a typo in the username (nikky-techies vs nikkytechies) and the tag name (vlatest vs latest). Standardized the namespace across all files.

    Host Connectivity: curl failed when hitting Port 3001 from the laptop.

    Solution: Validated that this is a security feature of the "Zero-Trust" network design. Verified internal connectivity using docker compose exec.

    Space Management: The HP EliteBook showed 1.8GB of reclaimable volume space.

    Solution: Used docker volume prune to remove anonymous volumes while preserving named volumes for future projects.

    GitHub Action Tags: Docker Hub initially only showed the latest tag.

    Solution: Updated the main.yml workflow to include a list of tags: ${{ github.sha }} and v${{ github.run_number }}.

Resources

    Video Tutorial: NetworkChuck - Docker Compose tutorial

    Reading: Docker Compose Networking & Volumes Documentation

    Documentation: Docker Hub Repository Management