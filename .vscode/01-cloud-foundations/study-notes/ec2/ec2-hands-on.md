EC2 Hands-On Lab: Complete Step-by-Step Guide

Created: 2025-11-29
Updated: 2025-12-1
🎯 Lab Objectives

By completing this hands-on guide, you will:

    Launch and configure EC2 instances

    Connect to instances using different methods

    Configure storage and networking

    Implement security best practices

    Automate with user data scripts

    Monitor and troubleshoot instances

📋 Prerequisites

    AWS Account (Free Tier eligible)

    Basic understanding of Linux/Windows commands

    Internet connection

🚀 LAB 1: Launch Your First EC2 Instance
Step 1: Access AWS Management Console

    Go to https://aws.amazon.com/

    Click "Sign In to the Console"

    Enter your credentials

    Important: Select region (e.g., us-east-1 - N. Virginia)

Step 2: Navigate to EC2 Service

    In AWS Console, search for "EC2" in services search bar

    Click "EC2" → You'll see EC2 Dashboard

    Note current region (top right corner)

Step 3: Launch Instance - Detailed Walkthrough
Part A: Choose AMI
text

Click: "Launch Instance" → "Launch Instance" button

AMI Options:

1. Quick Start: Amazon Linux 2023 AMI (Recommended for beginners)
2. Amazon Machine Image (AMI): 
   - Amazon Linux 2 AMI (HVM), SSD Volume Type
   - Ubuntu Server 22.04 LTS
   - Windows Server 2022

ACTION: Select "Amazon Linux 2023 AMI" (64-bit x86)

Part B: Select Instance Type
text

Instance Type Options:

- t2.micro: 1 vCPU, 1 GiB RAM (Free Tier eligible)
- t3.micro: 2 vCPU, 1 GiB RAM (Free Tier eligible)
- t3.small: 2 vCPU, 2 GiB RAM
- t3.medium: 2 vCPU, 4 GiB RAM

ACTION: Select "t3.micro" (Free Tier eligible)
→ Click "Next: Configure Instance Details"

Part C: Configure Instance Details
text

Important Settings:

1. Number of instances: 1 (default)
2. Network: Default VPC (vpc-xxxxxx)
3. Subnet: No preference (default)
4. Auto-assign Public IP: Enable
5. IAM role: None (for now)
6. Shutdown behavior: Stop
7. Enable termination protection: ☑ Check this!

