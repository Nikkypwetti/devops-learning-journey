# Week 3: Packer & Ansible Integration Assessment

## Knowledge Check

### 1. Packer Introduction

    [ ] Day 15: https://www.youtube.com/watch?v=OmQRpi3CSjU (29 mins)

    [ ] Day 15: https://learn.hashicorp.com/collections/packer/get-started

    [ ] Can explain the benefit of "Golden Images"

    [ ] Understands the Packer build workflow

### 2. Builders & Provisioners

    [ ] Day 16: https://www.youtube.com/watch?v=R5u5IN7RAKg (5 mins)

    [ ] Day 16: https://developer.hashicorp.com/packer/docs/templates

    [ ] Can distinguish between a Builder and a Provisioner

    [ ] Knows how to use the Shell provisioner for basic setup

### 3. Ansible Fundamentals

    [ ] Day 17: https://www.youtube.com/watch?v=1id6ERvfozo (16 mins)

    [ ] Day 17: https://docs.ansible.com/ansible/latest/getting_started/index.html

    [ ] Understands Agentless architecture

    [ ] Knows YAML syntax for Playbooks

### 4. Playbooks & Roles

    [ ] Day 18: https://www.youtube.com/watch?v=tq9sCeQNVYc (19 mins)

    [ ] Day 18: https://docs.ansible.com/ansible/latest/user_guide/playbooks.html

    [ ] Can create reusable Ansible Roles

    [ ] Understands handlers, variables, and templates (Jinja2)

### 5. Integration & Pipelines

    [ ] Day 19: https://www.youtube.com/watch?v=uOj31vd5IIM (6 mins)

    [ ] Day 19: https://developer.hashicorp.com/packer/plugins/provisioners/ansible

    [ ] Day 20: https://learn.hashicorp.com/tutorials/packer/aws-get-started

    [ ] Can run Ansible Playbooks inside a Packer build

    [ ] Understands the Golden AMI Pipeline workflow

## Project Completion Checklist

### Infrastructure Deployed:

    [ ] Custom AWS AMI created via Packer

    [ ] Ansible used as the primary provisioner

    [ ] Image includes a hardened OS or pre-installed App

    [ ] AMI is tagged and versioned correctly

### Code Quality:

    [ ] Clean HCL2 Packer templates

    [ ] Ansible roles follow standard directory structure

    [ ] No hardcoded AWS credentials (used IAM or Env vars)

    [ ] Reusable code for different regions/instance types

### Documentation:

    [ ] README with build instructions

    [ ]

    [ ] List of Ansible tags used

    [ ] Cleanup steps for temporary build instances

## Self-Assessment Questions

    Why use Ansible inside Packer instead of just using Shell scripts?

    What is the difference between an Amazon Machine Image (AMI) and a Docker Image?

    How do you handle sensitive data (like API keys) in Ansible?

    What was the most difficult part of debugging the Packer build?

    How does the "Immutable Infrastructure" concept apply to this week?

## Week 3 Achievements

✅ Installed and configured Packer & Ansible
✅ Built a custom AWS AMI from scratch
✅ Wrote multi-step Ansible Playbooks
✅ Successfully integrated Packer with Ansible
✅ Automated the "Golden Image" creation process
✅ Documented the image build pipeline

## Areas for Improvement

    Need more practice with: ________________

    Concepts to review: ____________________

    Skills to develop: _____________________

    Resources to explore: __________________

## Preparation for Week 4

### Topics to Preview:

    Docker Fundamentals

    Container Orchestration

    Kubernetes Basics

    CI/CD Pipelines (GitHub Actions/Jenkins)

### Practice Exercises:

    [ ] Install Docker Desktop or Engine

    [ ] Build a simple Dockerfile

    [ ] Explore the differences between VMs and Containers

    [ ] Review basic networking for containers