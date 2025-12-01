2 (Elastic Compute Cloud) Basics - Cloud Foundation
Created: 2025-11-20
Updated: 2025-11-20
📚 Introduction to EC2
What is EC2?

Elastic Compute Cloud (EC2) is a web service that provides secure, resizable compute capacity in the cloud. It's designed to make web-scale cloud computing easier for developers.

Think of it as: Virtual servers in the cloud that you can launch in minutes.
🏗️ EC2 Core Components - Step by Step
Step 1: AMI (Amazon Machine Image)

Definition: A template that contains the software configuration (OS, application server, applications) required to launch your instance.

Types of AMIs:

    AWS Provided: Amazon Linux, Ubuntu, Windows Server, etc.

    AWS Marketplace: Pre-configured solutions (WordPress, SQL Server, etc.)

    Custom: Your own configured AMIs

Key Points:

    AMIs are region-specific

    You pay only for storage (EBS snapshots)

    AMI ID format: ami-xxxxxxxx

Step 2: Instance Types

AWS offers different instance types optimized for different use cases:
General Purpose (Balanced)

    T series: Burstable performance (CPU credits)

    M series: General purpose workloads

    Example: t3.micro, m5.large

Compute Optimized (CPU Intensive)

    C series: High-performance processors

    Use cases: Gaming servers, scientific modeling

    Example: c5.xlarge

Memory Optimized (RAM Intensive)

    R series: Memory-intensive applications

    X series: Very large memory requirements

    Use cases: In-memory databases, real-time analytics

    Example: r5.2xlarge

Storage Optimized (I/O Intensive)

    I series: Local NVMe storage

    D series: Dense storage

    Use cases: NoSQL databases, data warehousing

    Example: i3.4xlarge

Accelerated Computing (GPU/FPGA)

    P series: GPU for machine learning

    G series: Graphics-intensive applications

    Use cases: Machine learning, video encoding

    Example: p3.2xlarge

Step 3: Instance Lifecycle
text

STOPPED ←→ RUNNING ←→ TERMINATED
    ↑         ↑
    └─ START  └─ STOP/REBOOT

States:

    Pending: Being provisioned

    Running: Active and billing

    Stopping/Stopped: Not running, but persistent (EBS-backed)

    Terminated: Deleted permanently (cannot be recovered)

Step 4: Storage Options

EBS (Elastic Block Store)

    Network-attached storage

    Persistent beyond instance termination

    Multiple volume types:

        gp2/gp3: General Purpose SSD (default)

        io1/io2: Provisioned IOPS SSD (high performance)

        st1: Throughput Optimized HDD (low cost, sequential)

        sc1: Cold HDD (cheapest, infrequent access)

Instance Store

    Temporary block-level storage

    Physically attached to host

    Ephemeral: Data lost on stop/termination

    Very high I/O performance

Comparison:
text

EBS:           Instance Store:
- Persistent   - Temporary
- Network      - Physical
- Flexible     - High performance
- Additional   - Included

Step 5: Security Groups

Definition: Virtual firewalls for your EC2 instances that control inbound and outbound traffic.

Characteristics:

    Stateful (allow return traffic automatically)

    Region and VPC specific

    Can be attached to multiple instances

    Rules consist of: Protocol, Port Range, Source/Destination

Example Rule:
yaml

Type: SSH
Protocol: TCP
Port Range: 22
Source: 203.0.113.0/24 (or specific IP)

Default Behavior:

    Inbound: All traffic blocked

    Outbound: All traffic allowed

Step 6: Key Pairs

Purpose: Secure SSH/RDP access to your instances.

Types:

    RSA (default, 2048-bit)

    ED25519 (more secure, supported by some AMIs)

Important:

    Private key is downloaded ONLY at creation

    Store private key securely (cannot be recovered)

    One key pair can be used for multiple instances

📊 Quick Reference Tables

Free Tier Eligibility

Component	Free Tier	Notes
t3.micro/t2.micro	750 hours/month	Linux/Windows, 12 months
EBS Storage	30GB	General Purpose (gp2/gp3)
Elastic IP	Free when attached	Charges when idle
Snapshots	Pay for storage only	Based on used space
Common Instance Types for Beginners
Instance	vCPU	Memory	Free Tier	Best For
t3.micro	2	1GB	✅	Learning, small websites
t3.small	2	2GB	❌	Small applications
t3.medium	2	4GB	❌	Medium web apps
t3.large	2	8GB	❌	Production workloads
🎯 Your First EC2: 5-Minute Test Drive
Mini-Tutorial: Launch, Connect, Terminate
text

