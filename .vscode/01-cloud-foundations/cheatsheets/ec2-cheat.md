💻 EC2 CHEAT SHEET

🎯 Quick Reference
Instance Families
text

t-series: Burstable (T2/T3/T3a/T4g)
m-series: General purpose (M5/M6i)
c-series: Compute optimized (C5/C6i)
r-series: Memory optimized (R5/R6i)
i-series: Storage optimized (I3/I4i)
p-series: GPU instances (P3/P4)
g-series: Graphics instances (G4/G5)

Instance States
text

pending → running → stopping → stopped → terminated
                     ↓
                   shutting-down

Storage Types
text

EBS: Persistent, network-attached
Instance Store: Temporary, physically attached

📋 EC2 CLI Commands
Instance Management
bash

# Launch instance

aws ec2 run-instances \
    --image-id ami-0c55b159cbfafe1f0 \
    --instance-type t3.micro \
    --key-name my-key-pair \
    --security-group-ids sg-12345678 \
    --subnet-id subnet-12345678

# List instances

aws ec2 describe-instances

# Filter instances by tag

aws ec2 describe-instances --filters "Name=tag:Environment,Values=Production"

# Start instance

aws ec2 start-instances --instance-ids i-1234567890abcdef0

# Stop instance

aws ec2 stop-instances --instance-ids i-1234567890abcdef0

# Reboot instance

aws ec2 reboot-instances --instance-ids i-1234567890abcdef0

# Terminate instance

aws ec2 terminate-instances --instance-ids i-1234567890abcdef0

AMI Management
bash

# Create AMI from instance

aws ec2 create-image \
    --instance-id i-1234567890abcdef0 \
    --name "WebServer-AMI" \
    --description "AMI for web server"

# List AMIs

aws ec2 describe-images --owners self

# Deregister AMI

aws ec2 deregister-image --image-id ami-12345678

Volume & Snapshots
bash

# Create volume

aws ec2 create-volume \
    --availability-zone us-east-1a \
    --size 10 \
    --volume-type gp3

# Attach volume

aws ec2 attach-volume \
    --volume-id vol-12345678 \
    --instance-id i-1234567890abcdef0 \
    --device /dev/sdf

# Create snapshot

aws ec2 create-snapshot \
    --volume-id vol-12345678 \
    --description "Daily backup"

# List snapshots

aws ec2 describe-snapshots --owner-ids self

Security Groups
bash

# Create security group

aws ec2 create-security-group \
    --group-name WebServer-SG \
    --description "Security group for web server" \
    --vpc-id vpc-12345678

# Add inbound rule

aws ec2 authorize-security-group-ingress \
    --group-id sg-12345678 \
    --protocol tcp \
    --port 22 \
    --cidr 203.0.113.0/24

# List security groups

aws ec2 describe-security-groups

Key Pairs
bash

# Create key pair

aws ec2 create-key-pair \
    --key-name MyKeyPair \
    --key-type rsa \
    --key-format pem

# List key pairs

aws ec2 describe-key-pairs

# Delete key pair

aws ec2 delete-key-pair --key-name MyKeyPair

Elastic IPs
bash

# Allocate Elastic IP

aws ec2 allocate-address --domain vpc

# Associate with instance

aws ec2 associate-address \
    --instance-id i-1234567890abcdef0 \
    --allocation-id eipalloc-12345678

# List Elastic IPs

aws ec2 describe-addresses

# Release Elastic IP

aws ec2 release-address --allocation-id eipalloc-12345678

Tags
bash

# Create tags

aws ec2 create-tags \
    --resources i-1234567890abcdef0 vol-12345678 \
    --tags Key=Environment,Value=Production Key=Project,Value=Website

# Filter by tags

aws ec2 describe-instances \
    --filters "Name=tag:Environment,Values=Production"

⚡ Quick SSH/Connection Commands
Linux/Mac
bash

# Basic SSH

ssh -i /path/to/key.pem ec2-user@public-ip

# With specific port

ssh -i key.pem -p 22 ec2-user@public-ip

# With config file (~/.ssh/config)

Host myserver
    HostName public-ip
    User ec2-user
    IdentityFile ~/.ssh/key.pem

# Then just: ssh myserver

Windows (PowerShell)
powershell

# Using native SSH (Windows 10+)

ssh -i C:\path\to\key.pem ec2-user@public-ip

# Set correct permissions

icacls.exe key.pem /reset
icacls.exe key.pem /grant:r "$($env:username):(r)"

EC2 Instance Connect
bash

# Generate temporary SSH key

aws ec2-instance-connect send-ssh-public-key \
    --instance-id i-1234567890abcdef0 \
    --availability-zone us-east-1a \
    --instance-os-user ec2-user \
    --ssh-public-key file://~/.ssh/id_rsa.pub

# Then SSH normally

ssh -i ~/.ssh/id_rsa ec2-user@public-ip

📊 Pricing Quick Reference
Cost Comparison (us-east-1)
text

t3.micro:     $0.0104/hour  (~$7.50/month)
t3.small:     $0.0208/hour  (~$15/month)
t3.medium:    $0.0416/hour  (~$30/month)
m5.large:     $0.096/hour   (~$69/month)
r5.large:     $0.126/hour   (~$91/month)

