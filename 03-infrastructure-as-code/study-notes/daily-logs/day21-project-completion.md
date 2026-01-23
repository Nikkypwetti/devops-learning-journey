# Day 21: [Automated Golden AMI Pipeline]

## What I Learned

- Concept 1: Immutable Infrastructure with Packer Unlike traditional deployments that configure servers live, the Golden AMI pattern "bakes" all configurations into a machine image beforehand. This ensures that every instance launched is an identical, pre-verified copy of the production environment.

- Concept 2: Infrastructure as Code (IaC) Integration This project demonstrates the "Pro" workflow where Packer creates the artifact (AMI) and Terraform consumes it. Using Terraform data sources allows the infrastructure to dynamically discover and deploy the latest versioned image without manual ID updates.

- Concept 3: CI/CD for Machine Images By using GitHub Actions, the entire image-building process is triggered by a code push. This automates the transition from an Ansible playbook update to a fresh, secure AMI ready for deployment in AWS.

- Concept 4: Automated Image Management & Cost Control Managing cloud costs is a core DevOps responsibility. Using a post-processor to deregister old AMIs and delete associated EBS snapshots prevents "zombie" storage costs while maintaining a safe rollback buffer.

- Concept 5: Advanced Configuration Management with Ansible Ansible was utilized not just for package installation, but for OS hardening and dynamic content injection using Jinja2 templates, ensuring the web server displays real-time build metadata.

- Concept 6: Secrets Management with Ansible Vault To avoid committing sensitive data like database credentials to version control, Ansible Vault was used to encrypt secret variables. These are decrypted securely during the GitHub Actions build process.

- Concept 7: Cloud Observability & Monitoring Proactive monitoring was implemented by installing the CloudWatch Agent via Ansible to track Memory (RAM) utilization, which is not provided by default in standard AWS EC2 metrics.

- Concept 8: Dynamic Security with Bash Scripting To maintain a "Security First" approach, a custom Bash script was developed to automatically update Terraform variables with the developer's current public IP, ensuring SSH access is restricted to authorized machines only.

## Code Practice HCL & YAML

Packer Build Block (aws-ubuntu.pkr.hcl)

build { sources = ["source.amazon-ebs.ubuntu_nginx"]

provisioner "ansible" { playbook_file = var.playbook_file_path extra_arguments = ["--vault-password-file=${var.vault_password_file}"] }

post-processor "amazon-ami-management" { regions = ["us-east-1"] identifier = "golden-nginx-v1" keep_releases = 3 } }
Terraform Data Source (main.tf)

data "aws_ami" "golden_nginx" { most_recent = true owners = ["self"] filter { name = "name" values = ["golden-nginx-v1-*"] } }

## Commands Used

Bash
Initialize Packer and install required plugins

packer init .
Build the Golden AMI locally

packer build aws-ubuntu.pkr.hcl
Update Security Group with current Public IP

chmod +x update_ip.sh && ./update_ip.sh
Deploy infrastructure using the new Golden AMI

terraform apply -auto-approve

## Challenges

Problem: The GitHub Actions runner failed to decrypt the Ansible Vault secrets because the vault password file was missing in the headless environment. Solution: I utilized GitHub Secrets to securely pass the vault password into a temporary file in the runner, allowing the build to proceed.

## Resources

Video Tutorial Video: https://www.youtube.com/watch?v=RMB76z7X_iU (21 mins)

Documentation Reading: https://developer.hashicorp.com/packer/docs/builders/amazon/ebs

Tomorrow's Plan

Implementing Auto Scaling Groups (ASG) and Application Load Balancers (ALB) to make the Golden AMI highly available.