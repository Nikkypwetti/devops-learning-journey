Week 4 Study Guide: Networking & Security (AWS Cloud Practitioner)
Overview

This week is critical—it covers ~30% of the AWS CCP exam. You'll move from understanding cloud concepts to building and securing actual cloud infrastructure. The focus is on VPC, IAM, DNS, CDN, and monitoring, forming the backbone of AWS networking and security services.
Day 22: VPC Fundamentals
Morning Session: Theory

Topic: Amazon Virtual Private Cloud (VPC)

    A VPC is your logically isolated section of AWS Cloud where you launch AWS resources (EC2, RDS, etc.).

    Think of it as your private data center in the cloud.

    Key Components to Understand:

        CIDR Blocks: The IP address range for your VPC (e.g., 10.0.0.0/16).

        Subnets: Subdivisions of your VPC's IP range. A public subnet has a route to the internet; a private subnet does not.

        Route Tables: Determine where network traffic is directed.

        Internet Gateway (IGW): Allows communication between your VPC and the public internet.

        NAT Gateway: Allows resources in a private subnet to initiate outbound internet traffic while blocking inbound traffic (for security/updates).

Learning Goal: Understand how a VPC is structured and why isolation is fundamental to cloud security.
Evening Session: Hands-On

Lab: Create a Custom VPC

    Create a VPC with a CIDR block (e.g., 10.0.0.0/16).

    Create two public subnets and two private subnets in different Availability Zones for high availability.

    Create an Internet Gateway and attach it to your VPC.

    Edit the main route table to route public subnet traffic (0.0.0.0/0) to the Internet Gateway.

    Why this matters: This is the foundational network for any application you build on AWS.

Day 23: Security Groups & NACLs
Morning Session: Theory

Topic: Security Groups vs. Network ACLs (NACLs)
This is a major exam topic. Know the differences cold.
Feature	Security Group (SG)	Network ACL (NACL)
Operates at	Instance level (EC2)	Subnet level
Rules	Stateful: Return traffic is automatically allowed	Stateless: Return traffic must be explicitly allowed
Rule Evaluation	Allow rules only (implicit deny)	Allow & Deny rules (explicit)
Order	All rules are evaluated	Rules are evaluated in number order (lowest first)

Analogy:

    SG = Personal Firewall on your laptop (controls traffic to/from that specific device).

    NACL = Building Security Guard at the gate (controls traffic entering/exiting the entire subnet).

Evening Session: Hands-On

