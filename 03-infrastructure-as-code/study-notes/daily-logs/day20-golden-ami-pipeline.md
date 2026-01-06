# Day 20: [Golden AMI Pipeline]

What I Learned

    Concept 1: Purpose of a Golden AMI

        A Golden AMI is a pre-configured machine image that contains a standardized stack (OS, security patches, and core software). It ensures consistency across environments and speeds up deployment because software is "baked in" rather than installed at runtime.

    Concept 2: Packer as the Builder

        Packer is an open-source tool used to create identical machine images for multiple platforms from a single source configuration. For this project, Packer orchestrates the creation of the AWS AMI by launching a temporary EC2 instance and executing provisioners.

    Concept 3: Ansible as a Provisioner

        While Packer handles the infrastructure of the build, Ansible is used as a provisioner to handle software installation and configuration. This allows you to use your existing Ansible playbooks to harden the OS or install applications during the image creation process.

    Concept 4: HCL2 Configuration (amazon-ebs)

        Modern Packer uses HCL2 (HashiCorp Configuration Language). The source "amazon-ebs" block defines the base AMI (e.g., Ubuntu), the instance type used for the build, and the region where the final AMI will be stored.

    Concept 5: The Build Block

        The build block connects the source (the base image) with provisioners (scripts or Ansible playbooks). It is the execution engine that tells Packer which image to start with and what modifications to apply.

    Concept 6: Automated Cleanup

        One of Packer's key features is lifecycle management. It automatically creates temporary security groups and key pairs, and terminates the temporary EC2 instance once the AMI is successfully captured, preventing unnecessary AWS costs.

    Concept 7: Variable Management in Packer

        Like Terraform, Packer supports variables to make templates reusable. You can define variables for regions, instance types, or AMI names, allowing the same pipeline to build images for Dev, Staging, or Prod.

Code Practice
Terraform

# Packer HCL2 Template: aws-ubuntu.pkr.hcl

packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "ami_prefix" {
  type    = string
  default = "golden-ami-ubuntu"
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "${var.ami_prefix}-${timestamp()}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"] # Canonical
  }
  ssh_username = "ubuntu"
}

build {
  name = "my-golden-ami"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

# Using Ansible to configure the image

  provisioner "ansible" {
    playbook_file = "./playbook.yml"
    user          = "ubuntu"
    use_proxy     = false
  }
}

Commands Used
Bash

# Initialize the Packer project and download plugins
packer init .

# Validate the syntax and configuration
packer validate .

# Build the AMI
packer build aws-ubuntu.pkr.hcl

# Build with a custom variable override
packer build -var "ami_prefix=web-server-base" .

Challenges

    Problem: Packer couldn't connect to the temporary instance via SSH to run Ansible.

    Solution: Ensured the default VPC had a public subnet and that my local IP was allowed in the temporary security group (or used associate_public_ip_address = true in the source block).

Resources

    Updated Tutorial: Build an Image | Packer - HashiCorp Developer

    Video Walkthrough: Fully Automated AWS AMI Builds with Packer

Tomorrow's Plan

    Topic 1: Automating the Golden AMI build using GitHub Actions.

    Topic 2: Implementing "AMI Sharing" to distribute the Golden AMI across multiple AWS accounts.