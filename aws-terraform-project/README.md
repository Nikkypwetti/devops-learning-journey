# AWS Multi-Tier Infrastructure with Terraform

## 📖 Project Overview

This project automates the deployment of a production-ready **2-Tier Web Architecture** on AWS using Terraform. It features a public-facing web server and a secure, isolated database backend.

## 🏗️ Architecture

* **VPC:** Custom Network with public and private subnets across **2 Availability Zones**.
* **Public Tier:** EC2 Web Server (Amazon Linux 2023) with Auto-assigned Public IP.
* **Private Tier:** RDS MySQL Database (isolated from the internet).
* **Security:**
  * **Web SG:** Allows HTTP (80) from anywhere.
  * **DB SG:** Allows MySQL (3306) **ONLY** from the Web SG.

## 🛠️ Tech Stack

* **Cloud:** AWS (VPC, EC2, RDS, IAM)
* **IaC:** Terraform (Modular & Variable-driven)
* **Database:** MySQL 8.0

## 🚀 How to Run

1.  **Clone the repo:**

    ```bash
    git clone https://github.com/YOUR_USERNAME/aws-terraform-multi-tier-app.git
    ```

2.  **Create secrets file:**
    Create a `terraform.tfvars` file (this is git-ignored for security):
    ```hcl
    db_password = "your-secure-password"
    ```

3.  **Deploy:**
    ```bash
    terraform init
    terraform apply --auto-approve
    ```

## 🧹 Cleanup

To destroy all resources and stop billing:
```bash
terraform destroy
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |
| <a name="provider_http"></a> [http](#provider\_http) | 3.5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.my_database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.my_db_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_instance.web_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_route_table.public_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.public_assoc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.web_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.private_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private_subnet_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_ami.amazon_linux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [http_http.my_ip](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | The password for the database | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_web_server_public_ip"></a> [web\_server\_public\_ip](#output\_web\_server\_public\_ip) | 10. Output the Public IP This tells Terraform to print the IP address at the end so you don't have to look for it. |
<!-- END_TF_DOCS -->