Lab:

    Configure a Security Group for a web server.

        Create an SG that allows HTTP (port 80) and HTTPS (port 443) from anywhere (0.0.0.0/0).

        Allow SSH (port 22) only from your IP address.

    Set up NACL Rules.

        Create a NACL for a public subnet.

        Add an inbound rule to allow HTTP/HTTPS (e.g., rule #100).

        Add a "catch-all" DENY rule at the end (e.g., rule #32767).

        Key Practice: Observe the stateless behavior: you must also create outbound rules for ephemeral ports (1024-65535) to allow the return traffic.

Day 24: IAM Deep Dive
Morning Session: Theory

Topic: AWS Identity and Access Management (IAM)

    IAM controls WHO (identity) can do WHAT (action) on WHICH (resource).

    Core Components:

        Users: People or applications.

        Groups: Collection of users (e.g., "Admins," "Developers").

        Roles: For granting permissions to AWS services (EC2, Lambda) or for cross-account access.

        Policies: JSON documents that define permissions (attached to users, groups, or roles).

    Guiding Principle: LEAST PRIVILEGE—grant only the permissions required to perform a task.

Evening Session: Hands-On

Lab:

    Create an IAM Policy.

        Write a JSON policy that allows only s3:GetObject and s3:ListBucket on a specific S3 bucket.

    Create an IAM Role for EC2.

        Create a role with the AmazonS3ReadOnlyAccess managed policy.

        Launch an EC2 instance and attach this role (instead of using access keys!). This is the secure, AWS-recommended way.

    Create an IAM Group & User.

        Create a "Developers" group with a custom policy.

        Create a user, add them to the group, and test the permissions.

Day 25: Route 53 & CloudFront
Morning Session: Theory

Topic 1: Amazon Route 53

    AWS's Domain Name System (DNS) web service.

    Primary Functions:

        Domain Registration: Buy and manage domain names.

        DNS Routing: Translate www.example.com into an IP address.

        Health Checks: Route traffic away from unhealthy resources.

        Routing Policies: Simple, Weighted, Latency-based, Failover, Geolocation.

Topic 2: Amazon CloudFront

    AWS's Content Delivery Network (CDN).

    Caches static/dynamic content at Edge Locations (global data centers) close to users for low latency and high transfer speeds.

    Key Term: Origin—the source location (S3 bucket, EC2, on-prem server) where CloudFront gets its files.

Evening Session: Hands-On

Lab:

    Configure a Route 53 Hosted Zone.

        Create a public hosted zone for a domain (you can use a dummy domain like example.test).

        Create an A Record to route traffic to an EC2 instance's public IP or a CloudFront distribution.

    Set up a CloudFront Distribution.

        Create a distribution with an S3 bucket as the origin.

        Note the CloudFront Domain Name (e.g., d12345.cloudfront.net).

        Test access via the CloudFront URL vs. the S3 URL.

Day 26: Monitoring & Support
Morning Session: Theory

Topic 1: Amazon CloudWatch vs. AWS CloudTrail

    CloudWatch = Performance & Health Monitoring.

        Metrics: CPU utilization, network in/out.

        Alarms: Trigger actions (e.g., auto-scale) or send notifications based on metrics.

        Logs: Collect and store log files from AWS services.

    CloudTrail = Governance & Auditing.

        API Activity Tracking: Records who did what, when, and from where for all API calls in your AWS account.

        Delivers a log file to an S3 bucket for compliance and security analysis.

Topic 2: AWS Support Plans

    Basic: Free, 24/7 customer service, limited to account/billing support.

    Developer: Business hours email support.

    Business: 24/7 phone/email/chat support, Trusted Advisor checks, faster response times.

    Enterprise: Includes a Technical Account Manager (TAM), concierge support, and proactive guidance.

Evening Session: Hands-On

Lab:

    Set up a CloudWatch Alarm.

        Create an alarm to monitor an EC2 instance's CPU Utilization.

        Set a threshold (e.g., >70% for 5 minutes) and configure an SNS topic to send an email notification.

    Explore Trusted Advisor (if you have Business/Enterprise support or are in the Free Tier).

        Review the checks for Cost Optimization, Security, Fault Tolerance, Performance, and Service Limits.

Day 27: Final Review & Practice
Morning Session: Consolidation

    Review all four domains:

        Cloud Concepts: Shared Responsibility Model, Economies of Scale, Value propositions.

        Security: IAM, Security Groups/NACLs, MFA, KMS.

        Technology: Core Services (EC2, S3, VPC, RDS, Lambda), Global Infrastructure (Regions, AZs, Edge).

        Billing & Pricing: TCO Calculator, Support Plans, Budgets, Consolidated Billing.

Evening Session: Assessment

    Take a full 65-question, timed practice exam (like ExamPro's).

    Crucial Step: For every incorrect or guessed answer, spend 15 minutes researching the topic in the AWS documentation or your notes. This targeted review is where real learning happens.

Days 28-30: Certification Sprint
Strategy:

    Morning: Use your practice exam results to hammer your weak areas. If VPC is a problem, re-do the labs. If billing questions are tricky, re-read the pricing models.

    Evening: Simulate exam conditions. Take 2-3 full practice tests daily. Focus on question interpretation—the exam often uses scenario-based questions.

    Review: Use the "Review Incorrect Answers" feature. Understand why the correct answer is right and the others are wrong.

Final Day (Exam Day):

    Stop studying by early afternoon.

    Relax. Trust your preparation.

    Review only your concise notes or flashcards.

    Hydrate, eat a good meal, and approach the exam with confidence.

Key Mindset for Week 4:

You are no longer just learning services—you are learning how to connect and secure them. Think in terms of architectures: "How does a user securely access a web application on EC2, which reads data from a database?" The answer involves VPC, Security Groups, IAM Roles, and possibly CloudFront. This integrated understanding is what will make you pass the exam and be effective in the cloud.