# Day 18: [Ansible Playbooks & Roles]

What I Learned

    Concept 1:

        Ansible Playbooks Overview Playbooks are YAML files that serve as the instruction manual for Ansible. Unlike ad-hoc commands, playbooks allow you to map groups of hosts to well-defined roles and tasks, ensuring that your infrastructure reaches a specific desired state.

    Concept 2:

        YAML Syntax & Structure Playbooks use YAML because it is human-readable. A play typically starts with a hosts declaration (defining target nodes) and a tasks list. Key-value pairs are used to pass arguments to Ansible modules.

    Concept 3:

        Idempotency in Playbooks One of Ansible's strongest features is idempotency. Most Ansible modules check the current state of the system; if the system is already in the state defined by the playbook, Ansible will take no action, making it safe to run the same playbook multiple times.

    Concept 4:

        Ansible Roles for Reusability Roles allow you to break down complex playbooks into smaller, reusable components. By following a specific directory structure, Ansible automatically loads relevant vars, tasks, and handlers, making your automation modular.

    Concept 5:

        The Role Directory Structure A standard role includes specific folders like tasks/ (main logic), handlers/ (triggered events), vars/ (high-priority variables), defaults/ (default values), and templates/ (Jinja2 files).

    Concept 6:

        Handlers and Notifications Handlers are special tasks that only run when "notified" by another task. They are commonly used to restart services (like Apache or Nginx) only after a configuration file change has actually occurred.

    Concept 7:

        Variables and Precedence Ansible allows you to define variables in many places (Playbooks, Roles, Inventory, or Command Line). Understanding precedence is key: variables defined in a role's vars/ folder override those in defaults/.

    Concept 8:

        Ansible Galaxy Ansible Galaxy is a public repository for Ansible roles. You can use ansible-galaxy install to download community-maintained roles, or ansible-galaxy init to create the scaffolding for your own new role.

Code Practice
YAML

# Ansible Playbook (site.yml)

- name: Setup Web Server
  hosts: webservers
  become: yes
  roles:
    - common
    - webserver

# Role Task Example (roles/webserver/tasks/main.yml)

- name: Install Apache
  ansible.builtin.package:
    name: "{{ apache_package }}"
    state: present

- name: Copy index.html template
  ansible.builtin.template:
    src: index.html.j2
    dest: /var/www/html/index.html
  notify: Restart Apache

# Role Handler Example (roles/webserver/handlers/main.yml)

- name: Restart Apache
  ansible.builtin.service:
    name: "{{ apache_service }}"
    state: restarted

# Role Defaults (roles/webserver/defaults/main.yml)

apache_package: httpd
apache_service: httpd

Commands Used
Bash

# Run a playbook
ansible-playbook -i inventory.ini site.yml

# Check playbook for syntax errors
ansible-playbook site.yml --syntax-check

# Dry run to see what changes would occur
ansible-playbook site.yml --check

# Initialize a new role structure
ansible-galaxy init my_new_role

# Install a role from Ansible Galaxy
ansible-galaxy install geerlingguy.nginx

Challenges

Problem: The playbook failed because a variable wasn't defined for a specific host group. Solution: I added a defaults/main.yml file within the role to provide a fallback value so the playbook wouldn't crash if the variable was missing in the inventory.
Resources

    Video Tutorial

        Video: http://www.youtube.com/watch?v=2X84WUWHvbU (18 mins)

    Documentation

        Reading: https://docs.ansible.com/ansible/latest/user_guide/playbooks.html

Tomorrow's Plan

    Ansible Vault: Encrypting sensitive data.

    Dynamic Inventory: Using Ansible with Cloud providers (AWS/Azure).