# Cloud & DevOps Engineering Labs

A hands-on repository documenting my work across **cloud infrastructure, containerization, CI/CD, networking, Linux and infrastructure automation**.

My current professional focus is Operations, RevOps, CRM and Business Systems. This repository demonstrates the technical depth I bring to automation, integrations, system troubleshooting and infrastructure-oriented work.

## Featured Engineering Projects

### Real-Time Microservices Voting System

A distributed application built around multiple services and orchestrated with Docker Swarm.

**Stack**

- Docker Swarm
- Nginx
- Redis
- PostgreSQL
- Python / Flask
- .NET / C#
- Node.js
- Next.js / React
- GitHub Actions
- Trivy

**What I implemented**

- Multi-service container orchestration
- Redis-based message processing
- PostgreSQL persistence
- Docker Swarm Secrets for database credentials
- Frontend and backend network isolation
- Nginx reverse proxy configuration
- WebSocket proxying for real-time result updates
- Container health checks
- GitHub Actions multi-service builds
- Trivy vulnerability scanning
- Image tagging with Git commit SHAs

➡️ [View the project](./04-containerization/projects/microservices/voting-app-project)

---

### Enterprise 3-Tier Containerized Application

A containerized full-stack application structured across frontend, backend and database layers.

**Stack**

- React
- Node.js / Express
- PostgreSQL
- Nginx
- Docker
- Docker Compose
- GitHub Actions

**What it demonstrates**

- Multi-container application architecture
- Development and production environment separation
- Reverse proxy configuration
- Persistent database storage
- Container networking
- Automated build workflows

➡️ [View the project](./04-containerization/projects/fullstack-app)

---

### AWS Infrastructure & Terraform

My cloud infrastructure work also includes dedicated AWS repositories covering networking, compute, databases, availability and Infrastructure as Code.

#### AWS Multi-Tier Infrastructure with Terraform

Terraform-based AWS architecture using:

- VPC
- Public and private subnets
- EC2
- RDS
- IAM
- Security Groups

➡️ https://github.com/Nikkypwetti/aws-terraform-multi-tier-app

#### AWS High-Availability Web Architecture

Multi-AZ AWS environment using:

- Application Load Balancer
- Auto Scaling Groups
- EC2
- RDS Multi-AZ
- VPC networking
- Private application and database layers

➡️ https://github.com/Nikkypwetti/aws-ha-webapp

## Technical Areas

### Cloud & Infrastructure

- AWS
- EC2
- VPC
- RDS
- IAM
- Application Load Balancer
- Auto Scaling

### Infrastructure as Code

- Terraform
- Variable-driven infrastructure
- Reusable resource configuration

### Containers

- Docker
- Docker Compose
- Docker Swarm
- Multi-container architecture
- Persistent volumes
- Container networking

### CI/CD & Security

- GitHub Actions
- Automated container builds
- Trivy image scanning
- Git-based versioning and tagging

### Systems & Networking

- Linux
- Bash
- Nginx
- Reverse proxying
- WebSockets
- Public/private network design

### Data Services

- PostgreSQL
- Redis

## Repository Structure

```text
01-cloud-foundations/
02-linux-networking/
03-infrastructure-as-code/
04-containerization/
05-kubernetes/
06-ci-cd-monitoring/
