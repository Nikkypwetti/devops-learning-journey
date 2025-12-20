Week 4: Networking & Security - Hands-On Step-by-Step Guide
DAY 22: VPC FUNDAMENTALS
Morning Session - Theory Foundation

Step 1: Read Amazon VPC Guide (30 mins)

    Open AWS documentation: docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html

    Focus on these specific sections:

        Navigate to "How Amazon VPC Works"

        Read about: CIDR blocks, subnets, route tables

        Scroll to "VPC Components"

        Take notes on: Internet Gateway, NAT Gateway

        Go to "Scenarios" → "VPC with a Single Public Subnet"

        Diagram the architecture in your notes

Step 2: Watch "VPC Explained" Video (15 mins)

    Open recommended video

    While watching, create a mind map:
    text

VPC Center
├── Subnets (Public/Private)
├── Route Tables
├── Internet Gateway
├── NAT Gateway
└── Security Layers

    Pause at 8:00 mark - draw how traffic flows from Internet → IGW → Route Table → Subnet → EC2

Evening Session - Hands-On Lab

Lab: Create Custom VPC

Step 1: Access AWS Console
text

1. Login to AWS Management Console
2. Search for "VPC" in services search bar
3. Click "Your VPCs" in left sidebar

Step 2: Create VPC
text

1. Click "Create VPC"
2. Select "VPC only"
3. Configure:
   - Name tag: My-Learning-VPC
   - IPv4 CIDR block: 10.0.0.0/16
   - IPv6 CIDR block: No IPv6 CIDR block
   - Tenancy: Default
4. Click "Create VPC"

Step 3: Create Subnets
text

1. In left sidebar → Click "Subnets"
2. Click "Create subnet"
3. Select your VPC: My-Learning-VPC
4. Create Public Subnet 1:
   - Subnet name: Public-Subnet-1
   - Availability Zone: us-east-1a
   - IPv4 CIDR block: 10.0.1.0/24
5. Click "Add new subnet"
6. Create Public Subnet 2:
   - Subnet name: Public-Subnet-2
   - Availability Zone: us-east-1b
   - IPv4 CIDR block: 10.0.2.0/24
7. Click "Add new subnet"
8. Create Private Subnet 1:
   - Subnet name: Private-Subnet-1
   - Availability Zone: us-east-1a
   - IPv4 CIDR block: 10.0.3.0/24
9. Click "Create subnet"

Step 4: Create Internet Gateway
text

1. Left sidebar → "Internet Gateways"
2. Click "Create internet gateway"
3. Name: My-IGW
4. Click "Create internet gateway"
5. Select the IGW → Actions → "Attach to VPC"
6. Select: My-Learning-VPC → Attach

Step 5: Configure Route Tables
text

