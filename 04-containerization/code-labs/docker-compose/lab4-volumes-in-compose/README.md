Lab 4: Volumes in Compose
🎯 Objective

Learn to manage persistent data using volumes in Docker Compose.
📚 Volume Types in Compose

    Named Volumes: Docker managed, persistent

    Bind Mounts: Map host directories

    Anonymous Volumes: Temporary, auto-named

🚀 Exercises
Exercise 1: Named Volumes

yaml

services:
  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD: secret
    volumes:
      - postgres-data:/var/lib/postgresql/data

volumes:
  postgres-data:

Exercise 2: Bind Mounts for Development
yaml

services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html:ro
      - ./nginx.conf:/etc/nginx/nginx.conf:ro

Create html/index.html and nginx.conf to test.
Exercise 3: Multiple Volumes
yaml

services:
  app:
    image: node:18-alpine
    working_dir: /app
    volumes:
      - ./src:/app/src:ro
      - app-node_modules:/app/node_modules
      - app-logs:/app/logs
    command: sh -c "touch /app/logs/app.log && ls -la /app"

volumes:
  app-node_modules:
  app-logs:

Exercise 4: Sharing Volumes Between Services
yaml

services:
  writer:
    image: alpine
    command: sh -c "while true; do date >> /data/timestamps.txt; sleep 5; done"
    volumes:
      - shared-data:/data
  
  reader:
    image: alpine
    command: sh -c "tail -f /data/timestamps.txt"
    volumes:
      - shared-data:/data:ro
    depends_on:
      - writer

volumes:
  shared-data:

Exercise 5: Volume Configuration Options
yaml

services:
  db:
    image: postgres:alpine
    volumes:
      # Named volume with driver options
      - type: volume
        source: db-data
        target: /var/lib/postgresql/data
        volume:
          nocopy: true
      
      # Bind mount with options
      - type: bind
        source: ./backups
        target: /backups
        bind:
          propagation: rshared
          create_host_path: true

volumes:
  db-data:
    driver: local
    driver_opts:
      type: nfs
      o: addr=10.0.0.1,rw
      device: ":/path/to/dir"

✅ Success Criteria

    Can create named volumes in Compose

    Can use bind mounts for development

    Understand sharing volumes between services

    Know volume configuration options