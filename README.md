# Cloud, DevOps & Infrastructure Engineering Portfolio

Hands-on engineering portfolio covering **AWS infrastructure, Terraform, Packer, Ansible, Docker, container security, CI/CD, Linux networking and Kubernetes**.

This repository brings together project builds, infrastructure labs, automation workflows and technical documentation created while developing practical Cloud and DevOps engineering skills.

My broader professional focus is **Operations, RevOps, CRM and Business Systems**. The projects here demonstrate the technical depth I bring to automation, integrations, infrastructure, troubleshooting and system design.

---

## Portfolio Snapshot

| Area | Evidence in This Repository |
| --- | --- |
| Infrastructure as Code | 4 project folders covering Terraform-based AWS infrastructure |
| Container Engineering | 5 project folders covering Docker, Docker Compose and Docker Swarm |
| Container Security | 5 focused security labs |
| Kubernetes | Manifests for Pods, Deployments, Services, ConfigMaps, Secrets and Ingress |
| CI/CD | 12 GitHub Actions workflow files |
| Systems & Networking | Bash tooling, AWS VPC labs, DNS troubleshooting and connectivity diagnostics |

---

## Engineering Project Index

| Project | Engineering Focus | Core Technologies |
| --- | --- | --- |
| [Automated Golden AMI Pipeline](./03-infrastructure-as-code/projects/golden-ami-pipeline) | Immutable infrastructure, image automation, configuration management and monitoring | AWS, Packer, Ansible, Terraform, GitHub Actions, CloudWatch, SNS |
| [Terraform Three-Tier Application](./03-infrastructure-as-code/projects/three-tier-app) | Modular AWS infrastructure with separated application tiers | Terraform, AWS, VPC, ALB, Compute, RDS, Security Groups |
| [Static Website Infrastructure](./03-infrastructure-as-code/projects/static-website-project) | Reusable Terraform module for AWS-hosted static content | Terraform, AWS, S3, CloudFront |
| [VPC Infrastructure](./03-infrastructure-as-code/projects/vpc-infrastructure) | Reusable AWS networking infrastructure | Terraform, AWS VPC, public subnets |
| [Real-Time Microservices Voting System](./04-containerization/projects/microservices/voting-app-project) | Distributed services, message processing, real-time results and container orchestration | Docker Swarm, Redis, PostgreSQL, Python, .NET, Node.js, Next.js, Nginx |
| [Multi-Tier Containerized Full-Stack App](./04-containerization/projects/fullstack-app) | Private container networking, reverse proxying, persistent data and image automation | React, Node.js, Express, PostgreSQL, Nginx, Docker Compose, GitHub Actions |
| [Container Security Labs](./04-containerization/code-labs/container-security) | Vulnerability scanning, non-root containers, secrets, read-only filesystems and security benchmarks | Docker, Docker Scout, security hardening, Bash |
| [Secure Container Build & Scan](./04-containerization/projects/production-ready) | Image build validation, high/critical vulnerability checks and non-root execution verification | Docker, Docker Scout, Bash |
| [Linux & Network Automation Labs](./02-linux-networking/code-labs) | AWS VPC automation, DNS troubleshooting, network scanning and connectivity diagnostics | Linux, Bash, AWS networking |
| [Kubernetes Labs](./05-kubernetes) | Core orchestration resources and local Kubernetes practice | Kubernetes, Minikube, kubectl, Pods, Deployments, Services, ConfigMaps, Secrets, Ingress |

---

## Featured Project: Automated Golden AMI Pipeline

A multi-tool infrastructure automation project that builds versioned Amazon Machine Images and deploys them through an Infrastructure as Code workflow.

### Engineering work demonstrated

- Configured **Packer** to build versioned AMIs.
- Used **Ansible** for operating-system configuration and Nginx setup.
- Used **Ansible Vault** for encrypted configuration data.
- Connected the image workflow to **Terraform** for infrastructure deployment.
- Used **IAM roles and instance profiles** for AWS service access.
- Added dynamic SSH source-IP handling through Bash and Terraform.
- Added **CloudWatch dashboards** and **SNS alarms** for monitoring.
- Automated the Packer build through **GitHub Actions**.
- Added proof-of-work screenshots for pipeline execution, AMI artifacts and monitoring.

