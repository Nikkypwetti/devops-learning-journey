# Local Registry Setup

Command | Description
docker run -d -p 5000:5000 --name registry registry:2 | Spin up a private registry on your machine.
docker logs registry | Check if your local registry is running correctly.

## The Image Management Loop

Action | Command
Login | docker login <registry_url> (Leave blank for Docker Hub)
Tag | docker tag <source_image>:<tag> <registry_url>/<repo_name>:<tag>
Push | docker push <registry_url>/<repo_name>:<tag>
Pull | docker pull <registry_url>/<repo_name>:<tag>
Search | docker search <image_name> (Works primarily for Docker Hub)

## Cleanup & Maintenance

Command | Description
docker image prune | Remove all "dangling" (unused/untagged) images.
docker rmi $(docker images -q) | Nuclear Option: Delete all local images.
docker logout <registry_url> | Remove credentials from your local config.

## Real-World Examples

A. Pushing to Docker Hub (Public):
Bash

docker login
docker tag my-web-app:v1.0 nikky/my-web-app:v1.0
docker push nikky/my-web-app:v1.0

B. Pushing to Local Practice Registry:
Bash

docker tag nginx:latest localhost:5000/my-nginx:stable
docker push localhost:5000/my-nginx:stable

C. Pushing to AWS ECR (Professional/Cloud):
Bash

# Get login password from AWS CLI first
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com

# Tag and Push
docker tag my-app:latest <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com/my-app:v1.2.0
docker push <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com/my-app:v1.2.0

## Pro Tip: Inspecting your Registry

To see what images are actually inside your local registry (since it doesn't have a UI), use this curl command:
Bash

curl -X GET http://localhost:5000/v2/_catalog