Step 1: Launch Instance

1. Go to AWS Console → EC2 → Launch Instance
2. Choose: "Amazon Linux 2 AMI"
3. Choose: "t3.micro" (Free tier eligible)
4. Click "Review and Launch"
5. Create new key pair → Download .pem file
6. Launch Instance

Step 2: Connect via SSH

1. Wait for "2/2 checks passed"
2. Get Public IPv4 address
3. Terminal: chmod 400 your-key.pem
4. Terminal: ssh -i your-key.pem ec2-user@<PUBLIC_IP>

Step 3: Basic Commands
$ sudo yum update -y        # Update packages
$ hostname                  # Check instance
$ df -h                     # Check disk space
$ exit                      # Disconnect

Step 4: Clean Up

1. AWS Console → EC2 → Instances
2. Select instance → Instance State → Terminate
3. Confirm termination

Important Notes for Beginners:

    Free Tier: First 12 months only, monitor usage

    Billing starts: When instance says "running"

    Billing stops: When instance is "terminated" (not stopped)

    Time zone: EC2 uses UTC time by default

🚀 Launching an EC2 Instance - Step by Step
Phase 1: Pre-Launch Preparation

Step 1: Choose AMI
text

AWS Console → EC2 → Launch Instance → Choose AMI
Considerations:

- OS preference (Linux vs Windows)
- Architecture (x86 vs ARM)
- Pre-installed software

Step 2: Select Instance Type
text

Based on requirements:

- vCPU count
- Memory (RAM)
- Storage needs
- Network performance

Step 3: Configure Instance
text

Network settings:

- VPC selection
- Subnet (Availability Zone)
- Auto-assign Public IP
- IAM Role assignment

Step 4: Add Storage
text

Root volume:

- Size (minimum varies by AMI)
- Volume type (gp3 recommended)
- Encryption (enable for security)
Additional volumes as needed

Step 5: Configure Security Group
text

Create new or select existing:

1. Allow SSH (port 22) from your IP
2. Allow HTTP (port 80) from anywhere
3. Allow HTTPS (port 443) from anywhere

Step 6: Review and Launch
text

1. Review all configurations
2. Select existing key pair or create new
3. Download private key (.pem file)
4. Launch instance

Phase 2: Post-Launch Management

Step 7: Connect to Instance
bash

# For Linux

chmod 400 key.pem
ssh -i key.pem ec2-user@<public-ip>

# For Windows

Use RDP with downloaded private key

Step 8: Monitor Instance
text

AWS Console → EC2 → Instances → Select Instance
Monitor:
- CPU utilization
- Network in/out
- Status checks
- CloudWatch alarms

⚙️ Advanced EC2 Features

1. Elastic IP Addresses

    Static IPv4 address for dynamic cloud computing

    Associated with your AWS account

    Cost: Free when attached to running instance, charges when idle

2. Placement Groups

Control how instances are placed on underlying hardware:

Types:

    Cluster: Low latency, high throughput (same rack)

    Spread: Critical applications (different hardware)

    Partition: Large distributed systems (Hadoop, Cassandra)

3. EC2 Auto Scaling

Automatically adjust number of instances based on demand.

Components:

    Launch Configuration/Template: Instance configuration

    Auto Scaling Group: Logical grouping for scaling

    Scaling Policies: Rules for scaling in/out

4. Elastic Load Balancing (ELB)

Distribute traffic across multiple instances.

Types:

    Application Load Balancer (ALB): HTTP/HTTPS (Layer 7)

    Network Load Balancer (NLB): TCP/UDP (Layer 4)

    Classic Load Balancer (CLB): Legacy (Layer 4/7)

5. Instance Metadata Service

Access instance metadata from within the instance:
bash

curl http://169.254.169.254/latest/meta-data/

Contains: instance-id, public-ip, ami-id, etc.
🧩 Simple Architecture Diagram
text

