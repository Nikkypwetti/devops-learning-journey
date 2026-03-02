# Docker Compose Configuration Cheatsheet

## SERVICE CONFIGURATION OPTIONS:

### Build Options:

build:
  context: ./dir
  dockerfile: Dockerfile.prod
  args:
    buildno: 1
    git_sha: ${GIT_SHA}
  cache_from:
    - alpine:latest
  labels:
    - "com.example.description=My app"
  shm_size: '2gb'
  target: builder

### Image Options:

image: nginx:alpine
image: myregistry.azurecr.io/nginx:v1.0
image: ${IMAGE_NAME}:${IMAGE_TAG}

### Container Options:

container_name: myapp
hostname: app.local
domainname: example.com
mac_address: 02:42:ac:11:65:43

### Ports:

ports:
  - "3000:3000"           # Host:Container
  - "40000-40010:40000"   # Port range
  - "127.0.0.1:8080:80"   # Specific IP
  - target: 80            # Long syntax
    published: 8080
    protocol: tcp
    mode: host

### Environment:

environment:
  - NODE_ENV=production
  - DATABASE_URL=postgres://user:pass@db:5432/db

env_file:
  - .env
  - .env.production
  - .env.${ENVIRONMENT}

### Volumes:

volumes:
  - /var/lib/mysql                    # Anonymous volume
  - ./data:/var/lib/mysql             # Bind mount
  - db-data:/var/lib/mysql            # Named volume
  - type: volume                      # Long syntax
    source: db-data
    target: /var/lib/mysql
    read_only: true
  - type: tmpfs
    target: /tmp
    tmpfs:
      size: 1000000000

### Networks:

networks:
  - frontend
  - backend

networks:
  frontend:
    aliases:
      - webapp
      - app.local
  backend:
    ipv4_address: 172.20.0.10
    ipam:
      config:
        - subnet: 172.20.0.0/16

### Depends On:

depends_on:
  db:
    condition: service_healthy
  redis:
    condition: service_started
  api:
    condition: service_completed_successfully

### Health Checks:

healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost/health"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 40s
  start_interval: 5s

### Restart Policies:

restart: "no"                    # Do not restart
restart: always                  # Always restart
restart: on-failure              # On failure
restart: unless-stopped          # Unless manually stopped

### Resource Limits:

deploy:
  resources:
    limits:
      cpus: '0.50'
      memory: 512M
    reservations:
      cpus: '0.25'
      memory: 256M

### Logging:

logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
    labels: "production_status"
    env: "os,customer"

### Secrets:

secrets:
  - db_password
  - source: app_secret
    target: app_secret
    mode: 0400

### Security:

security_opt:
  - no-new-privileges:true
  - seccomp:unconfined
  - apparmor:docker-default

cap_add:
  - NET_ADMIN
cap_drop:
  - ALL

read_only: true
tmpfs:
  - /tmp:rw,noexec,nosuid

### Devices:

devices:
  - "/dev/ttyUSB0:/dev/ttyUSB0"
  - host_device: "/dev/sda"
    container_device: "/dev/xvdc"
    permissions: "rwm"

### Extra Hosts:

extra_hosts:
  - "somehost:162.242.195.82"
  - "otherhost:50.31.209.229"

## NETWORK CONFIGURATION:

networks:
  frontend:
    driver: bridge
    driver_opts:
      com.docker.network.bridge.name: br-frontend
    ipam:
      driver: default
      config:
        - subnet: 172.20.0.0/16
          gateway: 172.20.0.1

  backend:
    driver: bridge
    internal: true
    attachable: true

  overlay:
    driver: overlay
    external: true

## VOLUME CONFIGURATION:

volumes:
  db-data:
    driver: local
    driver_opts:
      type: none
      device: ${PWD}/data
      o: bind

  cache:
    driver: local
    driver_opts:
      type: tmpfs
      device: tmpfs

## SECRETS CONFIGURATION:

secrets:
  db_password:
    file: ./secrets/db_password.txt
  ssl_cert:
    external: true
  api_key:
    environment: API_KEY

## COMPOSE FILE EXTENSIONS:

# docker-compose.yml (base)
# docker-compose.override.yml (development)
# docker-compose.prod.yml (production)

# Use multiple files:

docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

## ENVIRONMENT VARIABLES IN COMPOSE:

# In docker-compose.yml:
image: ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}

# Set in .env file:
REGISTRY=myregistry.azurecr.io
IMAGE_NAME=myapp
IMAGE_TAG=latest

# Override on command line:
IMAGE_TAG=v1.2.3 docker-compose up -d

🔗 Additional Resources
https://docs.docker.com/compose/compose-file/compose-file-v3/
https://docs.docker.com/compose/environment-variables/
https://docs.docker.com/compose/production/