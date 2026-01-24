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
    amazon-ami-management = {
      version = ">= 1.0.0"
      source  = "github.com/wata727/amazon-ami-management"
    }
  }
}


source "amazon-ebs" "ubuntu_nginx" {
  ami_name      = "golden-nginx-v1-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  instance_type = var.instance_type
  region        = var.aws_region
  associate_public_ip_address = true
  temporary_security_group_source_public_ip = true
  force_deregister      = true
  force_delete_snapshot = true

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
# The Build Section
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
    # Use the absolute path provided by the GITHUB_WORKSPACE variable
    playbook_file = var.playbook_file_path
    user          = "ubuntu"
    use_proxy     = false
    
    extra_arguments = [
      "--vault-password-file=${var.vault_password_file}"
    ]
    
    ansible_env_vars = [
      # Dynamically point to the roles folder
      "ANSIBLE_ROLES_PATH=${var.ansible_roles_path}",
      "ANSIBLE_HOST_KEY_CHECKING=False",
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

  post-processor "amazon-ami-management" {
    regions = ["us-east-1"]
    
    # 🌟 PRO TIP: Use a prefix search to find all your versioned images
    identifier    = "golden-nginx-v1"
    
    # Keep the last 2 builds. This gives you a "Rollback" buffer 
    # in case the newest one has a bug.
    keep_releases = 1
    
    # Ensure snapshots are deleted to keep your AWS bill at $0
    tags = {
      ManagedBy = "Packer-Cleanup"
    }
  }
}

