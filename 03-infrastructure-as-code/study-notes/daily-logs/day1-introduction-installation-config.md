# Day 1: [Introduction to Iac and Installation]

## What I Learned

- **Definition**: Infrastructure as Code (IaC) tools allow you to manage infrastructure with configuration files rather than through a graphical user interface. IaC allows you to build, change, and manage your infrastructure in a safe, consistent, and repeatable way by defining resource configurations that you can version, reuse, and share.

Terraform is HashiCorp's infrastructure as code tool. It lets you define resources and infrastructure in human-readable, declarative configuration files, and manages your infrastructure's lifecycle.

- **Installation**: Terraform lets you safely and consistently manage your infrastructure as code across multiple cloud providers. To provision infrastructure with Terraform, you will write configuration in Terraform's configuration language, configure your cloud provider credentials, and apply your configuration with the Terraform Command Line Interface (CLI).

To use Terraform, you first need to install it. HashiCorp distributes Terraform as a binary package. You can also install Terraform using popular package managers.
Install Terraform

HashiCorp distributes Terraform as an executable CLI that you can install on supported operating systems, including Microsoft Windows, macOS, and several Linux distributions. You can also compile the Terraform CLI from source if a pre-compiled binary is not available for your system.

- **Create**

  - You can use Terraform to create and manage your infrastructure as code. In this tutorial, you will use Terraform to provision an EC2 instance on Amazon Web Services (AWS). EC2 instances are virtual machines running on AWS and a common component of many infrastructure projects. To provision your infrastructure, you will write configuration to define your provider and instance, set environment variables for your AWS credentials, initialize a new local workspace, and then apply your configuration to create your instance.

Prerequisites:

To follow this tutorial you will need:

    The Terraform CLI (1.2.0+) installed.
    The AWS CLI installed.
    An AWS account and associated credentials that allow you to create resources in the us-west-2 region, including an EC2 instance, VPC, and security groups.

- Write configuration

Create a new directory for the Terraform configuration you will use in this tutorial.

$ mkdir learn-terraform-get-started-aws

Change into the directory.

$ cd learn-terraform-get-started-aws

Terraform configuration files are plain text files in HashiCorp's configuration language, HCL, with file names ending with .tf. When you perform operations with the Terraform CLI, Terraform loads all of the configuration files in the current working directory and automatically resolves dependencies within your configuration. This allows you to organize your configuration into multiple files and in any order you choose.

Terraform configuration is organized into a few types of blocks that let you configure Terraform itself, Terraform providers, and the resources and data sources that make up your infrastructure.
The terraform block

The terraform {} block configures Terraform itself, including which providers to install, and which version of Terraform to use to provision your infrastructure. Using a consistent file structure makes maintaining your Terraform projects easier, so we recommend configuring your Terraform block in a dedicated terraform.tf file.

- **Manage**

  - Variables and outputs

Input variables let you parametrize the behavior of your Terraform configuration. You can also define output values to expose data about the resources you create. Variables and outputs also allow you to integrate your Terraform workspaces with other automation tools by providing a consistent interface to configure and retrieve data about your workspace's infrastructure.

- Output values

Output values allow you to access attributes from your Terraform configuration and consume their values with other automation tools or workflows.

- Modules

Modules are reusable sets of configuration. Use modules to consistently manage complex infrastructure deployments that include multiple resources and data sources. Like providers, you can source modules from the Terraform Registry. You can also create your own modules and share them within your organization.
Module blocks

Add a module block to your configuration in main.tf to create a VPC and related networking resources for your EC2 instance.

## Code Practice

# Terraform code written today

# The terraform block
# terraform.tf file

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"
}

**Configuration blocks**
**main.tf**

provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "learn-terraform"
  }
}

**Input Variables**
**variables.tf file**

variable "instance_name" {
  description = "Value of the EC2 instance's Name tag."
  type        = string
  default     = "learn-terraform"
}

variable "instance_type" {
  description = "The EC2 instance's type."
  type        = string
  default     = "t2.micro"
}

**To update main.tf files to use variables**

resource "aws_instance" "app_server" {
   ami           = data.aws_ami.ubuntu.id

  instance_type = "t2.micro"

  instance_type = var.instance_type

  tags = {

   Name = "learn-terraform"

   Name = var.instance_name
  }
}

**output.tf file**

output "instance_hostname" {
  description = "Private DNS name of the EC2 instance."
  value       = aws_instance.app_server.private_dns
}

**Add it inside main.tf file to create vpc**

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "example-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_dns_hostnames    = true
}

**Move EC2 instance into new VPC by updating the resource block**

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.private_subnets[0]

  tags = {
    Name = var.instance_name
  }
}
** After updating the rsources block we have to initialize our workplace again by using terraform init**

Commands Used
bash
terraform -version - to check terraform version
terraform fmt - to format configuration files
terraform init - to initialize Terraform workspace
terraform validate - to make sure your configuration is syntactically valid and internally consistent 
terraform plan - to review this plan to ensure that Terraform will make the changes you expect.
terraform apply - to apply configuration/ execute the plane
terraform state list - to list the resources and data sources in your Terraform workspace's state
terraform show - to print out your workspace's entire state 
terraform plan -var instance_type=t2.large - to changed your EC2 instance type from t2.micro to t2.large
terraform refresh - to query infrastructure provider to get the current state
terraform destroy - to destroy resources/infrastructure

Challenges

Problem: [Description]
Solution: [How solved]

Resources

    Video Tutorial
    Video: <https://www.youtube.com/watch?v=SLB_c_ayRMo> (first 30 mins)

    Documentation
    Reading: <https://learn.hashicorp.com/collections/terraform/aws-get-started>

Tomorrow's Plan

    Topic 1

    Topic 2
