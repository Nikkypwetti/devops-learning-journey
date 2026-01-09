🛠️ Phase 1: Environment Setup

Goal: Prepare the Managed Node (VM) to accept instructions from the Control Node (Laptop).
1. VM Preparation (Inside the VM)

The VM must have SSH installed and allow the root user to log in.

    Command: sudo apt update && sudo apt install openssh-server -y

        Use: Installs the "listening" service for SSH.

    Command: echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

        Use: Allows the root user to be accessed via SSH (standard for home labs).

    Command: systemctl restart ssh

        Use: Applies the configuration changes.

2. SSH Key Handshake (Laptop to VM)

    Command: ssh-keygen -t ed25519

        Use: Creates your "Digital Fingerprint" (Public/Private keys).

    Command: ssh-copy-id root@192.168.122.207

        Use: Copies your public key to the VM so you don't need a password later.

📂 Phase 2: Professional Project Structure

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

🔐 Phase 3: Security & Secrets (Ansible Vault)

We used Vault to ensure passwords are never stored in plain text.

    Command: echo "your_password" > .vault_pass

        Use: Stores the "Master Key" to unlock your secrets automatically.

    Command: echo 'vm_password: "1234"' > group_vars/webservers.yml

        Use: Creates the variable file in a "Dictionary" format (key: value).

    Command: ansible-vault encrypt group_vars/webservers.yml --vault-password-file .vault_pass

        Use: Scrambles the file so only Ansible can read it.

🚀 Phase 4: The Automation (Playbook)

Your site.yml tells Ansible which hosts to target and which roles to run.

The Inventory (hosts):
[webservers]
192.168.122.207 ansible_user=root ansible_password="{{ vm_password }}"

The Playbook Execution:

    Command: ansible-playbook site.yml --vault-password-file .vault_pass

        Use: Runs the automation script using the vault key for authentication.

⚠️ Phase 5: Troubleshooting & Error Log

This is the most important part of your notes for a job interview!
Error Encountered,Cause,Solution
"""Permission Denied (publickey)""",VM's SSH service was blocking root or keys.,Edited sshd_config to allow PermitRootLogin.
"""vm_password is undefined""",Variable not loaded because the file wasn't in group_vars.,Moved credentials.yml to group_vars/webservers.yml.
"""Could not be made into a dictionary""",Vault content was empty or wrongly formatted.,Used echo to ensure key: value format before encrypting.
"""Vault-ids default, default conflict""",Conflict between ansible.cfg and command line flags.,Removed vault line from cfg and passed it via command line.
