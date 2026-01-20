packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
  }
}

source "amazon-ebs" "ubuntu_nginx" {
  ami_name      = "golden-nginx-v1-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  instance_type = var.instance_type
  region        = var.aws_region
  associate_public_ip_address = true
  temporary_security_group_source_public_ip = true

  # Professional Filter: Always get the latest official Ubuntu 22.04
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"] # Canonical
  }

  ssh_username = var.ssh_username
  # ssh_timeout  = "10m"
  ssh_interface = "public_ip"
  
  # Professional Tagging (Crucial for Cloud Governance)
  tags = {
    Name        = "Golden-Nginx-Image"
    Environment = "Production"
    BuildBy     = "Packer"
    Project     = "DevOps-Journey"
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu_nginx"]

  # Step 1: Wait for Cloud-Init and Update
  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      "sudo apt-get update -y"
    ]
  }

  # Step 2: The Pro Ansible Provisioner
  provisioner "ansible" {
    playbook_file = "../../ansible-labs/ansible-projects/site.yml" 
    user          = "ubuntu"
    use_proxy     = false
    
    extra_arguments = [
      # Pro Tip: Use the equals sign for the vault file to avoid parsing errors
      "--vault-password-file=${var.vault_password_file}"
    ]
    
    ansible_env_vars = [
      "ANSIBLE_ROLES_PATH=/home/nikky-techies/devops-learning-journey/03-infrastructure-as-code/code-labs/ansible-labs/ansible-projects/roles",
      "ANSIBLE_HOST_KEY_CHECKING=False",
      # Ensures Ansible uses the correct Python version on Ubuntu 22.04
      "ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3"
    ]
  }

  # Step 3: Automated Test (Verification)
  provisioner "shell" {
    inline = [
      "echo 'Running Smoke Test...'",
      "curl -f http://localhost || exit 1",
      "echo 'Smoke Test Passed!'"
    ]
  }
}