Savings Strategies
text

On-Demand:    Flexible, no commitment
Reserved:    1-3 year commitment, ~40-70% savings
Spot:        Up to 90% off, can be interrupted
Savings Plan: Flexible commitment, ~30-70% savings

🛠️ Useful Instance Metadata
bash

# Get all metadata

curl http://169.254.169.254/latest/meta-data/

# Specific metadata

curl http://169.254.169.254/latest/meta-data/instance-id
curl http://169.254.169.254/latest/meta-data/public-ipv4
curl http://169.254.169.254/latest/meta-data/placement/availability-zone
curl http://169.254.169.254/latest/meta-data/iam/security-credentials/

🔧 Common Instance Configurations
Web Server Setup (Amazon Linux)
bash

#!/bin/bash
# User data script
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Hello World</h1>" > /var/www/html/index.html

Docker Host Setup
bash

#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user

Monitoring Agent Setup
bash

#!/bin/bash
yum install -y amazon-cloudwatch-agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c ssm:AmazonCloudWatch-ec2-linux

🚨 Troubleshooting Commands
Connectivity Issues
bash

# Check if instance is reachable

ping public-ip

# Check specific port

nc -zv public-ip 22
telnet public-ip 22

# Check from within instance

curl ifconfig.me  # Get public IP
netstat -tulpn    # Check listening ports
ss -tulpn         # Alternative

Performance Issues
bash

# CPU monitoring

top
htop
mpstat -P ALL

# Memory monitoring

free -h
vmstat 1

# Disk monitoring

df -h
iostat -x 1

# Network monitoring

iftop
nethogs

Log Investigation
bash

# System logs

sudo tail -f /var/log/messages
sudo journalctl -f

# Web server logs

sudo tail -f /var/log/httpd/access_log
sudo tail -f /var/log/httpd/error_log

# Authentication logs

sudo tail -f /var/log/secure

📝 Quick Reference Tables
Default Usernames by AMI
text

Amazon Linux:      ec2-user
Ubuntu:            ubuntu
CentOS:            centos
Debian:            admin
RHEL:              ec2-user or root
Windows:           Administrator

Common Ports
text

SSH:         22
HTTP:        80
HTTPS:       443
RDP:         3389
MySQL:       3306
PostgreSQL:  5432
Redis:       6379
MongoDB:     27017

EBS Volume Types Comparison
text

gp3:    General Purpose SSD (3,000-16,000 IOPS, 125-1,000 MB/s)
io2:    Provisioned IOPS SSD (64,000-256,000 IOPS)
st1:    Throughput Optimized HDD (500 MB/s)
sc1:    Cold HDD (250 MB/s)

🔄 Auto Scaling CLI Commands
bash

# Create launch template

aws ec2 create-launch-template \
    --launch-template-name WebServerTemplate \
    --launch-template-data '{"ImageId":"ami-12345678","InstanceType":"t3.micro"}'

# Create auto scaling group

aws autoscaling create-auto-scaling-group \
    --auto-scaling-group-name WebServer-ASG \
    --launch-template LaunchTemplateName=WebServerTemplate \
    --min-size 2 \
    --max-size 10 \
    --desired-capacity 2 \
    --vpc-zone-identifier "subnet-12345678,subnet-87654321"

Quick Tips

EC2 Tips:

    Always use termination protection for production instances

    Enable detailed monitoring for critical instances

    Use placement groups for low-latency applications

    Implement instance refresh for rolling updates

    Use AWS Systems Manager for patch management

Cost Saving Tips:

    Use Spot Instances for dev/test environments

    Implement auto-scaling to match demand

    Use AWS Instance Scheduler to stop instances during off-hours

    Right-size instances based on CloudWatch metrics

📱 Quick Commands for Mobile Reference

5 Most Used EC2 Commands:
bash

aws ec2 describe-instances
aws ec2 run-instances --image-id ami-xxx --instance-type t3.micro --key-name mykey
aws ec2 start-instances --instance-ids i-xxx
aws ec2 stop-instances --instance-ids i-xxx
aws ec2 terminate-instances --instance-ids i-xxx

🆘 Emergency Procedures
Instance Compromised:

    Isolate instance (modify security group)

    Take snapshot for forensic analysis

    Terminate instance

    Launch new instance from clean AMI

    Rotate all credentials

Accidental Termination Protection:
bash

# Enable termination protection

aws ec2 modify-instance-attribute \
    --instance-id i-1234567890abcdef0 \
    --disable-api-termination

# Check protection status

aws ec2 describe-instance-attribute \
    --instance-id i-1234567890abcdef0 \
    --attribute disableApiTermination

# EC2 Aliases

alias ec2list='aws ec2 describe-instances --query "Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType,PrivateIpAddress,PublicIpAddress,Tags[?Key==\`Name\`].Value|[0]]" --output table'
alias ec2start='aws ec2 start-instances --instance-ids'
alias ec2stop='aws ec2 stop-instances --instance-ids'
