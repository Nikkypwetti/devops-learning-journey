# 🚀 Automated Golden AMI Pipeline

A professional-grade CI/CD pipeline that automates the creation and deployment of "Golden" Amazon Machine Images (AMIs) using Packer, Ansible, Terraform, and GitHub Actions.
🏗 Project Architecture

This project implements the "Immutable Infrastructure" pattern:

    Continuous Integration: GitHub Actions triggers on push.

    Image Baking: Packer spins up a temporary EC2 instance in AWS.

    Configuration Management: Ansible installs Nginx, applies security patches, and handles secrets via Ansible Vault.

    Artifact Creation: Packer snapshots the instance to create a versioned Golden AMI.

    Infrastructure as Code: Terraform dynamically fetches the latest AMI and deploys a secure, monitored EC2 instance.

## 🛠 Tech Stack

    Orchestration: GitHub Actions

    Infrastructure: Packer, Terraform

    Configuration: Ansible (with Vault for secret management)

    Cloud: AWS (EC2, IAM, Security Groups, CloudWatch)

    Scripting: Bash (Dynamic IP management)

## 🔒 Security Features

    Ansible Vault: All sensitive variables (like DB passwords) are encrypted at rest.

    Least Privilege IAM: The EC2 instances use a dedicated IAM Role with scoped-down policies for CloudWatch and SSM.

    Dynamic Firewalls: A custom Bash script updates Terraform security groups to allow SSH access only from the developer's current public IP.

## 🚀 How to Run

1. Build the Image

Push any change to the main branch. GitHub Actions will handle the Packer build automatically.

2. Update Local Environment

Run the IP management script to authorize your current location:
Bash

chmod +x terraform/update_ip.sh
./terraform/update_ip.sh

3. Deploy Infrastructure
Bash

cd terraform
terraform init
terraform apply -auto-approve

## 📈 Key Achievements

    Successfully resolved complex "Monorepo" pathing issues in GitHub Actions.

    Implemented automated secret decryption in a headless CI/CD environment.

    Reduced deployment time by "baking" configurations into the AMI rather than installing on boot.