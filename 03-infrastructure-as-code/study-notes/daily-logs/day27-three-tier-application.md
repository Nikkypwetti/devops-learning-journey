# Day 27: Mastering the Three-Tier Architecture

Overview

Today’s focus was on the Three-Tier Architecture, the industry standard for building scalable, secure, and highly available applications. This architecture separates the application into three layers, ensuring that a failure or security breach in one layer doesn't necessarily compromise the others.

1. The Component Breakdown

I focused on orchestrating four key AWS resources using Terraform to form the backbone of the system:

    Presentation Tier (ALB): * The "entry point." The Application Load Balancer sits in the public subnet.

        It handles incoming HTTP/HTTPS traffic and distributes it across the application instances.

    Application Tier (ASG): * The "brains." The Auto Scaling Group manages EC2 instances in private subnets.

        It ensures high availability by automatically scaling instances in or out based on CPU/RAM usage.

    Data Tier (RDS & ElastiCache): * The "memory." RDS handles persistent data (SQL), while ElastiCache (Redis/Memcached) provides an in-memory caching layer to speed up read-heavy workloads.

        These are tucked away in the deepest private subnets for maximum security.

2. Deep Dive: Infrastructure as Code (IaC) with Atlantis

A major part of today was exploring Atlantis via the terraform-aws-atlantis module.

Key Takeaway: In a real DevOps workflow, we don't run terraform apply from a local terminal.

    GitOps Workflow: Atlantis listens for Pull Requests on GitHub.

    Visibility: It runs terraform plan and sticks the output right in the PR comments for teammates to review.

    Safety: The atlantis apply command only happens after approval, keeping the state file consistent and preventing "cowboy coding" on production infrastructure.

3. Implementation Logic (The "How-To")

When writing the Terraform code for this, I followed these networking rules:

    VPC: Created 3 tiers of subnets (Public, Private App, Private Data).

    Security Group Chain:

        ALB SG: Allows 80/443 from 0.0.0.0/0.

        App SG: Only allows traffic from the ALB Security Group.

        DB SG: Only allows traffic from the App Security Group.

4. Daily Reflection

    What went well: Understanding the traffic flow from the internet → ALB → EC2 → RDS.

    Challenges: Configuring the security groups correctly to allow the App Tier to talk to ElastiCache without opening it to the public.

    Next Steps: Verify the failover mechanism by manually terminating an instance in the ASG to see if it self-heals.