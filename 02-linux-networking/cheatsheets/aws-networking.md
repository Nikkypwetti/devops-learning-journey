## 📁 **AWS Networking Cheatsheet**

### **File: `02-linux-networking/cheatsheets/aws-networking.md`**

# ☁️ AWS Networking Cheatsheet

## 🏗️ **AWS VPC Fundamentals**

### **VPC Components**

VPC (Virtual Private Cloud)
├── Subnets
│ ├── Public Subnet (Route to IGW)
│ └── Private Subnet (No IGW route)
├── Route Tables
├── Internet Gateway (IGW)
├── NAT Gateway
├── Security Groups
├── Network ACLs (NACLs)
└── VPC Endpoints
text


### **VPC CIDR Ranges**

Recommended CIDR blocks:
10.0.0.0/16 - 65,536 IPs (Most common)
172.16.0.0/20 - 4,096 IPs
192.168.0.0/24 - 256 IPs

Rules:

    Minimum /28 (16 IPs)

    Maximum /16 (65,536 IPs)

    Cannot overlap with other VPCs

text


### **Subnet Planning**

Example: 10.0.0.0/16 VPC
Public Subnets:
10.0.1.0/24 - AZ A Public
10.0.2.0/24 - AZ B Public
10.0.3.0/24 - AZ C Public

Private Subnets:
10.0.101.0/24 - AZ A Private
10.0.102.0/24 - AZ B Private
10.0.103.0/24 - AZ C Private

Reserved IPs in each subnet:
First IP: Network address (10.0.1.0)
Second IP: VPC Router (10.0.1.1)
Third IP: DNS Server (10.0.1.2)
Last IP: Broadcast (10.0.1.255) - Not used in AWS
text


## 🚪 **Security Groups vs NACLs**

### **Security Groups (Instance Level)**

Characteristics:
✓ Stateful (Return traffic automatically allowed)
✓ Allow rules only (No explicit deny)
✓ Evaluated first
✓ Associated with instances
✓ Can reference other security groups

Example Rules:
Inbound:

    SSH (22) from your IP only

    HTTP (80) from 0.0.0.0/0

    HTTPS (443) from 0.0.0.0/0

Outbound:

    All traffic to 0.0.0.0/0 (Default)

text


### **Network ACLs (Subnet Level)**

Characteristics:
✓ Stateless (Must specify inbound/outbound)
✓ Allow AND deny rules
✓ Evaluated after Security Groups
✓ Rule numbers matter (lower = higher priority)
✓ Associated with subnets

Example NACL Rules:
Inbound Rules:
100 Allow SSH from 192.168.1.0/24
200 Allow HTTP from 0.0.0.0/0

    Deny all

Outbound Rules:
100 Allow all to 0.0.0.0/0
text


### **Comparison Table**

Feature Security Groups NACLs
Level Instance Subnet
Stateful? Yes No
Rule Types Allow only Allow + Deny
Evaluation First Last
Association Multiple instances Single subnet
Reference SGs Yes No
text


## 🛣️ **Route Tables**

### **Public Subnet Route Table**

Destination Target Description
10.0.0.0/16 local Local VPC traffic
0.0.0.0/0 igw-12345 Internet Gateway
text


### **Private Subnet Route Table**

Destination Target Description
10.0.0.0/16 local Local VPC traffic
0.0.0.0/0 nat-12345 NAT Gateway
text


### **VPC Peering Route Table**

Destination Target Description
10.0.0.0/16 local Local VPC
10.1.0.0/16 pcx-12345 Peered VPC
0.0.0.0/0 igw-12345 Internet
text


## 🔗 **Connectivity Options**

### **Internet Gateway (IGW)**

Purpose: Connect VPC to internet
Characteristics:

    One per VPC

    Horizontally scaled

    Highly available

    No bandwidth constraints
    Use: Public subnets, outbound internet

text


### **NAT Gateway**

Purpose: Outbound internet for private subnets
Characteristics:

    Deployed in public subnet

    Requires Elastic IP

    Managed service

    45 Gbps bandwidth
    Use: Private subnets need internet access

text


### **VPC Peering**

Purpose: Connect two VPCs
Characteristics:

    Non-transitive (A⇔B, B⇔C ≠ A⇔C)

    Same or different accounts/regions

    No bandwidth constraints

    No single point of failure
    Limitations: CIDR blocks must not overlap

text


### **VPN Connections**

Site-to-Site VPN:

    Connect on-premise to AWS

    Uses Virtual Private Gateway

    IPSec tunnels

    Up to 1.25 Gbps

Client VPN:

    Connect individual users

    Uses AWS Client VPN

    OpenVPN based

    Per connection billing

text


### **Direct Connect**

Purpose: Dedicated network connection
Characteristics:

    1 Gbps or 10 Gbps ports

    Private connection

    Bypasses internet

    Predictable performance
    Use cases: High bandwidth, compliance