1. Left sidebar → "Route Tables"
2. Find the main route table (it's created automatically)
3. Click "Create route table"
   - Name: Public-Route-Table
   - VPC: My-Learning-VPC
4. Select Public-Route-Table → Routes tab → Edit routes
5. Add route:
   - Destination: 0.0.0.0/0
   - Target: Internet Gateway → Select My-IGW
6. Save changes
7. Go to "Subnet associations" tab
8. Click "Edit subnet associations"
9. Select: Public-Subnet-1 and Public-Subnet-2
10. Save associations

Step 6: Verify Setup
text

1. Create an EC2 instance in Public-Subnet-1
2. Try to SSH into it (use an existing key pair)
3. Test internet connectivity from instance:
   $ ping 8.8.8.8
   $ curl http://checkip.amazonaws.com

DAY 23: SECURITY GROUPS & NACLs
Morning Session - Theory Foundation

Step 1: Read "Security Groups vs NACLs" (20 mins)

    Open AWS documentation

    Search for "Security Groups and Network ACLs"

    Create comparison table:

Feature	Security Group	Network ACL
Level	Instance	Subnet
Stateful	Yes	No
Rules	Allow only	Allow/Deny
Evaluation	All rules	Rule number order

Step 2: Watch "SG vs NACL" Video (10 mins)

    Watch with console open

    At 5:00 mark, pause and navigate to:

        VPC → Security Groups

        VPC → Network ACLs

    Identify 3 differences you can see in the console interface

Evening Session - Hands-On Lab

Lab 1: Configure Security Groups for Web Server

Step 1: Create Security Group
text

1. Console → VPC → Security Groups → Create security group
2. Configure:
   - Security group name: WebServer-SG
   - Description: Allow web traffic
   - VPC: My-Learning-VPC
3. Inbound rules:
   - Click "Add rule"
   - Type: HTTP, Source: 0.0.0.0/0
   - Add rule: HTTPS, Source: 0.0.0.0/0
   - Add rule: SSH, Source: [Your IP Address]/32
4. Outbound rules: Leave default (All traffic)
5. Click "Create security group"

Step 2: Create Database Security Group
text

1. Create another security group:
   - Name: Database-SG
   - Description: Allow MySQL from web servers
2. Inbound rules:
   - Type: MySQL/Aurora (3306)
   - Source: Custom → WebServer-SG
3. Create

Step 3: Launch EC2 with Security Group
text

1. Console → EC2 → Launch instance
2. Select Amazon Linux 2 AMI
3. Instance type: t2.micro
4. Configure:
   - Network: My-Learning-VPC
   - Subnet: Public-Subnet-1
   - Auto-assign Public IP: Enable
5. Security group: Select existing → WebServer-SG
6. Launch (use existing key pair)
7. Note public IP address

Step 4: Test Security Group
text

1. SSH to instance (only works from your IP):
   $ ssh -i your-key.pem ec2-user@public-ip
2. Install web server:
   $ sudo yum install httpd -y
   $ sudo systemctl start httpd
3. Test HTTP access:
   Open browser → http://public-ip
   Should see Apache test page

Lab 2: Set up NACL Rules

Step 1: Create NACL
text

1. VPC → Network ACLs → Create network ACL
2. Name: Public-Subnet-NACL
3. VPC: My-Learning-VPC
4. Create

Step 2: Associate with Public Subnet
text

1. Select Public-Subnet-NACL
2. Subnet associations tab → Edit
3. Select: Public-Subnet-1
4. Save

Step 3: Configure Inbound Rules
text

Rule # | Type | Protocol | Port | Source | Allow/Deny
-------|------|----------|------|--------|-----------
100    | HTTP | TCP      | 80   | 0.0.0.0/0 | ALLOW
110    | HTTPS| TCP      | 443  | 0.0.0.0/0 | ALLOW
120    | SSH  | TCP      | 22   | Your-IP/32 | ALLOW
*      | ALL  | ALL      | ALL  | 0.0.0.0/0 | DENY

Implementation:
text

1. Inbound rules tab → Edit inbound rules
2. Add rule:
   - Rule #: 100
   - Type: HTTP (80)
   - Source: 0.0.0.0/0
   - Allow/Deny: ALLOW
3. Repeat for HTTPS (rule 110)
4. Repeat for SSH (rule 120)
5. Add final deny rule (rule # 32767):
   - Type: All traffic
   - Source: 0.0.0.0/0
   - Allow/Deny: DENY
6. Save

Step 4: Configure Outbound Rules
text

1. Outbound rules tab → Edit
2. Add rule #100: Allow all traffic to 0.0.0.0/0
3. Add rule #32767: Deny all traffic
4. Save

Step 5: Test NACL
text

1. From your computer, try SSH to EC2 (should work)
2. Try HTTP access (should work)
3. Try to access from different IP:
   - SSH should fail
   - HTTP should still work

DAY 24: IAM DEEP DIVE
Morning Session - Theory Foundation

Step 1: Read "IAM Best Practices" (25 mins)

    Open IAM documentation

    Navigate to "Security Best Practices"

    Create checklist:

        Use root account only for initial setup

        Enable MFA for all users

        Use groups to assign permissions

        Grant least privilege

        Use roles for applications

        Rotate credentials regularly

Step 2: Watch "IAM Complete Guide" (20 mins)

    Open IAM console in another tab

    Follow along:

        At 5:00 - Navigate to Users

        At 10:00 - Navigate to Policies

        At 15:00 - Navigate to Roles

Evening Session - Hands-On Lab

Lab 1: Create IAM Groups and Users

Step 1: Create Developer Group
text

1. IAM console → Groups → Create New Group
2. Group name: Developers
3. Attach policy: AmazonS3ReadOnlyAccess
4. Create group

Step 2: Create Developer User
text

1. IAM → Users → Add user
2. User details:
   - User name: john-dev
   - Access type: Programmatic access AND AWS Management Console access
   - Console password: Custom password
3. Permissions:
   - Add user to group: Select "Developers"
4. Tags: Add tag Key=Department, Value=Development
5. Review and create
6. IMPORTANT: Download CSV credentials

Step 3: Test Permissions
text

1. Open new incognito browser
2. Login with john-dev credentials
3. Try to:
   - Access S3 (should work - read only)
   - Launch EC2 instance (should fail - no permissions)

Lab 2: Create IAM Role for EC2

Step 1: Create S3 Access Role
text

1. IAM → Roles → Create role
2. Trusted entity type: AWS service
3. Use case: EC2 → Next
4. Attach policies: Search "S3" → Select "AmazonS3ReadOnlyAccess"
5. Role name: EC2-S3-ReadOnly-Role
6. Create role

Step 2: Attach Role to EC2 Instance
text

1. EC2 console → Select your web server instance
2. Actions → Security → Modify IAM role
3. Select: EC2-S3-ReadOnly-Role
4. Update

Step 3: Test Role from EC2
text

1. SSH to your EC2 instance
2. Install AWS CLI:
   $ sudo yum install aws-cli -y
3. Test S3 access (no credentials needed):
   $ aws s3 ls
   $ aws s3 cp s3://any-public-bucket/file.txt ./

Lab 3: Create Custom Policy

Step 1: Write Custom Policy
text

1. IAM → Policies → Create policy
2. JSON tab → Paste:
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::your-bucket-name",
                "arn:aws:s3:::your-bucket-name/*"
            ]
        }
    ]
}
3. Review policy:
   - Name: Specific-S3-Bucket-Read
   - Description: Read access to specific bucket only
