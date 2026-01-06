# Week 2: Terraform Modules & Advanced Workflows

## Knowledge Check

### 1. Modules & Registry

    [ ] Understands module structure (Root vs Child)

    [ ] Can call modules with specific versions

    [ ] Knows how to use the Terraform Public Registry

    [ ] Can pass variables into modules and get outputs

### 2. Environment Management

    [ ] Understands the use case for Workspaces

    [ ] Knows the difference between OSS Workspaces and TFC/TFE

    [ ] Can isolate state files for dev/stage/prod

    [ ] Implements environment-specific variables

### 3. Remote State & Collaboration

    [ ] Can configure S3 as a remote backend

    [ ] Understands DynamoDB's role in state locking

    [ ] Knows the risks of manual state manipulation

    [ ] Implements Git workflows for team collaboration

### 4. Advanced Practical Skills

    [ ] Can architect a multi-tier VPC using modules

    [ ] Uses terraform fmt and validate automatically

    [ ] Can troubleshoot complex dependency issues

    [ ] Understands networking components (IGW, NAT, Subnets) in HCL

### Infrastructure Deployed:

    [ ] Custom VPC with CIDR block

    [ ] Public and Private Subnets

    [ ] Internet Gateway (IGW)

    [ ] NAT Gateway for private egress

    [ ] Route Tables properly associated

### Code Quality:

    [ ] Code formatted with terraform fmt

    [ ] No hardcoded values (Uses variables)

    [ ] README includes an Input/Output table

    [ ] Remote state backend successfully initialized

### Documentation:

    [ ] High-level architecture diagram

    [ ] Step-by-step deployment guide

    [ ] Resource destruction instructions

## Self-Assessment Questions

    When should you prefer a Public Registry module over a custom-built one?

    What happens if two people try to apply at the same time without state locking?

    How do you handle different secrets across Workspaces?

    What is the "Golden Rule" of Terraform Best Practices you found most useful?

## Week 2 Achievements

✅ Created and called local modules
✅ Successfully migrated state from local to S3
✅ Managed multiple environments using Workspaces
✅ Deployed a production-grade VPC via code
✅ Implemented state locking with DynamoDB

## Areas for Improvement

    Need more practice with: ________________

    Concepts to review: ____________________

    Skills to develop: _____________________

## Preparation for Week 3 (Packer & Ansible)

    Review Linux Administration basics

    Understand Golden Image concepts

    Install Packer and Ansible locally