text


## 🔐 **Security Features**

### **VPC Flow Logs**

Purpose: Capture IP traffic information
Logs contain:

    Source/destination IP

    Ports

    Protocol

    Action (ACCEPT/REJECT)

    Can be sent to S3, CloudWatch Logs

text


### **VPC Endpoints**

Types:
Interface Endpoint (ENI) - PrivateLink
Gateway Endpoint - S3, DynamoDB

Benefits:

    Private connectivity to AWS services

    No internet gateway needed

    No NAT gateway needed

text


### **Network Firewall**

Managed firewall service
Features:

    Stateful inspection

    IPS (Intrusion Prevention)

    Web filtering

    Centralized management

text


## 🛠️ **AWS CLI Commands**

### **VPC Management**
```bash
# Create VPC
aws ec2 create-vpc --cidr-block 10.0.0.0/16

# Create Subnet
aws ec2 create-subnet \
    --vpc-id vpc-123 \
    --cidr-block 10.0.1.0/24 \
    --availability-zone us-east-1a

# Create Internet Gateway
aws ec2 create-internet-gateway
aws ec2 attach-internet-gateway \
    --vpc-id vpc-123 \
    --internet-gateway-id igw-123

# Create Route Table
aws ec2 create-route-table --vpc-id vpc-123
aws ec2 create-route \
    --route-table-id rtb-123 \
    --destination-cidr-block 0.0.0.0/0 \
    --gateway-id igw-123

Security Groups
bash

# Create Security Group
aws ec2 create-security-group \
    --group-name MySG \
    --description "My security group" \
    --vpc-id vpc-123

# Add Inbound Rule
aws ec2 authorize-security-group-ingress \
    --group-id sg-123 \
    --protocol tcp \
    --port 22 \
    --cidr 192.168.1.0/24

# Add Outbound Rule
aws ec2 authorize-security-group-egress \
    --group-id sg-123 \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0

NACL Management
bash

# Create NACL
aws ec2 create-network-acl --vpc-id vpc-123

# Add NACL Entry (Inbound)
aws ec2 create-network-acl-entry \
    --network-acl-id acl-123 \
    --rule-number 100 \
    --protocol 6 \
    --rule-action allow \
    --egress false \
    --cidr-block 0.0.0.0/0 \
    --port-range From=80,To=80

# Associate with Subnet
aws ec2 replace-network-acl-association \
    --association-id aclassoc-123 \
    --network-acl-id acl-456

📊 Networking Limits
VPC Limits (Per Region)
text

VPCs: 5 (soft, can increase)
Subnets per VPC: 200
Route tables per VPC: 200
Internet Gateways per VPC: 1
NAT Gateways per AZ: 5
Security Groups per VPC: 2,500
Rules per Security Group: 60 (inbound), 60 (outbound)
NACLs per VPC: 200
Rules per NACL: 20 (inbound), 20 (outbound)

Bandwidth Limits
text

Instance type determines bandwidth:
t2/t3.micro: Low to Moderate
m5.large: Up to 10 Gbps
c5n.18xlarge: Up to 100 Gbps

NAT Gateway: 45 Gbps
Internet Gateway: No practical limit
VPN Connection: 1.25 Gbps
Direct Connect: 1 Gbps or 10 Gbps

🎯 Best Practices
Network Design
text

1. Use multiple AZs for high availability
2. Separate public and private subnets
3. Use smallest CIDR needed
4. Leave room for expansion
5. Use naming conventions
6. Implement network segmentation

Security Best Practices
text

1. Least privilege in Security Groups
2. Use NACLs for additional protection
3. Enable VPC Flow Logs
4. Use VPC Endpoints for AWS services
5. Regular security audits
6. Implement network monitoring

Cost Optimization
text

1. Delete unused resources
2. Use VPC Endpoints to avoid NAT costs
3. Right-size instances for bandwidth needs
4. Monitor data transfer costs
5. Use same AZ for high traffic
6. Implement cost allocation tags

🔧 Troubleshooting
Common Issues and Solutions
text

Can't connect to instance:
✓ Check Security Group rules
✓ Verify NACL rules
✓ Check route table
✓ Verify instance is running
✓ Check IGW attachment

No internet from private subnet:
✓ Verify NAT Gateway in public subnet
✓ Check route table (0.0.0.0/0 → nat)
✓ Verify NAT Gateway has Elastic IP
✓ Check NACL outbound rules

VPC Peering not working:
✓ Verify CIDR blocks don't overlap
✓ Check route tables in both VPCs
✓ Verify peering connection is active
✓ Check Security Groups/NACLs

Diagnostic Commands
bash

# Check route tables
aws ec2 describe-route-tables --route-table-ids rtb-123

# Check Security Groups
aws ec2 describe-security-groups --group-ids sg-123

# Check VPC Flow Logs
aws ec2 describe-flow-logs --filter Name=resource-id,Values=vpc-123

# Test connectivity (from instance)
ping 8.8.8.8
curl http://checkip.amazonaws.com
traceroute google.com

📚 Useful References
CIDR Calculators
text

AWS VPC CIDR Calculator (built-in console)
Online calculators:
- https://www.davidc.net/sites/default/subnets/subnets.html
- https://cidr.xyz/

Port Ranges for Common Services
text

SSH: 22
HTTP: 80
HTTPS: 443
RDP: 3389
MySQL: 3306
PostgreSQL: 5432
MongoDB: 27017
Redis: 6379

AWS Networking Services
text

Amazon VPC - Virtual networking
Route 53 - DNS service
CloudFront - CDN
API Gateway - API management
Direct Connect - Dedicated connection
Global Accelerator - Improve global performance
Transit Gateway - Connect VPCs and on-premise

🎓 Quick Reference
Essential Concepts:

    VPC: Your virtual data center

    Subnet: Segment of VPC IP range

    IGW: Internet access for public subnets

    NAT: Outbound internet for private subnets

    Security Groups: Instance firewall

    NACLs: Subnet firewall

Key Commands:

    Create: create-vpc, create-subnet

    Configure: create-route, authorize-security-group-ingress

    Monitor: describe-route-tables, describe-security-groups

Important URLs:

    AWS Console VPC: https://console.aws.amazon.com/vpc/

    VPC Documentation: https://docs.aws.amazon.com/vpc/

    Networking Best Practices: https://aws.amazon.com/architecture/well-architected/

📈 Real-World Scenarios
Scenario 1: Web Application
text

Requirements:
- Public facing web servers
- Private database servers
- High availability
- Secure architecture

Solution:
VPC: 10.0.0.0/16
Public Subnets (2 AZs): 10.0.1.0/24, 10.0.2.0/24
Private Subnets (2 AZs): 10.0.101.0/24, 10.0.102.0/24

Web Tier (Public):
- Auto Scaling Group
- Load Balancer
- Security Group: 80/443 from internet

App Tier (Private):
- Auto Scaling Group
- Security Group: 8080 from Web SG

DB Tier (Private):
- RDS Multi-AZ
- Security Group: 3306 from App SG

Scenario 2: Hybrid Cloud
text

Requirements:
- Connect AWS to on-premise
- Secure communication
- High bandwidth

Solution:
Option 1: Site-to-Site VPN
- Virtual Private Gateway
- Customer Gateway
- IPSec tunnels

Option 2: Direct Connect
- Dedicated connection
- Virtual Interfaces
- Private/Public VIFs

Architecture:
On-premise ↔ VPN/Direct Connect ↔ AWS VPC

Scenario 3: Multi-Account Setup
text

Requirements:
- Separate accounts per environment
- Shared services
- Network connectivity

Solution:
AWS Organizations
- Management account
- Dev/Test/Prod accounts

Networking:
- VPC Peering between accounts
- Transit Gateway for hub-spoke
- Shared Services VPC

Security:
- IAM roles for cross-account
- SCPs for policy enforcement

🚀 Next Steps
Learning Path:

    Master VPC fundamentals

    Practice Security Groups vs NACLs

    Implement multi-AZ architecture

    Learn advanced networking (Transit Gateway)

    Study for AWS Advanced Networking Specialty

Practice Exercises:

    Create 3-tier web architecture

    Implement VPC peering

    Set up Site-to-Site VPN

    Configure VPC Flow Logs

    Design for high availability

Certification Focus:

    AWS Certified Solutions Architect - Associate

    AWS Certified Advanced Networking - Specialty

    AWS Certified Security - Specialty

Remember: AWS networking is the foundation of all AWS services. Master VPC first, then build upon it!
text


## 🚀 **How to Save These Files:**

```bash
# Navigate to your project
cd ~/devops-learning-journey/02-linux-networking/cheatsheets

# Save Linux commands cheatsheet
echo "Paste linux-commands.md content" > linux-commands.md

# Save networking concepts cheatsheet
echo "Paste networking-concepts.md content" > networking-concepts.md

# Save AWS networking cheatsheet
echo "Paste aws-networking.md content" > aws-networking.md

# Verify files were created
ls -la

🎯 How to Use These Cheatsheets:

    Print them out for quick reference

    Bookmark in your browser

    Add to VS Code as snippets

    Review daily for 10 minutes

    Practice commands until memorized

These cheatsheets cover:

    Linux Commands: 200+ essential commands with examples

    Networking Concepts: OSI model, subnetting, protocols, troubleshooting

    AWS Networking: VPC, Security Groups, NACLs, routing, best practices