4. Create policy

Step 2: Apply Least Privilege
text

1. Create new group: Specific-S3-Users
2. Attach your custom policy
3. Create new user
4. Add to group
5. Test: User can only access specific bucket

DAY 25: ROUTE 53 & CLOUDFRONT
Morning Session - Theory Foundation

Step 1: Read "Amazon Route 53" (20 mins)

    Open Route 53 documentation

    Focus on:

        Hosted zones (public vs private)

        Record types (A, CNAME, ALIAS)

        Routing policies (especially weighted and failover)

        Health checks

Step 2: Watch "DNS & CDN Explained" (12 mins)

    Draw DNS resolution process:
    text

Browser → Local DNS → ISP DNS → Root Server → TLD Server → Route 53 → IP Address

Draw CDN flow:
text

User → Edge Location (cache hit) → Fast response
User → Edge Location (cache miss) → Origin → Cache → Response

Evening Session - Hands-On Lab

Lab 1: Configure Route 53

Step 1: Create Hosted Zone
text

1. Route 53 console → Hosted zones → Create hosted zone
2. Configure:
   - Domain name: example-test.com (or your own domain)
   - Type: Public hosted zone
3. Create

Step 2: Create Records
text

1. In your hosted zone → Create record
2. Simple routing → Define simple record:
   - Record name: www
   - Record type: A - Routes traffic to IPv4 address
   - Value: Your EC2 instance public IP
   - Routing policy: Simple routing
3. Create records

Step 3: Test DNS Resolution
text

1. Note your hosted zone's NS records (4 servers)
2. Use dig or nslookup:
   $ dig www.example-test.com @ns-xxx.awsdns-xx.com
   Should return your EC2 IP

Lab 2: Set up CloudFront Distribution

Step 1: Prepare S3 Origin
text

1. S3 console → Create bucket
2. Name: my-cloudfront-origin-xxx (unique)
3. Upload a test file (image or HTML)
4. Make it public:
   - Select file → Actions → Make public

Step 2: Create CloudFront Distribution
text

1. CloudFront console → Create distribution
2. Origin:
   - Origin domain: Select your S3 bucket
   - Name: Auto-populated
3. Default cache behavior:
   - Viewer protocol policy: Redirect HTTP to HTTPS
   - Allowed HTTP methods: GET, HEAD
   - Cache policy: CachingOptimized
4. Settings:
   - Price class: Use Only U.S., Canada and Europe
   - Alternate domain name: Leave empty
   - SSL certificate: Default CloudFront certificate
5. Create distribution (takes 5-10 minutes)

