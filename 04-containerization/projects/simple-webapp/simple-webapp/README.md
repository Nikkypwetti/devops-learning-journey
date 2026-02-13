# 🚀 High-Availability Node.js Web App on AWS ECS

## 🛠 Project Overview
A production-ready DevOps workflow for a containerized Node.js application, featuring automated CI/CD and Infrastructure as Code (IaC).

## 🏗 Architecture
- **App:** Node.js & Express.
- **Docker:** Multi-stage build (Builder: `node-slim`, Runtime: `node-alpine`) for minimal image size and maximum security.
- **Infrastructure:** AWS ECS Fargate (Serverless Containers).
- **Networking:** Application Load Balancer (ALB) with dynamic Target Group registration.
- **IaC:** Terraform with dynamic Data Sources for VPC and Subnets.
- **Automation:** Makefile for local orchestration & GitHub Actions for CI/CD.

## 🚀 How to Run
1. `terraform apply` to provision AWS resources.
2. `make deploy` to build, push, and update the ECS service.

Your CV "Power Bullets"

Since you asked what's next, here is how you describe this project to a recruiter or on your LinkedIn:

    Architected a High-Availability 2-Tier Web Application on AWS ECS Fargate using Terraform for Infrastructure as Code (IaC).

    Implemented a Sidecar Pattern by deploying a Redis cache alongside a Node.js microservice to optimize data retrieval latency.

    Engineered a CI/CD Pipeline using GitHub Actions to automate Docker builds, image tagging, and blue/green deployments.

    Optimized Cloud Costs and Security by utilizing multi-stage Docker builds (Alpine/Slim) and implementing a remote S3 backend for state management.