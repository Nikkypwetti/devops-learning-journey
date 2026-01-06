# Day 16: [Packer Builders & Provisioners]

What I Learned

    Concept 1: Core Purpose of Packer

        Packer is an open-source tool used to create identical machine images for multiple platforms (AWS, Azure, GCP, Docker) from a single source configuration. It automates the "Golden Image" creation process.

    Concept 2: Builders (The "Where")

        Builders are responsible for creating the machine image on specific platforms. For AWS, the amazon-ebs builder launches a temporary EC2 instance, runs configurations, and packages it into an AMI.

        Key parameters include source_ami, instance_type, and region.

    Concept 3: Provisioners (The "How")

        Provisioners install and configure software within the running instance before it is turned into a static image.

        Shell Provisioner: Executes scripts or inline shell commands to install packages (e.g., Nginx, Docker).

        File Provisioner: Uploads files from your local machine to the image during the build process.

    Concept 4: Templates (HCL)

        Modern Packer uses HCL (HashiCorp Configuration Language). Templates consist of source blocks (defining the builder) and build blocks (defining what provisioners to run on those sources).

    Concept 5: Variables & Locals

        Variables: Allow users to pass values at runtime (e.g., variable "ami_name" {}).

        Locals: Internal constants used for dynamic values within the template, such as timestamps to give AMIs unique names.

    Concept 6: Post-Processors

        These run after the image is created. They can be used to compress artifacts, upload to registries, or create a manifest file containing the new AMI ID.

    Concept 7: The Packer Lifecycle

        The process follows: init (install plugins) -> fmt & validate (check syntax) -> build (execute the image creation). Packer automatically cleans up temporary resources (like EC2 instances) after completion.

Code Practice
Terraform

# example.pkr.hcl

# 1. Define the Source (Builder)

source "amazon-ebs" "ubuntu" {
  ami_name      = "packer-nginx-aws-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-0c55b159cbfafe1f0" # Base Ubuntu AMI
  ssh_username  = "ubuntu"
}

# 2. Define the Build Block (Provisioners)

build {
  name = "my-first-build"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

# Shell Provisioner to install Nginx

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl enable nginx"
    ]
  }

# File Provisioner to upload a custom index.html

  provisioner "file" {
    source      = "index.html"
    destination = "/tmp/index.html"
  }
}

Commands Used
Bash

# Initialize Packer plugins (required for new templates)
packer init .

# Format and Validate the configuration
packer fmt .
packer validate .

# Execute the build process
packer build example.pkr.hcl

# Passing variables via CLI
packer build -var "instance_type=t3.medium" example.pkr.hcl

Challenges

    Problem: SSH connection timeout during the build process.

    Solution: Ensured the base AMI has the correct ssh_username defined and that the local machine has outbound access to the temporary AWS instance.

Resources

    Video Tutorial

        Video: http://www.youtube.com/watch?v=uNuXAXvSjAc (31 mins)

    Documentation

        Reading: https://developer.hashicorp.com/packer/docs/templates

Tomorrow's Plan

    Topic 1: Packer Post-Processors & Manifests

    Topic 2: Integrating Packer with CI/CD Pipelines