Markdown

![Ansible](https://img.shields.io/badge/Ansible-2.16-black?style=for-the-badge&logo=ansible)
![Platform](https://img.shields.io/badge/Platform-Ubuntu_22.04-orange?style=for-the-badge&logo=ubuntu)
![Security](https://img.shields.io/badge/Security-Vault_Encrypted-green?style=for-the-badge&logo=keepassxc)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

# 🚀 Automated DevOps Lab Environment

This repository documents the end-to-end setup of a local DevOps lab using **KVM/Libvirt** for virtualization and **Ansible** for Configuration Management.

---

## 📖 Table of Contents

1. [Architecture Overview](#-architecture-overview)
2. [Infrastructure Setup](#-infrastructure-setup)
3. [Project Directory Structure](#-project-directory-structure)
4. [Operations Runbook (Daily Use)](#-operations-runbook-daily-use)
5. [Ansible Configuration Details](#-ansible-configuration-details)
6. [Security & Vault Management](#-security--vault-management)
7. [Troubleshooting & Maintenance](#-troubleshooting--maintenance)

---

## 🏗️ Architecture Overview

- **Hypervisor:** KVM/QEMU (managed via `libvirt`)
- **Control Node:** Local Ubuntu Laptop (HP EliteBook 820 G3)
- **Managed Node:** Ubuntu 22.04 Minimized VM
- **Automation:** Ansible (Roles-based architecture)
- **Networking:** Default NAT Bridge (`virbr0`)

---

## 🛠️ Infrastructure Setup

### 1. Storage Strategy

To protect the 40GB system partition (`/`), all virtual machine disks are stored on the 65GB secondary partition:
- **Path:** `/mnt/storage/libvirt/images/`

### 2. VM Provisioning (The "Pro" Import)

The VM was created using an existing `.qcow2` image. This method is faster than a full network install:

```bash
# # 1. Re-create the 5GB disk on the big partition
# sudo qemu-img create -f qcow2 /mnt/storage/libvirt/images/ansible-node.qcow2 5G

# # 2. Run the terminal-only installer
# sudo virt-install --name ansible-node \
# --ram 2048 \
# --vcpus 1 \
# --disk path=/mnt/storage/libvirt/images/ansible-node.qcow2,bus=sata \
# --os-variant ubuntu22.04 \
# --network network=default \
# --graphics none \
# --console pty,target_type=serial \
# --location /home/nikky-techies/ubuntu-22.04.5-live-server-amd64.iso,kernel=casper/vmlinuz,initrd=casper/initrd \
# --extra-args 'console=ttyS0,115200n8 serial'
sudo virt-install --name ansible-node \
--ram 1024 --vcpus 1 \
--disk path=/mnt/storage/libvirt/images/ansible-node.qcow2 \
--import --os-variant ubuntu22.04 \
--network network=default \
--graphics none --noautoconsole

3. Connection Prerequisites

    SSH Access: Configured via ssh-keygen and ssh-copy-id.

    Sudo Permissions: Configured inside the VM to allow the nikky user to execute commands without a password prompt:
    Bash
    
    echo "nikky ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/nikky

We use a modular Ansible Roles structure to ensure the code is reusable:
Plaintext

ansible-projects/
├── ansible.cfg          # Project-specific configurations
├── inventory.ini        # IP addresses and connection users
├── site.yml             # Main playbook (The entry point)
└── roles/
    └── webserver/
        ├── tasks/       # main.yml: Installation steps
        ├── handlers/    # main.yml: Service restarts (Nginx)
        ├── templates/   # index.html.j2: Dynamic HTML design
        └── vars/        # main.yml (Public) & secrets.yml (Encrypted)

Since you are using VS Code to manage your learning repo, having a clean visual of the folder structure is essential. This is exactly how your devops-learning-journey directory should look once you’ve implemented the "Pro Way."
📂 The "Pro" Ansible Directory Structure
Plaintext

devops-learning-journey/
├── ansible-projects/          # Main project folder
│   ├── inventory.ini          # List of your VM IPs and users
│   ├── site.yml               # The main "entry point" playbook
│   ├── index.html.j2          # (Optional) moved into the role below
│   └── roles/                 # Folder for all your modular roles
│       └── webserver/         # Your specific Nginx role
│           ├── handlers/
│           │   └── main.yml   # Logic for restarting Nginx
│           ├── tasks/
│           │   └── main.yml   # Installation and config steps
│           ├── templates/
│           │   └── index.html.j2 # Your dynamic HTML file
│           └── vars/
│               └── main.yml   # App title, email, and env variables
└── .gitignore                 # To keep terraform/ansible junk out of Git

📝 Quick Guide to Each File

Here is a reminder of what goes where in your VS Code editor:
File	Purpose	Key Content
inventory.ini	Target List	[webservers] and your VM IP.
site.yml	The Boss	Calls the webserver role.
tasks/main.yml	The Worker	apt: name=nginx and template:.
vars/main.yml	The Settings	app_title: "Nikky's Lab"
templates/index.j2	The Design	HTML with {{ variables }}.
handlers/main.yml	The Cleanup	service: name=nginx state=restarted.


🚀 Operations Runbook (Daily Use)
How to Start Working

    Power on the VM:
    Bash

sudo virsh start ansible-node

Find the current IP:
Bash

virsh domifaddr ansible-node

Update inventory.ini: Ensure the ansible_host matches the IP from the previous step.

Run the Playbook:
Bash

    ansible-playbook site.yml

How to Stop Working

    Shut down the VM gracefully:
    Bash

    sudo virsh shutdown ansible-node

🛡️ Security & Vault Management
Ansible Vault

Sensitive data is encrypted using AES256.

    View Secrets: ansible-vault view roles/webserver/vars/secrets.yml

    Edit Secrets: ansible-vault edit roles/webserver/vars/secrets.yml

Automatic Decryption

The ansible.cfg file is configured to look for a local password file:

    Vault Pass Path: ~/.ansible_vault_pass (Permission set to 600)

🔧 Troubleshooting & Maintenance
Common Commands
Action	Command
Check VM Status	virsh list --all
Access VM Console	sudo virsh console ansible-node
Check Laptop Disk	df -h /
Test Ansible Link	ansible all -m ping -i inventory.ini
Maintenance Tasks

    Log Cleanup: The playbook automatically runs apt autoclean to save space on the VM's 5GB disk.

    Reporting: Every successful run generates a deployment_report.txt in the project root.


---

### 🚀 Final Steps for You
1. **Create the file:** In VS Code, save this as `README.md` in your `ansible-projects` folder.
2. **Check the Preview:** Click the "Open Preview" button in the top right of VS Code to see the Table of Contents in action—you can actually click the links to jump down!
3. **Commit to Git:**
   ```bash
   git add README.md
   git commit -m "Docs: Complete technical runbook with Table of Contents"