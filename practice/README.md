# Infrastructure as Code: AWS EC2 Auto-Provisioning

## 🚀 Project Overview

This project demonstrates the automated deployment of a web server on AWS using **Terraform**. It goes beyond simple resource creation by using **Provisioners** to configure the server environment automatically upon boot.

## 🏗️ Architecture

The project sets up a complete, isolated network environment:

* **Networking**: Custom VPC, Public Subnet, Internet Gateway, and Route Table.
* **Security**: Security Groups allowing SSH (22) for management and HTTP (80) for web traffic.
* **Compute**: Amazon Linux 2023 EC2 Instance.
* **Automation**: 
    - `local-exec`: Captures the new instance's Public IP to a local file.
    - `remote-exec`: Connects via SSH to install, configure, and start the Nginx web server.

## 🛠️ Key Terraform Concepts Used

* **Data Sources**: Used to dynamically fetch the most recent Amazon Linux 2023 AMI ID.
* **Variables & Outputs**: Clean separation of configuration and visibility of results (IP/URL).
* **Connection Blocks**: Managed SSH authentication using local `.pem` keys.

## 📋 How to Run

1. **Clone the repo**
2. **Configure Credentials**: Ensure your AWS CLI is configured or use a `terraform.tfvars` file (not included in repo for security).
3. **Initialize**: `terraform init`
4. **Deploy**: `terraform apply`
5. **Verify**: Click the `website_url` printed in the Terraform outputs.

## 📝 Lessons Learned

- Handling the lifecycle of provisioners (they only run on creation).
- Managing custom VPC routing to allow internet access to instances.
- Security best practices: Using `.gitignore` to protect `.pem` keys and state files.