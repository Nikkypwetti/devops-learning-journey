# Day 19: [Packer + Ansible Integration]

What I Learned

    Concept 1: The Role of Ansible in Packer

        Packer is an open-source tool for creating identical machine images for multiple platforms from a single source configuration. While Packer can use simple shell scripts to configure an image, integrating Ansible allows you to use declarative YAML playbooks, making the configuration process more robust, readable, and reusable.

    Concept 2: Provisioner Types (Ansible vs. Ansible-Local)

        Ansible (Remote): Runs on the machine where Packer is executing and connects to the guest VM via SSH/WinRM. It requires Ansible to be installed on your local machine.

        Ansible-Local: Uploads your playbooks to the guest VM and runs Ansible directly on that machine. This is often preferred in CI/CD pipelines as it removes the need for a local Ansible installation, though Ansible must be installed on the guest image temporarily.

    Concept 3: Integration Workflow

        A standard workflow follows three distinct steps:

            Install: Use a shell provisioner to install the Ansible package on the target OS.

            Provision: Execute the ansible-local provisioner to apply the desired configuration (e.g., installing Nginx or security patches).

            Cleanup: Use a final shell provisioner to remove Ansible and temporary files to ensure the final "Golden Image" is lean.

    Concept 4: Managing Image Metadata with HCP Packer

        By integrating with HCP Packer, you can track the metadata of the images created via your Ansible playbooks. This allows you to manage versions, see which images are currently in "Production," and ensure that downstream tools like Terraform always pull the correct version.

    Concept 5: Release Channels

        HCP Packer allows you to assign "Channels" (e.g., development, staging, production) to specific iterations of your image. This provides a safety layer, ensuring that your infrastructure-as-code only consumes images that have passed all Ansible provisioning tests.

Code Practice
Terraform

# Example Packer HCL template with Ansible-Local provisioner

source "amazon-ebs" "ubuntu" {
  ami_name      = "packer-ansible-nginx-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  sources = ["source.amazon-ebs.ubuntu"]

# Step 1: Install Ansible on the temporary builder instance

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y ansible"
    ]
  }

# Step 2: Run the Ansible Playbook

  provisioner "ansible-local" {
    playbook_file = "./playbook.yml"
  }

# Step 3: Cleanup - Remove Ansible so it's not in the final Golden Image

  provisioner "shell" {
    inline = [
      "sudo apt-get remove -y ansible",
      "sudo apt-get autoremove -y"
    ]
  }
}

Commands Used
Bash

# Initialize Packer plugins
packer init .

# Format the template file
packer fmt .

# Validate the configuration
packer validate .

# Build the image using the Ansible provisioner
packer build .

Challenges

Problem: The ansible-local provisioner failed because Ansible was not found on the guest machine. Solution: Added a shell provisioner before the Ansible block to perform sudo apt-get install -y ansible, ensuring the binary was available for the task.
Resources

    Video Tutorial

        Video: http://www.youtube.com/watch?v=3zPaTaxY0Ng (15 mins)

    Documentation

        Reading: https://developer.hashicorp.com/packer/plugins/provisioners/ansible

Tomorrow's Plan

    Topic 1: Packer Variables and Secret Management

    Topic 2: Multi-region Image Deployment with Packe
