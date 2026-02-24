check-env:
ifndef DOCKERHUB_USERNAME
	$(error DOCKERHUB_USERNAME is undefined. Please set it in your .env file)
endif

# Variables
DEV_COMPOSE = docker-compose.dev.yml
PROD_COMPOSE = docker-compose.yml
BACKEND_IMG = $(DOCKERHUB_USERNAME)/fullstack-backend:latest
FRONTEND_IMG = $(DOCKERHUB_USERNAME)/fullstack-frontend:latest

.PHONY: dev watch prod down clean nuclear pull scan scan-scout logs-backend

# --- DEVELOPMENT COMMANDS ---

dev:
	docker compose -f $(DEV_COMPOSE) up -d

watch: 
	docker compose -f $(DEV_COMPOSE) watch

# --- PRODUCTION COMMANDS ---

prod:
	docker compose -f $(PROD_COMPOSE) up -d --build

# Pull fresh images built by GitHub Actions (Critical for seeing 0 CVE updates!)
pull:
	docker compose -f $(PROD_COMPOSE) pull

# --- SECURITY COMMANDS (Day 16) ---

# Scan local backend image with Trivy
scan:
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
		-v $(HOME)/.cache:/root/.cache \
		aquasec/trivy:latest image $(BACKEND_IMG)

# Quick security report with Docker Scout
scan-scout:
	@echo "🔍 Running Security Audit for Backend..."
	docker scout quickview $(BACKEND_IMG)

# --- UTILITIES ---

down:
	docker compose -f $(DEV_COMPOSE) down
	docker compose -f $(PROD_COMPOSE) down

clean:
	docker compose -f $(DEV_COMPOSE) down -v
	docker compose -f $(PROD_COMPOSE) down -v
	docker system prune -f

nuclear:
	docker compose -f $(PROD_COMPOSE) down -v --remove-orphans
	docker builder prune -af
	docker compose -f $(PROD_COMPOSE) up -d --build --force-recreate

logs-backend:
	docker compose logs -f backend