[Explore the Golden AMI project →](./03-infrastructure-as-code/projects/golden-ami-pipeline)

---

## Featured Project: Real-Time Microservices Voting System

A distributed voting application split across multiple services and orchestrated with Docker Swarm.

### Architecture

```text
User
  ↓
Vote UI / Python API
  ↓
Redis
  ↓
.NET Worker
  ↓
PostgreSQL
  ↓
Node.js Result Service
  ↓
WebSocket Updates
  ↓
Result UI
```

### Engineering work demonstrated

- Multi-service orchestration with **Docker Swarm**.
- Redis-based message ingestion.
- Background vote processing with **.NET/C#**.
- Persistent vote storage with **PostgreSQL**.
- **Docker Swarm Secrets** for database credentials.
- Frontend/backend network separation.
- **Nginx** reverse proxy configuration.
- WebSocket upgrade handling for live result updates.
- GitHub Actions multi-service image builds.
- **Trivy** scanning for critical image vulnerabilities.
- Image tagging using Git commit SHAs.

[Explore the Microservices Voting System →](./04-containerization/projects/microservices/voting-app-project)

---

## Featured Project: Multi-Tier Containerized Full-Stack Application

A full-stack application split across frontend, API and database layers with Docker-based environment management.

### Architecture

```text
Browser
  ↓
React / Nginx
  ↓
Node.js / Express API
  ↓
PostgreSQL
```

### Engineering work demonstrated

- Multi-container architecture with **Docker Compose**.
- Private backend and database networking.
- Nginx reverse proxy routing.
- PostgreSQL persistent volumes.
- Multi-stage Docker builds.
- Development and production configuration separation.
- GitHub Actions image-build workflows.
- Git SHA image versioning.
- Docker Compose Watch for development feedback loops.

[Explore the Containerized Full-Stack App →](./04-containerization/projects/fullstack-app)

---

## Featured Project: Terraform Three-Tier Application

A modular Terraform project that separates infrastructure into reusable networking, load-balancing, compute and database components.

### Terraform modules

```text
three-tier-app/
├── modules/
│   ├── vpc/
│   ├── alb/
│   ├── compute/
│   └── database/
└── root configuration
```

### Engineering work demonstrated

- Reusable Terraform modules.
- AWS provider configuration.
- VPC infrastructure.
- Application Load Balancer layer.
- Compute layer.
- Database layer.
- Separate security groups for ALB, application and database tiers.
- Security-group rules controlling traffic between application layers.
- Terraform inputs and outputs.
- Generated Terraform documentation.

[Explore the Terraform Three-Tier App →](./03-infrastructure-as-code/projects/three-tier-app)

---

## Container Security Work

The container-security section contains focused labs covering:

- Vulnerability scanning
- Non-root container execution
- Secrets management
- Read-only filesystems
- Docker security benchmarks

The secure container build project also includes a Bash validation workflow that builds an image, checks **high and critical vulnerabilities with Docker Scout**, verifies that the container does not run as root and reports image size.

[Explore Container Security Labs →](./04-containerization/code-labs/container-security)

---

## Linux & Networking Work

The Linux and networking section includes practical automation and troubleshooting work such as:

- AWS VPC creation labs
- Bash scripting
- DNS troubleshooting
- Network scanning
- Connectivity diagnostics
- Networking study material and command references

[Explore Linux & Networking →](./02-linux-networking)

---

## Kubernetes Work

Kubernetes practice currently includes manifests and learning material for:

- Pods
- Deployments
- Services
- ConfigMaps
- Secrets
- Ingress
- Minikube and kubectl workflows

[Explore Kubernetes →](./05-kubernetes)

---

## CI/CD Automation

This repository contains GitHub Actions workflows for infrastructure and application delivery, including:

