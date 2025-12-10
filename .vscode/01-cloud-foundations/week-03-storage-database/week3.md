Day 15: S3 Fundamentals
Morning: Theory

Reading: Amazon S3 Overview
Amazon S3 (Simple Storage Service) is an object storage service that offers:

    Scalability: Store and retrieve any amount of data

    Durability: 99.999999999% (11 9’s)

    Availability: 99.99% availability SLA

    Security: Encryption (SSE-S3, SSE-KMS, SSE-C), bucket policies, ACLs

    Use cases: Backup, static website hosting, big data storage, etc.

Key Concepts:

    Bucket: Container for objects (globally unique name)

    Object: File + metadata (Key, Value, Version ID, Metadata)

    Storage Classes:

        S3 Standard: Frequent access

        S3 Intelligent-Tiering: Unknown/fluctuating access

        S3 Standard-IA: Infrequent access

        S3 One Zone-IA: Infrequent, non-critical data

        S3 Glacier: Archive (minutes to hours retrieval)

        S3 Glacier Deep Archive: Long-term archive (12+ hours retrieval)

    Features: Versioning, lifecycle policies, replication, events, etc.

Video: S3 Complete Guide (20 mins)

    Bucket creation and management

    Upload/download objects

    Security (IAM policies, bucket policies, ACLs)

    Static website hosting setup

    Storage class differences

Evening: Practice

Lab: Create S3 buckets with different storage classes
bash

# Steps:

1. Create S3 bucket (unique name, region selection)
2. Enable versioning
3. Upload files and assign storage classes:
   - Standard (default)
   - Standard-IA (set via lifecycle rule or object-level)
   - Glacier (via lifecycle rule for archival)
4. Verify in console