┌─────────────────────────────────────────────────────┐
│                    Your Computer                     │
│               (SSH/RDP Client)                       │
└──────────────────────────┬───────────────────────────┘
                           │ SSH (port 22) / RDP (port 3389)
                           │
┌──────────────────────────▼───────────────────────────┐
│                 AWS Cloud (Region)                   │
│                                                      │
│  ┌──────────────────────────────────────────────┐   │
│  │              Security Group                   │   │
│  │  ┌──────────────────────────────────────┐    │   │
│  │  │         EC2 Instance                  │    │   │
│  │  │  ┌──────────────────────────────┐    │    │   │
│  │  │  │    Operating System           │    │    │   │
│  │  │  │    • Amazon Linux 2          │    │    │   │
│  │  │  │    • Ubuntu                  │    │    │   │
│  │  │  │    • Windows Server          │    │    │   │
│  │  │  └──────────────────────────────┘    │    │   │
│  │  │                                       │    │   │
│  │  │  Attached Volumes:                    │    │   │
│  │  │  ┌─────────────┐ ┌─────────────┐     │    │   │
│  │  │  │   EBS       │ │  Instance   │     │    │   │
│  │  │  │  Volume     │ │   Store     │     │    │   │
│  │  │  │ (Persistent)│ │(Temporary)  │     │    │   │
│  │  │  └─────────────┘ └─────────────┘     │    │   │
│  │  └──────────────────────────────────────┘    │   │
│  │  • Inbound Rules: Allow SSH from My IP       │   │
│  │  • Outbound Rules: Allow All                 │   │
│  └──────────────────────────────────────────────┘   │
│                                                     │
│  Optional Components:                               │
│  • Elastic IP (Static Public IP) ───┐              │
│  • Auto Scaling Group ←────┐        │              │
│  • Load Balancer ←────┐    │        │              │
│  • CloudWatch Alarms  │    │        │              │
│  └────────────────────┴────┴────────┘              │
└─────────────────────────────────────────────────────┘

❓ Common Beginner Questions Answered
Q1: Will I get charged immediately?

A: No, but billing starts when:

    Instance status changes from "pending" to "running"

    You're in Free Tier? First 750 hours of t3.micro are free/month for 12 months

    Pro tip: Always terminate instances you're not using

Q2: What if I lose my .pem key file?

A: You CANNOT recover it! Options:

    Terminate and recreate the instance (loses all data)

    Stop the instance, detach root volume, attach to another instance, reset SSH keys (advanced)

    Use Session Manager (if SSM agent is installed and IAM role configured)

Q3: Stopped vs Terminated - What's the difference?
text

STOPPED:                    TERMINATED:
- Instance not running      - Instance deleted forever
- NOT billed for compute    - NOT billed for compute
- EBS volumes persist       - EBS volumes deleted (default)
- Can be started again      - Cannot be recovered
- Keeps private IP          - Everything gone

Q4: Why can't I SSH into my instance?

Troubleshooting Flowchart:
text

Can't SSH? → Check:

1. Is instance "Running"? → If no, start it
2. Security Group allows SSH from your IP? → If no, add rule
3. Using correct key pair? → If no, use correct .pem
4. Correct username? → ec2-user (Amazon Linux), ubuntu (Ubuntu), administrator (Windows)
5. Network ACLs blocking? → Check VPC settings
6. Instance in public subnet? → Needs public IP/Internet Gateway

Q5: How do I make my website accessible?

Simple steps:

    Install web server: sudo yum install httpd -y (Amazon Linux)

    Start service: sudo systemctl start httpd

    Enable auto-start: sudo systemctl enable httpd

    Add HTML: sudo echo "Hello World" > /var/www/html/index.html

    Security Group: Allow HTTP (port 80) from 0.0.0.0/0

    Visit: http://<your-public-ip>

Q6: How to save money as a beginner?

Top 5 Tips:

    Use Free Tier instances (t3.micro)

    Terminate instances when not in use

    Use Spot Instances for testing/learning (70-90% cheaper)

    Set up billing alerts in AWS Budgets

    Use AWS Instance Scheduler to auto-stop instances at night

🔒 Security Best Practices

1. Principle of Least Privilege

    Use IAM roles instead of access keys

    Restrict security group rules

    Regularly update/rotate key pairs

2. Data Protection

    Encrypt EBS volumes

    Use instance store for temporary data only

    Enable termination protection