| Workflow | Focus |
| --- | --- |
| [`packer-build.yml`](./.github/workflows/packer-build.yml) | Golden AMI image automation |
| [`microservices.yml`](./.github/workflows/microservices.yml) | Multi-service container builds and security scanning |
| [`fullstack-app.yml`](./.github/workflows/fullstack-app.yml) | Full-stack container workflow |
| [`terraform-test.yml`](./.github/workflows/terraform-test.yml) | Terraform validation/testing |
| [`terraform.yml`](./.github/workflows/terraform.yml) | Terraform automation |
| [`three-tier-app-configuration.yml`](./.github/workflows/three-tier-app-configuration.yml) | Three-tier infrastructure configuration |
| [`simple-webapp-docker-ci-cd.yml`](./.github/workflows/simple-webapp-docker-ci-cd.yml) | Docker web application CI/CD |
| [`advanced-cicd.yml`](./.github/workflows/advanced-cicd.yml) | Advanced CI/CD practice |

[View all workflows →](./.github/workflows)

---

## Technical Skills Demonstrated

| Area | Technologies & Concepts |
| --- | --- |
| Cloud | AWS, EC2, VPC, RDS, ALB, Auto Scaling, CloudWatch, SNS |
| Infrastructure as Code | Terraform, modules, variables, outputs, infrastructure validation |
| Image & Configuration Automation | Packer, Ansible, Ansible Vault |
| Containers | Docker, Docker Compose, Docker Swarm, multi-stage builds, volumes, networks |
| Container Security | Trivy, Docker Scout, non-root execution, secrets, read-only filesystems |
| Kubernetes | Pods, Deployments, Services, ConfigMaps, Secrets, Ingress, Minikube, kubectl |
| CI/CD | GitHub Actions, automated builds, image tagging, infrastructure workflows |
| Systems | Linux, Bash, Nginx, reverse proxies, WebSockets |
| Networking | VPC design, public/private networking, DNS troubleshooting, connectivity diagnostics |
| Data Services | PostgreSQL, Redis |
| Application Technologies | JavaScript, TypeScript, Node.js, Express, React, Next.js, Python/Flask, C#/.NET |

---

## Repository Map

```text
devops-learning-journey/
├── .github/
│   └── workflows/                 # CI/CD and infrastructure automation
├── 02-linux-networking/           # Linux, Bash, AWS networking and diagnostics
├── 03-infrastructure-as-code/     # Terraform, Packer, Ansible and AWS projects
│   └── projects/
│       ├── golden-ami-pipeline/
│       ├── static-website-project/
│       ├── three-tier-app/
│       └── vpc-infrastructure/
├── 04-containerization/           # Docker, Docker Compose, Swarm and security
│   ├── code-labs/
│   │   └── container-security/
│   └── projects/
│       ├── advanced-voting-app/
│       ├── fullstack-app/
│       ├── microservices/
│       ├── production-ready/
│       └── simple-webapp/
├── 05-kubernetes/                 # Kubernetes manifests and study material
├── notes/
└── resources/
```

---

## Related AWS Infrastructure Repositories

### [AWS Multi-Tier Infrastructure with Terraform](https://github.com/Nikkypwetti/aws-terraform-multi-tier-app)

Terraform-based AWS infrastructure using:

- VPC
- Public and private subnets
- EC2
- RDS
- Security Groups

### [AWS Multi-AZ High-Availability Web Architecture](https://github.com/Nikkypwetti/aws-ha-webapp)

AWS architecture using:

- Application Load Balancer
- Auto Scaling Groups
- EC2
- RDS Multi-AZ
- Public and private subnets
- Private application and database layers

---

## What This Repository Shows

Rather than documenting only theory, this repository contains practical evidence of work across the infrastructure lifecycle:

**Design → Provision → Configure → Containerize → Secure → Automate → Monitor → Troubleshoot**

It demonstrates my ability to work across application, infrastructure and operations layers and to understand how systems connect beyond a single tool.

---

## Professional Profile

**Ganiyu Basirat Olanike**

Operations, RevOps & Business Systems professional with technical depth across Cloud, DevOps and automation.

- Portfolio: https://nikkytechies-portfolio.vercel.app/
- GitHub: https://github.com/Nikkypwetti
- LinkedIn: https://www.linkedin.com/in/ganiyu-basirat-308ab9403
- Email: olanike.basirat30@gmail.com

---

> This repository is a hands-on engineering portfolio and learning record. Individual folders contain project code, infrastructure definitions, automation workflows, labs and implementation notes.