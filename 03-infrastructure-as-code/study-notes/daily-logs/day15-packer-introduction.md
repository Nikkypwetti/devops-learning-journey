# Day 15: [Packer Introduction]

What I Learned

    Concept 1: What is Packer?

        Packer is an open-source tool by HashiCorp used to create identical machine images for multiple platforms (AWS, Azure, Docker, VMware) from a single source configuration. It automates the process of building "Golden Images" with pre-installed software.

    Concept 2: Immutable Infrastructure

        Instead of updating running servers (mutable), Packer allows you to build a new image with updates and replace the old server entirely (immutable). This ensures environment consistency and reduces configuration drift.

    Concept 3: The Packer Template (HCL2)

        Modern Packer uses HCL (.pkr.hcl). The template consists of three main blocks:

            Source: Defines the "raw materials" (e.g., an Ubuntu base image on AWS).

            Build: Defines what to do with that source.

            Provisioners: Scripts (Shell, Ansible) that install software on the image.

    Concept 4: Builders and Artifacts

        A Builder is responsible for creating the machine image. For example, the amazon-ebs builder creates an AMI. The resulting output (like the AMI ID) is known as the Artifact.

    Concept 5: Provisioners

        Provisioners are the "meat" of the build. They allow you to run shell commands, upload files, or run configuration management tools while the temporary instance is running, before it is "baked" into an image.

    Concept 6: Post-Processors

        Post-processors run after an image is created. Common uses include tagging an image, compressing a Vagrant box, or triggering a local script to update documentation with the new image ID.

    Concept 7: Validation and Inspection

        Before building, use packer validate to check syntax. Use packer inspect to see the structure of your template and what variables are required.

Code Practice
Terraform

# example.pkr.hcl - Creating a basic AWS AMI

# 1. Define the Source

source "amazon-ebs" "ubuntu" {
  ami_name      = "packer-example-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-0c55b159cbfafe1f0" # Base Ubuntu AMI
  ssh_username  = "ubuntu"
}

# 2. Define the Build block

build {
  name    = "learn-packer"
  sources = ["source.amazon-ebs.ubuntu"]

# 3. Use Provisioners to install software

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl enable nginx"
    ]
  }
}

Commands Used
Bash

# Initialize Packer (installs required plugins)
packer init .

# Check if the configuration is valid
packer validate .

# Build the image (This spins up an EC2, runs scripts, saves AMI, and shuts down)
packer build example.pkr.hcl

# Build and provide a variable via CLI
packer build -var "instance_type=t3.medium" example.pkr.hcl

Challenges

    Problem: SSH timeout during the build process.

    Solution: Ensured that the security group of the source image allowed port 22 and that the ssh_username matched the default user for the base AMI (e.g., ubuntu for Ubuntu, ec2-user for Amazon Linux).

Resources

    Video Tutorial

        Video: https://www.youtube.com/watch?v=dIAhHhQ_J-c (14 mins)

    Documentation

        Reading: https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli

Tomorrow's Plan

    Topic 1: Packer Variables and Locals (Dynamic builds)

    Topic 2: Integrating Packer with CI/CD Pipelines