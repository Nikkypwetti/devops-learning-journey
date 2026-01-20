packer {
  required_plugins {
    qemu = {
      version = ">= 1.0.10"
      source  = "github.com/hashicorp/qemu"
    }
    ansible = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

# 1. DEFINE VARIABLES
variable "storage_path" {
  default = "/mnt/storage/packer-builds"
}

variable "ssh_password" {
  type      = string
  sensitive = true
}

# 2. DEFINE THE BUILDER (QEMU)
source "qemu" "ubuntu_nginx" {
  iso_url          = "/mnt/storage/iso/ubuntu-22.04-live-server-amd64.iso"
  iso_checksum     = "none" 
  output_directory = var.storage_path
  shutdown_command = "echo '${var.ssh_password}' | sudo -S shutdown -P now"
  ssh_username     = "nikky"
  ssh_password     = var.ssh_password
  ssh_timeout      = "60m"
  vm_name          = "nginx-v1.qcow2"
  disk_size        = "8000M" 
  format           = "qcow2"
  headless         = false
  use_default_display = true # Add this line to show the window    
  accelerator      = "kvm"
 
  qemuargs = [
    ["-m", "2048M"],
    ["-smp", "2"],
    ["-display", "gtk"] # This tells QEMU to use the standard Ubuntu window manager
  ]
}

# 3. DEFINE THE BUILD PIPELINE
build {
  sources = ["source.qemu.ubuntu_nginx"]

  # Step A: Wait for the system to be ready (FIXED QUOTES HERE)
  provisioner "shell" {
    inline = ["echo 'Waiting for system boot...'", "sleep 30"]
  }

    # Step B: Run your existing Ansible Role
  provisioner "ansible" {
    playbook_file    = "../ansible-labs/ansible-projects/site.yml"
    user             = "nikky"
    use_proxy        = false
    
    extra_arguments = [
      "--extra-vars", "ansible_password=${var.ssh_password}",
      "--extra-vars", "ansible_sudo_pass=${var.ssh_password}",
      "--vault-password-file", "/home/nikky-techies/.ansible_vault_pass",
      "--scp-extra-args", "'-O'",
      # This forces Ansible to use password auth and ignore SSH keys
      "--ssh-extra-args", "-o PreferredAuthentications=password -o PubkeyAuthentication=no",
      "-vv" 
    ]
    
    ansible_env_vars = [
      "ANSIBLE_ROLES_PATH=../ansible-labs/ansible-projects/roles",
      "ANSIBLE_HOST_KEY_CHECKING=False"
    ]
  }

  # Step C: Cleanup the image
  provisioner "shell" {
    execute_command = "echo '${var.ssh_password}' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
    script = "./scripts/cleanup.sh"
    skip_clean      = true
    expect_disconnect = true
    valid_exit_codes = [0, 1, 100, 123] # Tell Packer these "errors" are okay
  }
}
