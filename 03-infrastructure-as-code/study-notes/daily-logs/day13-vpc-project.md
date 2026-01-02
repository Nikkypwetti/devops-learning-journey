# Day 13 - VPC Project

Tutorial Summary: Created VPC with public/private subnets across AZs. Internet Gateway for public access. NAT Gateway for private instances to access internet. Route tables and associations. Security groups for network control.

Practice Completed: Built modular VPC: modules/vpc, modules/subnet, modules/security-group. Main configuration uses modules to create: 1 VPC, 3 public subnets, 3 private subnets, IGW, NAT Gateway, route tables, basic security groups. Outputs: VPC ID, subnet IDs, NAT public IP.