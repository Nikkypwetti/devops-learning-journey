# Day 13 - VPC Project

Tutorial Summary: Created VPC with public/private subnets across AZs. Internet Gateway for public access. NAT Gateway for private instances to access internet. Route tables and associations. Security groups for network control.

Practice Completed: Built modular VPC: modules/vpc, modules/subnet, modules/security-group. Main configuration uses modules to create: 1 VPC, 3 public subnets, 3 private subnets, IGW, NAT Gateway, route tables, basic security groups. Outputs: VPC ID, subnet IDs, NAT public IP.

**Folder:** `03-infrastructure-as-code/project/vpc-infrastructure`

. Key Concept Check (For your Practice)

When doing this project, make sure you can answer these:

    Why do we need a NAT Gateway? (To allow private instances to reach the internet for patches without having a public IP).

    What is the difference between a Public and Private subnet in Terraform? (In this module, it's defined by whether the route table points to the IGW or the NAT Gateway).

    Why use modules? (It saves you from writing 150+ lines of code for individual route table associations and gateway attachments).