Step 3: Test CloudFront
text

1. Note Distribution Domain Name (xxxx.cloudfront.net)
2. Test in browser:
   - http://xxxx.cloudfront.net/your-file.jpg
   - Should load from CloudFront
3. Compare with direct S3 URL

Step 4: Connect Route 53 to CloudFront
text

1. Route 53 → Your hosted zone → Create record
2. Configure:
   - Record name: cdn
   - Record type: A
   - Alias: Yes
   - Route traffic to: CloudFront distribution
   - Select your distribution
3. Create
4. Test: cdn.example-test.com/your-file.jpg

DAY 26: MONITORING & SUPPORT
Morning Session - Theory Foundation

Step 1: Read "CloudWatch vs CloudTrail" (15 mins)

    Create comparison table:

Service | Purpose | Data Type | Retention | Cost
CloudWatch | Monitoring | Metrics, Logs | 15 months | Pay per metric/log
CloudTrail | Auditing | API Calls | 90 days free | $2/100K events

Step 2: Watch "Monitoring Services" (10 mins)

    Open CloudWatch and CloudTrail consoles

    Follow along with video sections

Evening Session - Hands-On Lab

Lab 1: Set up CloudWatch Alarms

Step 1: Create Billing Alarm
text

1. CloudWatch → Alarms → Create alarm
2. Select metric: Billing → Total Estimated Charge
3. Statistic: Maximum
4. Conditions:
   - Threshold type: Static
   - Whenever EstimatedCharges is... Greater than 10 USD

5. Notification:
   - Create new SNS topic
   - Topic name: Billing-Alerts
   - Email endpoints: your-email@example.com
6. Confirm subscription in your email
7. Name alarm: Monthly-Billing-Alert
8. Create alarm

Step 2: Create EC2 CPU Alarm
text

1. EC2 console → Select your instance
2. Monitoring tab → Create alarm
3. Metric: CPU Utilization
4. Conditions: > 70% for 2 datapoints within 5 minutes
5. Notification: Select existing SNS topic (Billing-Alerts)
6. Name: High-CPU-Alert
7. Create

Step 3: Test Alarm
text

1. SSH to your EC2 instance
2. Generate CPU load:
   $ stress --cpu 2 --timeout 300
3. Wait 5-10 minutes
4. Check email for alarm notification

Lab 2: Explore Support Plans

Step 1: Review Support Plans
text

1. AWS console → Support → Support Center
2. Click "Compare plans"
3. Create feature comparison table:

| Feature | Basic | Developer | Business | Enterprise |
|---------|-------|-----------|----------|-----------|
| Cost | Free | $29/month | Starts $100 | Starts $15K |
| Response Time | N/A | 12-24 hours | < 1 hour | < 15 min |
| Tech Support | No | Yes | Yes | Yes |
| TAM | No | No | No | Yes |

Step 2: Explore Trusted Advisor
text

1. Support → Trusted Advisor
2. Note 5 categories:
   - Cost Optimization
   - Performance
   - Security
   - Fault Tolerance
   - Service Limits
3. Click each category to see recommendations

Step 3: Check Service Limits
text

1. Trusted Advisor → Service Limits
2. Note any limits close to being reached
3. Common limits to check:
   - EC2 instances
   - VPCs
   - EIPs
   - RDS instances

DAY 27: FINAL REVIEW
Morning Session: Review All Domains

Step 1: Cloud Concepts Review (30 mins)
text

1. Create flash cards for:
   - 6 Advantages of Cloud Computing
   - Cloud Models (IaaS, PaaS, SaaS)
   - Pricing Models (On-demand, Reserved, Spot)
   - AWS Global Infrastructure (Regions, AZs, Edge Locations)
2. Quiz yourself using flashcards

Step 2: Security Review (30 mins)
text

1. Draw Shared Responsibility Model diagram:
   Customer: IN the cloud (Data, Apps, IAM)
   AWS: OF the cloud (Hardware, Regions, Facilities)
2. List 5 IAM best practices
3. Explain Security Groups vs NACLs

Step 3: Technology Review (45 mins)
text

1. Draw architecture diagram connecting:
   Route 53 → CloudFront → ALB → EC2 → RDS → ElastiCache → S3
2. Write one-line descriptions for 20 core services
3. Practice identifying services from use cases