Practice: Configure bucket policies
json

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::your-bucket/*",
      "Condition": {
        "IpAddress": {"aws:SourceIp": "192.168.1.0/24"}
      }
    }
  ]
}

Day 16: EBS & EFS
Morning: Theory

Reading: EBS vs EFS

Amazon EBS (Elastic Block Store)

    Block storage for EC2 instances

    Persistence: Independent of EC2 lifecycle (except instance store)

    Use cases: Boot volumes, databases, file systems

    Types:

        SSD: gp2/gp3 (general purpose), io1/io2 (provisioned IOPS)

        HDD: st1 (throughput optimized), sc1 (cold)

    Features: Snapshots, encryption, resizing

Amazon EFS (Elastic File System)

    Managed NFS (shared file storage)

    Scalable: Petabyte-scale, grows automatically

    Multi-AZ: Highly available across AZs

    Use cases: Content management, web serving, data sharing

    Performance modes: General Purpose, Max I/O

    Throughput modes: Bursting, Provisioned

Video: Storage Services Comparison (12 mins)

    EBS: Single instance, low latency

    EFS: Multi-instance, shared access

    Instance store: ephemeral, high performance

Evening: Practice

Lab: Create EFS file system
bash

# Steps:

1. Create EFS (choose VPC, mount targets in each AZ)
2. Security: Configure security groups (NFS port 2049)
3. Mount on EC2:
   sudo yum install -y amazon-efs-utils
   sudo mount -t efs fs-123456:/ /mnt/efs

Practice: Mount EFS to multiple EC2 instances

    Launch 2+ EC2 instances

    Install EFS utils, mount same EFS

    Create file on one, verify on another (shared storage)

Day 17: RDS Fundamentals
Morning: Theory

Reading: Amazon RDS Features

    Managed relational database (MySQL, PostgreSQL, Oracle, SQL Server, MariaDB, Aurora)

    Automated: Backups, patching, scaling, failover (Multi-AZ)

    Storage types: GP2/GP3 (SSD), IO1 (provisioned IOPS)

    Deployment options:

        Single AZ

        Multi-AZ (synchronous replication)

        Read replicas (asynchronous, scaling reads)

    Security: Encryption at rest (KMS), SSL in transit, IAM auth

Video: RDS Explained (10 mins)

    Create RDS instance

    Configure security groups

    Connect using client

Evening: Practice

Lab: Create MySQL RDS instance
sql

Steps:

1. Launch RDS MySQL
   - Engine version: 8.0
   - Instance class: db.t3.micro
   - Storage: GP3 20GB
   - VPC, subnet group
   - Security group: allow 3306 from your IP
   - Enable automated backups

2. Get endpoint, username, password

3. Connect:
   mysql -h <endpoint> -u admin -p

Practice: Connect application to RDS

    Deploy a simple web app on EC2

    Update app config with RDS endpoint

    Test CRUD operations

Day 18: DynamoDB
Morning: Theory

Reading: DynamoDB Core Components

    Fully managed NoSQL (key-value, document)

    Performance: Single-digit millisecond latency

    Scalability: Auto-scaling, on-demand capacity

    Components:

        Tables: Collection of items

        Items: Row of data (max 400KB)

        Attributes: Data elements

        Partition key: Uniquely identifies item

        Sort key: Orders items within partition

    Capacity modes:

        Provisioned (RCU/WCU)

        On-demand (pay per request)

    Features: Global tables, DAX (caching), streams, TTL

Video: DynamoDB Basics (8 mins)

    Create table (partition key, sort key)

    Insert, query, scan items

    Use console and AWS CLI

Evening: Practice

Lab: Create DynamoDB table
bash

aws dynamodb create-table \
    --table-name Users \
    --attribute-definitions AttributeName=UserId,AttributeType=S \
    --key-schema AttributeName=UserId,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST

Practice: Perform CRUD operations
python

import boto3
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Users')
# Put item
table.put_item(Item={'UserId': '101', 'Name': 'John'})
# Get item
response = table.get_item(Key={'UserId': '101'})
# Query/Scan

Day 19: Storage Comparison
Morning: Theory

Reading: AWS Storage Options

Cheatsheet:

Service	Type	Use Case	Durability	Access	Latency
S3	Object	Backups, static web, big data	11 9's	REST API, HTTP	Medium
EBS	Block	Boot volumes, databases	High	Single EC2	Low
EFS	File	Shared content, web serving	High	Multiple EC2/NFS	Low-medium
RDS	Relational DB	OLTP, apps, reporting	High	SQL client	Low
DynamoDB	NoSQL	Serverless apps, high scale	11 9's	SDK, API	Single-digit ms
Glacier	Archive	Long-term backup, compliance	11 9's	Vaults, API	Minutes-hours
Instance Store	Ephemeral block	Cache, temp data	Low	Single EC2	Very low
Evening: Practice

Lab: Choose right storage for different use cases
yaml

Use cases:
1. WordPress media uploads: EFS (shared across web servers)
2. Database for e-commerce: RDS (Multi-AZ for HA)
3. User session data: DynamoDB (low latency, scalable)
4. Backup archives: S3 Glacier Deep Archive
5. EC2 root volume: EBS gp3
6. Static website: S3 + CloudFront

Practice: Cost estimation

    Use AWS Pricing Calculator

    Compare:

        S3 Standard vs S3-IA vs Glacier

        EBS gp3 vs io2

        RDS Single-AZ vs Multi-AZ

        DynamoDB provisioned vs on-demand

Day 20: Week 3 Review
Morning: Review

    Revisit notes on each service

    Understand differences: S3 vs EBS vs EFS

    When to use RDS vs DynamoDB

    Security best practices (encryption, IAM, VPC)

Video: Storage Services Summary (15 mins)

    Quick recap of all services

    Decision tree for selection

Evening: Practice

Practice Test: Storage & Database Quiz
Sample questions:

    Which service provides shared file storage for EC2? (EFS)

    How to achieve cross-region replication for S3? (CRR)

    What improves DynamoDB read performance? (DAX)

    Difference between EBS snapshot and AMI? (AMI includes instance config)

Update GitHub with storage examples
bash

Folder structure:
/week3/
  /s3-bucket-policy.json
  /efs-mount-instructions.md
  /rds-connection-guide.md
  /dynamodb-crud.py
  /storage-comparison.md

Day 21: Project Day
Deep Dive Project: WordPress with RDS

Architecture:

    Launch EC2 (WordPress) in public subnet

    Launch RDS MySQL in private subnet

    Configure security groups:

        EC2: Allow 80/443 from anywhere

        RDS: Allow 3306 from EC2 SG

    Install WordPress, point to RDS endpoint

    Store uploads on EFS for multi-instance scaling

Extend: Backup strategy with S3

    Automate RDS snapshots (daily, retention 7 days)

    Backup WordPress files to S3 using AWS CLI cron:
    bash

aws s3 sync /var/www/html s3://your-bucket/wordpress-backup/

    Enable S3 versioning and lifecycle rules to Glacier

Practice Exam: Whizlabs Test 1

    Take timed exam (65 questions, 130 minutes)

    Review incorrect answers

    Focus on:

        Storage class selection

        RDS vs DynamoDB scenarios

        Cost-optimization strategies

Key Takeaways for Week 3:

    S3: Object storage for virtually anything

    EBS: Persistent block storage for single EC2

    EFS: Shared file storage for multiple EC2

    RDS: Managed relational databases

    DynamoDB: Serverless NoSQL with high scale

    Selection criteria: Access pattern, durability, latency, cost

    Security: Always enable encryption, use IAM roles, VPC isolation

Next Steps:

    Build a 3-tier architecture using all storage types

    Implement cross-region disaster recovery with S3 CRR

    Experiment with DynamoDB Global Tables

    Explore Aurora Serverless for RDS

Resources:

    AWS Storage Whitepapers

    AWS Well-Architected Framework: Storage

    AWS Free Tier Limits – Monitor usage!
