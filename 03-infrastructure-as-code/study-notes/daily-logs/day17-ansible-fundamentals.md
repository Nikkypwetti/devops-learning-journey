# Day 17: [Ansible Fundamentals]

What I Learned

    Concept 1: Definition of Ansible

        Ansible is an open-source IT automation engine that automates provisioning, configuration management, application deployment, and intra-service orchestration. It is designed to be simple, human-readable (YAML), and powerful enough to manage complex multi-tier IT infrastructures.

    Concept 2: Agentless Architecture

        Unlike many other configuration management tools (like Chef or Puppet), Ansible is agentless. It does not require any software to be installed on the managed nodes. It connects via standard SSH for Linux or WinRM for Windows, making it incredibly easy to deploy and secure.

    Concept 3: The Control Node vs. Managed Nodes

        The Control Node is the machine where Ansible is installed and where commands are executed. Managed Nodes are the target devices (servers, routers, switches) being configured. Note: Windows cannot currently be a Control Node, though it can be a Managed Node.

    Concept 4: Inventory Management

        Ansible uses an Inventory file (often located at /etc/ansible/hosts) to keep track of the IP addresses or hostnames of managed nodes. Hosts can be grouped (e.g., [webservers] or [databases]) to allow for targeted automation.

    Concept 5: Ad-Hoc Commands

        These are quick, one-line commands used for simple tasks that you don't need to save for later. For example, using the ping module to check connectivity or the reboot module to restart servers across an entire group simultaneously.

    Concept 6: Ansible Playbooks

        Playbooks are the core of Ansible's configuration management. Written in YAML, they describe a policy you want your remote systems to enforce. A playbook contains "Plays," and each play contains "Tasks" that utilize Ansible Modules to achieve a specific state.

    Concept 7: Idempotency

        One of Ansible's most powerful features. Idempotency means that running a task multiple times will result in the same state without making unnecessary changes. If a file is already present and correct, Ansible will do nothing, ensuring system stability and efficiency.

    Concept 8: Modules

        Modules are the "tools in the toolkit." They are small programs that do the actual work on the managed nodes (e.g., yum, apt, service, copy, user). Ansible executes these modules and then removes them when the task is finished.

    Concept 9: YAML Syntax

        Playbooks rely on strict YAML formatting. This includes the use of three dashes (---) to start a file, proper indentation (spaces, not tabs), and a key-value pair structure that makes the automation logic easy for anyone to read.

Code Practice
YAML

# Example of an Inventory file (/etc/ansible/hosts)

[linux_servers]
192.168.1.10
192.168.1.11

[linux_servers:vars]
ansible_user=root
ansible_password=password123

# Example of a basic Ansible Playbook (install_nano.yml)

---
- name: Configure Web Servers
  hosts: linux_servers
  become: yes  # Run as sudo
  tasks:
    - name: Ensure nano is installed
      yum:
        name: nano
        state: latest

    - name: Ensure Apache is started and enabled
      service:
        name: httpd
        state: started
        enabled: yes

Commands Used
Bash

# Verify connectivity to all hosts in the inventory
ansible all -m ping

# Run a quick ad-hoc command to check OS version on all 'linux_servers'
ansible linux_servers -a "cat /etc/os-release"

# Run a Playbook
ansible-playbook install_nano.yml

# Check configuration syntax without running it
ansible-playbook install_nano.yml --syntax-check

Challenges

Problem: SSH connection failed when trying to run the first ping command. Solution: Realized that the managed nodes had "Host Key Checking" enabled by default. I updated ansible.cfg to set host_key_checking = False for the lab environment.
Resources

    Video Tutorial

        Video: https://www.youtube.com/watch?v=5hycyr-8EKs (21 mins)

    Documentation

        Reading: https://docs.ansible.com/ansible/latest/getting_started/index.html

Tomorrow's Plan

    Ansible Roles: Learning how to structure playbooks into reusable roles.

    Ansible Vault: Securing sensitive data like passwords and API keys within playbooks.