Step 4: Billing Review (15 mins)
text

1. List 5 billing tools:
   - Cost Explorer
   - Budgets
   - Cost Allocation Tags
   - TCO Calculator
   - AWS Calculator
2. Compare support plans features

Evening Session: Practice Exam

Step 1: Take Full Practice Exam
text

1. Use ExamPro or similar platform
2. Set timer: 90 minutes
3. NO distractions - simulate real exam
4. Answer all questions (flag uncertain ones)
5. Submit when finished

Step 2: Analyze Results
text

1. Calculate score by domain:
   - Cloud Concepts: ___/___
   - Security: ___/___
   - Technology: ___/___
   - Billing: ___/___
2. Identify weak domains (scoring < 70%)
3. List specific topics missed

Step 3: Create Study Plan for Days 28-30
text

1. Based on weak areas, allocate time:
   Day 28 Morning: [Weakest Domain]
   Day 28 Evening: [Second Weakest]
   Day 29: Mixed review
   Day 30: Final practice exams
2. Gather specific resources for each weak area

DAYS 28-30: CERTIFICATION PREP
Daily Schedule Template

Morning (3 hours): Focused Study
text

8:00-9:00: Review whitepapers on weak areas
9:00-10:00: Re-watch key videos
10:00-11:00: Re-do problematic labs
11:00-12:00: Create summary notes

Afternoon (2 hours): Practice Exams
text

1:00-2:30: Full timed practice exam
2:30-3:30: Review ALL answers (even correct ones)
3:30-4:00: Update error log

Evening (2 hours): Targeted Review
text

7:00-8:00: Study error log topics
8:00-9:00: Flashcards and quick quizzes

Specific Actions Each Day

Day 28 Morning: Well-Architected Framework
text

1. Read AWS Well-Architected whitepaper
2. Focus on 6 pillars:
   - Operational Excellence
   - Security
   - Reliability
   - Performance Efficiency
   - Cost Optimization
   - Sustainability
3. Create one example for each pillar

Day 28-30 Practice Exams:
text

Take exams from different sources:

- AWS Official Practice Exam
- Tutorials Dojo
- Whizlabs
- Digital Cloud Training
Track scores:
- Exam 1: ___%
- Exam 2: ___%
- Exam 3: ___%
Goal: Consistently score > 85%

Final Day Preparation

Morning (3 hours before exam):
text

1. Review error log (only)
2. Review quick-reference sheet
3. Check exam requirements:
   - Government ID ready
   - Testing area clear
   - Webcam working
   - Internet stable

1 Hour Before Exam:
text

1. Stop studying
2. Eat light meal
3. Hydrate
4. Do relaxation exercises

30 Minutes Before Exam:
text

1. Login to exam portal
2. Complete check-in process
3. Final system test

Exam Strategy Reminder

During Exam:
text

1. First pass (60 mins):
   - Answer all known questions
   - Flag uncertain questions
2. Second pass (30 mins):
   - Review flagged questions
   - Use elimination method
3. Never leave questions unanswered

Question Approach:
text

1. Identify key words in question
2. Eliminate obviously wrong answers
3. Choose BEST answer (sometimes multiple seem correct)
4. Trust your preparation

POST-EXAM ACTIONS

Immediate:
text

1. Note down any challenging topics
2. Celebrate completion
3. Wait for email results (takes up to 24 hours)

Regardless of Result:
text

1. Review score report
2. Identify areas for improvement
3. Plan next learning steps
4. Update LinkedIn with certification (if passed)

Next Steps:
text

If passed:

- Consider AWS Solutions Architect Associate
- Build portfolio projects

If need to retake:

- Schedule retake immediately
- Focus study on weak areas
- Practice more scenario-based questions

RESOURCE LINKS SUMMARY

Official Documentation:

    VPC: https://docs.aws.amazon.com/vpc/latest/userguide/

    IAM: https://docs.aws.amazon.com/IAM/latest/UserGuide/

    Route 53: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/

    CloudFront: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/

Whitepapers:

    AWS Well-Architected Framework

    Overview of AWS Security

    AWS Cloud Best Practices

Practice Exams:

    AWS Official Practice Exam ($20)

    Tutorials Dojo (highly recommended)

    ExamPro (free resources available)

Important: Save all your lab configurations - they serve as portfolio projects and reference materials for future learning.