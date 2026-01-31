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
| [aws_instance.first_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_route_table.public_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.public_assoc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.allow_tls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.practice](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_ami.amazon_linux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [http_http.my_ip](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to deploy resources in | `string` | `"us-east-1"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The type of EC2 instance to create | `string` | `"t3.micro"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | The name of the SSH key pair in AWS | `string` | n/a | yes |
| <a name="input_private_key_path"></a> [private\_key\_path](#input\_private\_key\_path) | The local path to the private key (.pem) file | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_public_ip"></a> [instance\_public\_ip](#output\_instance\_public\_ip) | The public IP address of the EC2 instance |
| <a name="output_website_url"></a> [website\_url](#output\_website\_url) | The URL to access the Nginx web server |
<!-- END_TF_DOCS -->