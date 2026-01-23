# Day 27: [Three-Tier Application Architecture]

## What I Learned

Concept 1: Core Purpose of Three-Tier Architecture

    It is the standard software architecture pattern that organizes applications into three logical and physical computing tiers: Presentation, Application, and Data. This separation enhances security, scalability, and ease of maintenance.

Concept 2: The Presentation Tier (ALB)

    The external-facing layer. An Application Load Balancer (ALB) sits in the public subnets to receive user traffic (HTTP/HTTPS) and routes it to the application instances. It acts as the "front door" while hiding the backend complexity.

Concept 3: The Application Tier (ASG)

    The logic layer where processing happens. An Auto Scaling Group (ASG) manages EC2 instances across multiple Availability Zones in private subnets. This ensures the app can handle traffic spikes and remains highly available if an instance fails.

Concept 4: The Data Tier (RDS & ElastiCache)

    The storage layer. Relational Database Service (RDS) handles persistent data storage (e.g., MySQL or PostgreSQL). ElastiCache (Redis) is used to cache frequent queries, reducing the database load and improving response times.

Concept 5: Security Group Chain

    A critical security pattern where access is restricted at every layer. The ALB allows web traffic, the App Tier only accepts traffic from the ALB's Security Group, and the Data Tier only accepts traffic from the App Tier's Security Group.

Concept 6: Infrastructure Automation (Atlantis)

    Atlantis is used for Terraform Pull Request Automation. Instead of running commands locally, it allows teams to run `terraform plan` and `apply` directly via GitHub comments, providing a transparent and collaborative GitOps workflow.

Concept 7: High Availability & Fault Tolerance

    By deploying across at least two Availability Zones (AZs) and using a Multi-AZ RDS deployment, the architecture ensures that the application stays online even if a whole AWS data center goes offline.

## Code Practice Terraform

main.tf (Simplified Architecture Snippets)

1. Load Balancer (Presentation)

module "alb" { source = "terraform-aws-modules/alb/aws" name = "my-app-alb" vpc_id = module.vpc.vpc_id subnets = module.vpc.public_subnets }

2. Auto Scaling Group (Application)

module "asg" { source = "terraform-aws-modules/autoscaling/aws" name = "my-app-asg" vpc_zone_identifier = module.vpc.private_subnets min_size = 2 max_size = 5 desired_capacity = 2 }

3. RDS Instance (Data)

module "db" { source = "terraform-aws-modules/rds/aws" identifier = "my-app-db" engine = "postgres" allocated_storage = 20 db_subnet_group_name = module.vpc.database_subnet_group }

## Commands Used 

Bash
Initialize the project and modules

terraform init
Plan and apply changes manually (for initial setup)

terraform plan terraform apply
Atlantis workflow (via GitHub PR comments)

atlantis plan atlantis apply
Verify connectivity from App to DB

nc -zv <rds-endpoint> 5432

## Challenges

Problem: App instances could not connect to the RDS database.

Solution: Verified the Database Security Group. I had to ensure the Inbound rule allowed port 5432 (Postgres) specifically from the Application Tier's Security Group ID, not from the public internet.

## Resources

Video Tutorial

    Video: [https://github.com/terraform-aws-modules/terraform-aws-atlantis](https://github.com/terraform-aws-modules/terraform-aws-atlantis) (Repo Guide)

## Documentation

    Reading: [https://developer.hashicorp.com/terraform/tutorials/aws/aws-asg](https://developer.hashicorp.com/terraform/tutorials/aws/aws-asg)

## Tomorrow's Plan

Topic 1: Monitoring & Logging (CloudWatch & SNS)

Topic 2: Setting up Cost Alerts and Infrastructure Auditing