3. Network Security

    Use VPC with private subnets

    Implement NAT Gateway for outbound traffic

    Use Security Groups + NACLs (Network ACLs)

4. Monitoring & Logging

    Enable CloudTrail for API logging

    Use CloudWatch for metrics/alarms

    Implement VPC Flow Logs

💰 Cost Optimization Strategies

1. Right Sizing

    Use CloudWatch metrics to analyze utilization

    Downgrade over-provisioned instances

    Use AWS Compute Optimizer

2. Purchase Strategies

    Use Reserved Instances for predictable workloads

    Implement Savings Plans for flexible commitment

    Leverage Spot Instances for fault-tolerant apps

3. Automation

    Auto Scale based on demand

    Schedule instances (start/stop)

    Use AWS Instance Scheduler

🐞 Troubleshooting Common Issues
Issue 1: Cannot SSH to Instance

Check:

    Security group allows SSH (port 22) from your IP

    Key pair is correct (pem file)

    Instance has public IP (or use SSH via Session Manager)

    Network ACL allows traffic

Issue 2: High CPU Utilization

Solutions:

    Check running processes: top or htop

    Consider Auto Scaling

    Upgrade instance type

    Implement caching (ElastiCache)

Issue 3: Instance Status Checks Failed

Actions:

    Reboot instance (soft restart)

    Stop and start instance (moves to new host)

    Replace instance if persistent

📊 EC2 Limits
Per Region Limits:

    Running On-Demand Instances: 5-20 vCPUs (can be increased)

    Spot Instance Requests: 20

    Elastic IPs: 5

    Security Groups: 2,500 per VPC

    EBS Volumes: 5,000

Check limits: AWS Console → EC2 → Limits
🏗️ Real-World Examples
Example 1: Web Server Setup
text

Requirements: Host a WordPress website

Solution:
1. Launch t3.medium instance (Linux)
2. Choose LAMP stack AMI
3. Attach 20GB gp3 EBS volume
4. Security Group: HTTP(80), HTTPS(443), SSH(22 from office)
5. Assign Elastic IP
6. Configure Auto Scaling min:1, max:3

Example 2: Batch Processing
text

Requirements: Process data every night

Solution:
1. Use Spot Instances (c5.large)
2. Auto Scaling Group: desired=0, max=10
3. CloudWatch Events to trigger at 2 AM
4. Process data, save to S3, terminate
5. Cost: ~70% less than On-Demand

Example 3: High Availability Architecture
text

Multi-AZ Deployment:
- Launch instances in us-east-1a and us-east-1b
- Use Application Load Balancer
- Auto Scaling Group across AZs
- RDS Multi-AZ for database
- Route53 for DNS failover

📝 Beginner's Cheat Sheet
Essential Commands:
bash

# Connect to instance

ssh -i key.pem ec2-user@IP

# Check system info

uname -a          # Kernel version
free -h           # Memory usage
df -h             # Disk space
top               # Process monitor

# Update packages (Amazon Linux)

sudo yum update -y

# Install software

sudo yum install package-name -y

Quick Security Checklist:

    Enabled SSH only from your IP

    Installed latest security updates

    Removed default/test files

    Set up billing alerts

    Regular backups (EBS snapshots)

When to Use What:

    Learning/Testing: t3.micro (Free Tier)

    Small Website: t3.small or t3.medium

    Database Server: Memory optimized (r5 series)

    Batch Processing: Spot Instances

    Production: Reserved Instances + Auto Scaling

🔗 Related Topics

    [[../vpc/vpc-basics.md]] (Networking foundation)

    [[../ebs/ebs-basics.md]] (Storage details)

    [[../elb/elb-basics.md]] (Load balancing)

    [[../auto-scaling/asg-basics.md]] (Scaling automation)

    [[../cloudwatch/cloudwatch-basics.md]] (Monitoring)

🎯 Next Steps After Mastering Basics

    Practice: Launch different instance types

    Experiment: Try Windows instances, different AMIs

    Integrate: Connect EC2 to S3, RDS

    Automate: Learn CloudFormation/Terraform

    Optimize: Implement Auto Scaling, Load Balancing

Remember: EC2 is your virtual data center in the cloud. Start simple, practice the basics, and gradually explore advanced features. The 5-minute test drive is your best starting point!