User data (optional - we'll use this later)

ACTION: Leave defaults, enable termination protection
→ Click "Next: Add Storage"

Part D: Configure Storage
text

Root Volume (Already added):

- Size: 8 GB (Free Tier: 30 GB total)
- Volume Type: gp3 (General Purpose SSD)
- IOPS: 3000 (default)
- Throughput: 125 MB/s (default)
- Delete on termination: ☑ Enabled (Recommended for learning)

Add New Volume (Optional):

- Click "Add New Volume"
- Size: 5 GB
- Volume Type: gp3
- Delete on termination: ☑ Enabled

ACTION: Keep root volume at 8 GB
→ Click "Next: Add Tags"

Part E: Add Tags
text

Tags help organize resources:

1. Click "Add tag"
2. Key: Name
3. Value: My-First-EC2-Instance
4. Click "Add tag" again:
   - Key: Environment
   - Value: Development
   - Key: Project
   - Value: EC2-Learning

ACTION: Add these 3 tags
→ Click "Next: Configure Security Group"

Part F: Configure Security Group
text

Security Group: Think of it as a firewall

Option 1: Create new security group
Name: my-first-security-group
Description: Allow SSH and HTTP

Rules to Add:

1. SSH: Allow from "My IP" (automatically detects)
2. HTTP: Allow from "Anywhere" (0.0.0.0/0)
3. HTTPS: Allow from "Anywhere" (0.0.0.0/0)

ACTION: Create new security group with above rules
→ Click "Review and Launch"

Part G: Review and Launch
text

1. Review all configurations
2. Scroll through all sections
3. Note:
   - Instance type: t3.micro
   - Security group: Allows SSH, HTTP, HTTPS
   - Storage: 8 GB gp3
   - Tags: Name, Environment, Project

ACTION: Click "Launch"

Part H: Select Key Pair
text

CRITICAL STEP: Key Pair Selection

Option 1: Create new key pair (Recommended for first time)

1. Select "Create a new key pair"
2. Key pair name: ec2-key-pair-nov2025
3. Key pair type: RSA
4. Private key file format: .pem (for Linux/Mac) or .ppk (for Windows/PuTTY)
5. Click "Download Key Pair"
6. ⚠️ Save in secure location (CANNOT download again!)

Option 2: Use existing key pair (if you have one)

ACTION: Create new key pair, download, save securely
→ Click "Launch Instances"

Part I: Launch Status
text

You'll see: "Your instances are now launching"
Click "View Instances"

You should see:

- Instance ID: i-xxxxxxxxxxxxx
- Instance state: "Pending" → "Running" (takes 1-2 minutes)
- Status checks: "Initializing" → "2/2 checks passed"

🔗 LAB 2: Connect to Your EC2 Instance
Method 1: SSH Connection (Linux/Mac)
Step 1: Prepare Your Key
bash

# Open terminal

cd ~/Downloads  # Or where you saved .pem file

# Change permissions (CRITICAL)

chmod 400 ec2-key-pair-nov2025.pem

# Verify permissions

ls -la ec2-key-pair-nov2025.pem
# Should show: -r-------- (read only for owner)

Step 2: Get Connection Details
text

In EC2 Console:
1. Select your instance

2. Note: Public IPv4 address (e.g., 54.123.45.67)
3. Note: Username for AMI:
   - Amazon Linux: ec2-user
   - Ubuntu: ubuntu
   - CentOS: centos

Step 3: Connect via SSH
bash

# Basic connection

ssh -i ec2-key-pair-nov2025.pem ec2-user@<PUBLIC_IP>

# Example:

ssh -i ec2-key-pair-nov2025.pem ec2-user@54.123.45.67

# First connection will ask:

Are you sure you want to continue connecting (yes/no)? 
Type: yes

Step 4: Verify Connection
bash

# Once connected, run:

whoami          # Should show: ec2-user
hostname        # Should show instance hostname
df -h           # Check disk space
free -h         # Check memory

Method 2: EC2 Instance Connect (Browser)
Step 1: Select Instance
text

In EC2 Console:

1. Select your instance
2. Click "Connect" button (top right)
3. Select "EC2 Instance Connect" tab

Step 2: Connect via Browser
text

1. Keep default settings
2. Username: ec2-user (auto-filled)
3. Click "Connect"

✅ You now have browser-based terminal!

Step 3: Test Commands
bash

# In browser terminal:

echo "Hello from EC2 Instance Connect"
sudo yum update -y

Method 3: Session Manager (No SSH Key Needed)
Step 1: Configure IAM Role
text

1. Go to IAM Console
2. Create role:
   - Trusted entity: AWS service
   - Service: EC2
   - Attach policy: AmazonSSMManagedInstanceCore
   - Role name: SSM-Role

Step 2: Attach Role to Instance
text

1. In EC2 Console, select instance
2. Actions → Security → Modify IAM role
3. Select: SSM-Role
4. Save

Step 3: Connect via Session Manager
text

1. Wait 1-2 minutes for role propagation
2. Select instance → Click "Connect"
3. Select "Session Manager" tab
4. Click "Connect"

✅ Connected without SSH keys!

Method 4: RDP for Windows Instances
Step 1: Launch Windows Instance
text

Same as Linux but:

1. AMI: Windows Server 2022 Base
2. Instance type: t3.micro
3. Key pair: Create/download .pem
4. Security Group: Allow RDP (port 3389) from My IP

Step 2: Get Password
text

1. Wait for instance running
2. Select instance → Actions → Security → Get Windows password
3. Upload .pem file
4. Decrypt password
5. Copy password

Step 3: Connect via RDP
text

1. On Windows: Open Remote Desktop Connection
2. Computer: <Public_IP>
3. Username: Administrator
4. Password: <Decrypted password>
5. Connect

💾 LAB 3: Storage Operations
Exercise 1: Attach Additional EBS Volume
Step 1: Create EBS Volume
text

EC2 Console → Volumes (left sidebar) → Create volume

- Size: 10 GB
- Volume type: gp3
- Availability Zone: SAME as your instance
- Tags: Name=Data-Volume
- Click "Create volume"

Step 2: Attach Volume to Instance
text

1. Select new volume → Actions → Attach volume
2. Instance: Select your instance
3. Device name: /dev/sdf (or /dev/xvdf)
4. Click "Attach"

Step 3: Connect and Configure Volume
bash

# SSH into instance

ssh -i key.pem ec2-user@<IP>

# Check if volume is detected

lsblk
# Should show: xvdf (or similar)

# Create filesystem

sudo mkfs -t xfs /dev/xvdf

# Create mount point

sudo mkdir /data

# Mount volume

sudo mount /dev/xvdf /data

# Verify

df -h
# Should show /data mounted

# Make mount permanent
sudo sh -c 'echo "/dev/xvdf /data xfs defaults 0 0" >> /etc/fstab'

Exercise 2: Take EBS Snapshot
Step 1: Create Snapshot
text

EC2 Console → Snapshots (left sidebar) → Create snapshot

- Resource type: Volume
- Volume ID: Select your root volume
- Description: Backup-before-changes
- Tags: Name=Root-Volume-Backup
- Click "Create snapshot"

Step 2: Monitor Snapshot Creation
text

1. Go to Snapshots
2. Find your snapshot
3. Status: "Pending" → "Completed"
4. Note: Time taken (few minutes)

Step 3: Create Volume from Snapshot
text

1. Select snapshot → Actions → Create volume from snapshot
2. Size: 8 GB (or larger)
3. Volume type: gp3
4. Availability Zone: Same as instance
5. Click "Create volume"

🌐 LAB 4: Networking Configuration
Exercise 1: Elastic IP Association
Step 1: Allocate Elastic IP
text

EC2 Console → Elastic IPs (left sidebar) → Allocate Elastic IP address

- IPv4 address pool: Amazon's pool
- Tags: Name=My-Static-IP
- Click "Allocate"

Step 2: Associate with Instance
text

1. Select Elastic IP → Actions → Associate Elastic IP address
2. Resource type: Instance
3. Instance: Select your instance
4. Private IP: Auto-select
5. Click "Associate"

Step 3: Verify
text

1. Check instance details
2. Public IP should now be Elastic IP
3. Disconnect SSH
4. Reconnect using Elastic IP

Exercise 2: Modify Security Group
Step 1: Add Custom Port
text

1. Select instance
2. Security tab → Click security group ID
3. Inbound rules → Edit inbound rules
4. Add rule:
   - Type: Custom TCP
   - Port range: 8080
   - Source: Anywhere (0.0.0.0/0)
5. Save rules

Step 2: Test Port Opening
bash

# On EC2 instance, install netcat

sudo yum install nc -y

# Listen on port 8080

nc -l 8080 &

# From your local machine, test

telnet <ELASTIC_IP> 8080

# Or use: nc -zv <IP> 8080

⚙️ LAB 5: Automation with User Data
Exercise 1: Launch Instance with Web Server
Step 1: Create User Data Script
bash

#!/bin/bash

# Update system

yum update -y

# Install Apache

yum install -y httpd

# Start Apache

systemctl start httpd
systemctl enable httpd

# Create index.html


echo "<h1>Hello from User Data Script!</h1>" > /var/www/html/index.html
echo "<p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>" >> /var/www/html/index.html
echo "<p>Availability Zone: $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>" >> /var/www/html/index.html

Step 2: Launch Instance with Script
text

1. Launch new instance (same steps as Lab 1)
2. In "Configure Instance Details" step
3. Scroll to "Advanced details"
4. In "User data" box, paste script
5. Complete launch

Step 3: Test Web Server
text

1. Wait 2-3 minutes for script to run
2. Get public IP of new instance
3. Open browser: http://<PUBLIC_IP>
4. Should see your custom page

Exercise 2: User Data for Configuration
Step 1: Launch with Environment Setup
bash

#!/bin/bash
# Advanced user data script

# Set hostname

hostnamectl set-hostname web-server-01

# Install multiple packages

yum install -y httpd mariadb-server php php-mysqlnd git

# Configure firewall

systemctl start firewalld
systemctl enable firewalld
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload

# Create user

useradd -m -s /bin/bash developer
echo "developer:Password123!" | chpasswd

# Log actions

echo "User data script completed at $(date)" >> /var/log/user-data.log

📊 LAB 6: Monitoring and Metrics
Exercise 1: Enable Detailed Monitoring
Step 1: Modify Instance
text

1. Select instance → Actions → Instance settings → Modify detailed monitoring
2. Enable: Detailed monitoring (1-minute intervals)
3. Click "Save"

Step 2: View CloudWatch Metrics
text

1. Go to CloudWatch Console
2. Metrics → All metrics
3. EC2 → Per-Instance Metrics
4. Select your instance
5. View: CPUUtilization, NetworkIn, NetworkOut

Exercise 2: Create CloudWatch Alarm
Step 1: Create High CPU Alarm
text

CloudWatch Console → Alarms → Create alarm

1. Select metric: EC2 → Per-Instance Metrics → CPUUtilization
2. Select your instance
3. Conditions:
   - Threshold type: Static
   - Whenever CPUUtilization is: Greater > 70
   - Period: 5 minutes
4. Notification: (Skip for now)
5. Alarm name: High-CPU-Alarm
6. Click "Create alarm"

Step 2: Test Alarm
bash

# SSH into instance
# Generate CPU load
sudo yum install stress-ng -y
stress-ng --cpu 4 --timeout 300
# Check CloudWatch alarm in 5-10 minutes

🔧 LAB 7: Instance Management
Exercise 1: Stop and Start Instance
Step 1: Stop Instance
text

EC2 Console → Select instance
Actions → Instance state → Stop instance
- Confirm: Yes, stop
- Status: "stopping" → "stopped"

Step 2: Note Changes
text

1. Public IP changes after stop/start
2. Elastic IP remains same (if attached)
3. Data on EBS volumes persists
4. Instance store data lost

Step 3: Start Instance
text

Actions → Instance state → Start instance
- Wait for "running"
- Check new public IP

Exercise 2: Reboot vs Stop/Start
Test 1: Reboot
bash

# Connect to instance

sudo reboot
# Or from console: Actions → Instance state → Reboot instance
# Public IP remains same
# Faster (1-2 minutes)

Test 2: Stop then Start
text

From console: Stop, wait, then Start
- Public IP changes
- May move to different host
- Takes longer (3-5 minutes)

Exercise 3: Modify Instance Type
Step 1: Stop Instance
text

1. Instance must be STOPPED
2. Actions → Instance state → Stop
3. Wait for "stopped"

Step 2: Change Instance Type
text

Actions → Instance settings → Change instance type
- New instance type: t3.small
- Apply

Step 3: Start and Verify
text

1. Start instance
2. Connect via SSH
3. Check resources:
   free -h    # Should show 2GB RAM
   nproc      # Should show 2 CPUs

🛡️ LAB 8: Security Hardening
Exercise 1: Implement Security Best Practices
Step 1: Disable Password Authentication
bash

# On your instance

sudo vi /etc/ssh/sshd_config

# Find and change:

PasswordAuthentication no
ChallengeResponseAuthentication no

# Restart SSH

sudo systemctl restart sshd

# Test: Try logging in with wrong key

# Should fail immediately

Step 2: Create New User with Sudo
bash

# Create user

sudo useradd -m -s /bin/bash adminuser
sudo passwd adminuser  # Set password

# Add to sudoers

sudo usermod -aG wheel adminuser

# Test new user

su - adminuser
sudo whoami  # Should work

Step 3: Configure Firewall
bash

# Install and configure firewalld

sudo yum install firewalld -y
sudo systemctl start firewalld
sudo systemctl enable firewalld

# Allow only necessary ports

sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload

# List rules


sudo firewall-cmd --list-all

Exercise 2: IAM Role Attachment
Step 1: Create IAM Role for S3 Access
text

IAM Console → Roles → Create role

1. Trusted entity: AWS service → EC2
2. Permissions: AmazonS3ReadOnlyAccess
3. Role name: EC2-S3-ReadOnly-Role
4. Create role

Step 2: Attach Role to Instance
text

EC2 Console → Select instance
Actions → Security → Modify IAM role
- Select: EC2-S3-ReadOnly-Role
- Update IAM role

Step 3: Test S3 Access from Instance
bash

# SSH into instance

# List S3 buckets (no credentials needed!)
aws s3 ls

# Try accessing specific bucket

aws s3 ls s3://<bucket-name>/

🧪 LAB 9: Troubleshooting Scenarios
Scenario 1: SSH Connection Failed
Problem: "Connection timed out"
bash

# Diagnostic steps:

# 1. Check instance state

# Console: Is it "Running"?

# 2. Check security group

# Console: Security tab → Inbound rules → SSH allowed from your IP?

# 3. Check network ACL

# VPC Console → Network ACLs → Inbound rules allow SSH?

# 4. Check route table

# Instance in public subnet? Needs Internet Gateway

# 5. Check instance connectivity

# Console: Actions → Instance state → Reboot

Solution Steps:
text

1. Modify security group:
   - Add SSH rule from 0.0.0.0/0 (temporarily)
   - Test connection
   - If works: Your IP changed (dynamic IP)

2. Check key permissions:
   chmod 400 key.pem


3. Try EC2 Instance Connect (bypasses network issues)

Scenario 2: Instance Unresponsive
Diagnosis:
text

1. Status checks: "2/2 checks failed"
2. Cannot SSH
3. Website not responding

Recovery Steps:
text

Option 1: Reboot
Actions → Instance state → Reboot instance

Option 2: Stop and Start
Actions → Instance state → Stop, then Start

Option 3: Replace instance (last resort)

1. Create AMI of instance
2. Launch new instance from AMI
3. Terminate old instance

Scenario 3: Disk Space Full
Diagnosis:
bash

# On instance (if you can connect)

df -h  # Check disk usage
du -sh /var/log/  # Check log directory

Cleanup Steps:
bash

# Clear package cache

sudo yum clean all

# Clear journal logs

sudo journalctl --vacuum-time=2d

# Find large files

sudo find / -type f -size +100M 2>/dev/null

# Clear /tmp

sudo rm -rf /tmp/*

🧹 LAB 10: Cleanup and Cost Management
Exercise 1: Terminate Resources
Step 1: Terminate Instance
text

EC2 Console → Select instance
Actions → Instance state → Terminate instance
- Confirm termination
- Status: "shutting-down" → "terminated"
- Associated EBS volumes deleted (if Delete on Termination enabled)

Step 2: Release Elastic IP
text

Elastic IPs → Select IP → Actions → Release Elastic IP addresses
- Confirm release
- ⚠️ Charges apply if kept allocated but not attached

Step 3: Delete Volumes and Snapshots
text

Volumes:

1. Select unattached volumes
2. Actions → Delete volume

Snapshots:

1. Select snapshots
2. Actions → Delete snapshot

Exercise 2: Cost Monitoring
Step 1: Enable Cost Explorer
text

AWS Console → Cost Management → Cost Explorer

- Click "Enable Cost Explorer"
- Wait 24 hours for data

Step 2: Set Billing Alarms
text

CloudWatch Console → Alarms → Create alarm

1. Select metric: Billing → Total Estimated Charge
2. Currency: USD
3. Threshold: > 10.00 (for Free Tier monitoring)
4. Notification: Email yourself
5. Create alarm

📝 Hands-On Checklist
✅ Basic Competency (Complete These First)

    Launch Linux instance with t3.micro

    Create and download key pair

    SSH into instance

    Install web server (Apache/Nginx)

    Access website via browser

    Take EBS snapshot

    Terminate instance

✅ Intermediate Skills

    Attach additional EBS volume

    Mount and format volume

    Configure Elastic IP

    Modify security groups

    Use user data scripts

    Create CloudWatch alarms

    Attach IAM role

    Stop/Start/Reboot instances

✅ Advanced Operations

    Create custom AMI

    Configure load balancer

    Set up Auto Scaling group

    Implement instance metadata security

    Use Systems Manager Session Manager

    Configure instance placement groups

    Implement cost optimization strategies

🚨 Important Notes & Best Practices
Security Notes:

    Never share .pem files

    Use IAM roles instead of access keys

    Enable MFA for AWS account

    Regularly rotate key pairs

    Apply principle of least privilege

Cost Management:

    Always terminate instances you're not using

    Use Spot Instances for testing

    Set up billing alarms

    Review Cost Explorer weekly

    Use AWS Budgets

Performance Tips:

    Right-size instances (don't over-provision)

    Use EBS-optimized instances for storage-intensive apps

    Place instances in same AZ for low-latency communication

    Use placement groups for clustered applications

Backup Strategy:

    Regular EBS snapshots

    Automate snapshots with Lambda

    Store AMIs in multiple regions

    Test recovery procedures

🆘 Common Errors and Solutions

Error	Solution
"Permission denied (publickey)"	chmod 400 key.pem or wrong key
"Connection timed out"	Check security group, network ACL
"Instance terminated immediately"	Check subnet, IAM role, user data errors
"Volume in use"	Detach volume before deleting
"Insufficient instance capacity"	Try different AZ or instance type

📚 Next Steps After This Lab

    Explore VPC Networking:

        Create custom VPC with public/private subnets

        Configure NAT Gateway

        Set up VPC peering

    Advanced EC2 Features:

        Spot Instances and Spot Fleet

        Reserved Instances purchase

        Dedicated Hosts

    Integration with Other Services:

        EC2 + RDS (database)

        EC2 + S3 (storage)

        EC2 + Lambda (serverless)

    Infrastructure as Code:

        Learn CloudFormation

        Learn Terraform

        Automate entire stack deployment

🎓 Verification Tests
Test Your Knowledge:
bash

# Connect to a fresh instance and run:

echo "### System Info ###"
uname -a
free -h
df -h

echo "### Network Info ###"
curl http://169.254.169.254/latest/meta-data/public-ipv4
curl http://169.254.169.254/latest/meta-data/instance-id

echo "### Security ###"
aws iam get-role --role-name $(curl -s http://169.254.169.254/latest/meta-data/iam/info | grep -o 'arn:aws:iam::[^/]*' | cut -d: -f6) 2>/dev/null || echo "No IAM role"

echo "### Web Server Test ###"
systemctl is-active httpd 2>/dev/null && echo "Apache is running" || echo "No web server"

💡 Pro Tips for Real Projects

    Always tag resources (Name, Environment, Owner, CostCenter)

    Use CloudFormation/Terraform from day one

    Implement monitoring before going to production

    Test disaster recovery procedures

    Document everything (architecture, procedures, contacts)

Remember: Practice makes perfect. Launch instances, break things, fix them, and learn from mistakes. EC2 is the foundation of AWS, and mastering it opens doors to all other AWS services.