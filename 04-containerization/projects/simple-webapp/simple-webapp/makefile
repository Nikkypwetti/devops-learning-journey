# Variables
IMAGE_NAME=nikkytechies/simple-webapp
TAG=latest
CLUSTER=simple-webapp-cluster
SERVICE=webapp-service

.PHONY: build push deploy all clean

# Build the Docker image
build:
	docker build -t $(IMAGE_NAME):$(TAG) .

# Push to Docker Hub
push:
	docker push $(IMAGE_NAME):$(TAG)

# Force AWS to pull the new image
deploy-aws:
	aws ecs update-service --cluster $(CLUSTER) --service $(SERVICE) --force-new-deployment --profile learning
	aws ecs wait services-stable --cluster $(CLUSTER) --services $(SERVICE)
	@echo "🚀 Deployment complete! Check your ALB URL."

# Do everything in one command
deploy: build push deploy-aws

# Clean up local images to free space
clean:
	docker rmi $(IMAGE_NAME):$(TAG)