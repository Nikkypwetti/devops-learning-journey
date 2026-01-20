Markdown

# Hands-on Lab Note: Ansible Control Node to Ubuntu VM

## 🛠️ Phase 1: Environment Setup

Goal: Prepare the Managed Node (VM) to accept instructions from the Control Node (Laptop).

### 1. VM Preparation (Inside the VM)

The VM must have SSH installed and allow the root user to log in.

    Command: sudo apt update && sudo apt install openssh-server -y

        Use: Installs the "listening" service for SSH.

    Command: echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

        Use: Allows the root user to be accessed via SSH (standard for home labs).

    Command: systemctl restart ssh

        Use: Applies the configuration changes.

### 2. SSH Key Handshake (Laptop to VM)

    Command: ssh-keygen -t ed25519

        Use: Creates your "Digital Fingerprint" (Public/Private keys).

    Command: ssh-copy-id root@192.168.122.207

        Use: Copies your public key to the VM so you don't need a password later.

## 📂 Phase 2: Professional Project Structure

We organized the files according to Ansible Best Practices to make the project "Job Ready."

Your Folder Layout:
ansible-labs/
├── ansible.cfg        # Global settings
├── hosts              # Inventory of servers
├── site.yml           # The main Playbook
├── .vault_pass        # Hidden password for the Vault
├── group_vars/
│   └── webservers.yml # Encrypted secrets for the webserver group
└── roles/
    └── webserver/
        └── tasks/
            └── main.yml # The actual work instructions

## 🔐 Phase 3: Security & Secrets (Ansible Vault)

We used Vault to ensure passwords are never stored in plain text.

    Command: echo "your_password" > .vault_pass

        Use: Stores the "Master Key" to unlock your secrets automatically.

    Command: echo 'vm_password: "1234"' > group_vars/webservers.yml

        Use: Creates the variable file in a "Dictionary" format (key: value).

    Command: ansible-vault encrypt group_vars/webservers.yml --vault-password-file .vault_pass

        Use: Scrambles the file so only Ansible can read it.

## 🚀 Phase 4: The Automation (Playbook)

Your site.yml tells Ansible which hosts to target and which roles to run.

The Inventory (hosts):
[webservers]
192.168.122.207 ansible_user=root ansible_password="{{ vm_password }}"

The Playbook Execution:

    Command: ansible-playbook site.yml --vault-password-file .vault_pass

        Use: Runs the automation script using the vault key for authentication.

## ⚠️ Phase 5: Troubleshooting & Error Log

This is the most important part of your notes for a job interview!
Error Encountered,Cause,Solution
"""Permission Denied (publickey)""",VM's SSH service was blocking root or keys.,Edited sshd_config to allow PermitRootLogin.
"""vm_password is undefined""",Variable not loaded because the file wasn't in group_vars.,Moved credentials.yml to group_vars/webservers.yml.
"""Could not be made into a dictionary""",Vault content was empty or wrongly formatted.,Used echo to ensure key: value format before encrypting.
"""Vault-ids default, default conflict""",Conflict between ansible.cfg and command line flags.,Removed vault line from cfg and passed it via command line.

## We will create a shortcut so that instead of typing long commands, you just type start-lab and stop-lab.

### Step 1: Open your Bash Configuration

Aliases are stored in a hidden file in your home directory called .bashrc.

    Open the file in VS Code:
    Bash

    code ~/.bashrc

    Scroll to the very bottom of the file.

### Step 2: Add the Professional Shortcuts

Paste these lines at the bottom of the file.

    Note: Replace YOUR_VM_NAME with the actual name of your VM (probably ubuntu22.04 or similar). If you aren't sure, run virsh list --all to check.

Bash

# --- Ansible Lab Shortcuts ---

# 1. Start the VM and check connection
alias start-lab='virsh start YOUR_VM_NAME && sleep 10 && virsh domifaddr YOUR_VM_NAME'

# 2. Go to project and ping
alias lab-check='cd ~/devops-learning-journey/03-infrastructure-as-code/code-labs/ansible-labs && ansible all -m ping --vault-password-file .vault_pass'

# 3. Shutdown the VM safely
alias stop-lab='virsh shutdown YOUR_VM_NAME'

## Step 3: Activate the Changes

The terminal only reads that file when it first opens. To make the changes work right now without restarting your laptop, run:
Bash

source ~/.bashrc

### Step 4: Test your New Powers 🚀

Now, test your workflow using only the shortcuts:

    Type: start-lab

        What happens: The VM starts "headless," waits 10 seconds for it to boot, and then prints the IP address.

    Type: lab-check

        What happens: You are instantly moved into your project folder and Ansible pings the VM to make sure it's ready.

    Type: stop-lab

        What happens: The VM shuts down cleanly.

Here is your step-by-step "Pro Workflow" to start your lab and connect without the pop-up screen.
Phase 1: Start the VM "Headless"

If you don't want the VM window to pop up and stay on your taskbar, you can start it in the background.

    Open your Laptop Terminal.

    List your VMs to find the exact name:
    Bash

virsh list --all

Start the VM "Headless":
Bash

    virsh start <your_vm_name>

    (The VM is now running in the background, consuming RAM/CPU, but with no window open).

Phase 2: Connect via Terminal (SSH)

Since you’ve already set up SSH keys, you don't need the VM screen to log in.

    Check if it's awake:
    Bash

ping 192.168.122.207

Log in directly:
Bash

    ssh root@192.168.122.207

    If your keys are working, you will instantly see the root@ubuntu:~# prompt. You are now "inside" the VM using your laptop's terminal.

Phase 3: Start your Ansible Work

Now that the VM is running in the background, you are ready to use Ansible. Do not run Ansible inside the SSH session. Stay on your laptop's local prompt.

    Open your project folder in VS Code:
    Bash

cd ~/devops-learning-journey/03-infrastructure-as-code/code-labs/ansible-labs
code .

Test the connection:
Bash

ansible all -m ping --vault-password-file .vault_pass

Run your Playbook:
Bash

    ansible-playbook site.yml --vault-password-file .vault_pass

Phase 4: Emergency - If you lose the IP address

Sometimes the VM starts but the IP changes, and you can't SSH in. To find the IP without opening the VM screen:

    Ask the Virtual Network:
    Bash

    virsh domifaddr <your_vm_name>

    This will print the IP address assigned to the VM.

Phase 5: Shutting Down

When you are tired and finished for the day, don't just close the laptop. Shut down the VM properly to avoid corrupting your lab:

    From your laptop terminal:
    Bash

    virsh shutdown <your_vm_name>

Summary Checklist for Tomorrow:

    Laptop Terminal: virsh start <vm_name>

    Laptop Terminal: cd into your ansible folder.

    Laptop Terminal: Run your ansible-playbook.

    Finish: virsh shutdown <vm_name>.