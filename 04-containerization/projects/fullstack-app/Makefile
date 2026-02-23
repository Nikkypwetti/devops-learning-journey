check-env:
ifndef DOCKERHUB_USERNAME
	$(error DOCKERHUB_USERNAME is undefined. Please set it in your .env file)
endif

# Variables
DEV_COMPOSE = docker-compose.dev.yml
PROD_COMPOSE = docker-compose.yml

.PHONY: dev watch prod build-prod down clean logs-backend

# --- DEVELOPMENT COMMANDS ---

# Start development environment
dev:
	docker compose -f $(DEV_COMPOSE) up -d

# Start development with Hot Reload (Watch mode)
watch: 
	docker compose -f $(DEV_COMPOSE) watch

# --- PRODUCTION COMMANDS ---

# Build and start production (Nginx) environment
prod:
	docker compose -f $(PROD_COMPOSE) up -d --build

# --- UTILITIES ---

# Stop all containers
down:
	docker compose -f $(DEV_COMPOSE) down
	docker compose -f $(PROD_COMPOSE) down

# Full cleanup (removes volumes - use with caution!)
clean:
	docker compose -f $(DEV_COMPOSE) down -v
	docker system prune -f

# Follow backend logs
logs-backend:
	docker compose logs -f backend