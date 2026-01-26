# Amazon S3 (Simple Storage Service) - Cloud Foundation

Created: 2025-12-6
Updated: 2025-12-6

## AWS S3 Comprehensive Study Notes

## 📚 Introduction to S3

**What is S3?**

Amazon Simple Storage Service (S3) is an object storage service that offers industry-leading scalability, data availability, security, and performance.

Think of it as: Infinite storage in the cloud with 99.999999999% (11 9's) durability.
🏗️ Core Concepts - Step by Step
Step 1: Understanding S3 Structure
text

Account → Region → Bucket → Object (File)
                                  ↑
                              Key (Path + Filename)

Step 2: Key Components
A. Buckets

    Container for objects

    Region-specific (choose region at creation)

    Globally unique name (across ALL AWS accounts)

    Maximum: 100 buckets per account (soft limit)

    Naming rules:

        3-63 characters

        Lowercase letters, numbers, dots, hyphens

        Must start/end with letter or number

        No underscores, no IP addresses

B. Objects

    Files + Metadata stored in buckets

    Composed of:

        Key: Full path + filename (e.g., photos/vacation/beach.jpg)

        Value: Actual data (file content)

        Version ID: Unique identifier (if versioning enabled)

        Metadata: System/user-defined data

        Access Control: Permissions

C. Keys

    Object identifier within bucket

    Hierarchical like file system paths

    Examples:
    text

my-bucket/
├── projects/
│   ├── report.pdf          (Key: "projects/report.pdf")
│   └── data/
│       └── dataset.csv     (Key: "projects/data/dataset.csv")
├── images/
│   └── logo.png            (Key: "images/logo.png")
└── index.html              (Key: "index.html")

## 📦 S3 Storage Classes

1. STANDARD (Default)
text

Use case: Frequently accessed data
Availability: 99.99%
Durability: 99.999999999% (11 9's)
Minimum storage duration: None
Retrieval fee: None
Best for: Websites, content distribution, big data analytics

2. STANDARD_IA (Infrequent Access)
text

Use case: Long-lived, less frequently accessed data
Availability: 99.9%
Durability: 99.999999999%
Minimum storage duration: 30 days
Retrieval fee: Per GB retrieved
Best for: Backup, disaster recovery

3. ONEZONE_IA
text

Use case: Recreatable data accessed infrequently
Availability: 99.5%
Durability: 99.999999999%
Minimum storage duration: 30 days
Retrieval fee: Per GB retrieved
Single AZ only (lower cost)
Best for: Backup copies, secondary backups

4. INTELLIGENT_TIERING
text

Use case: Unknown/Changing access patterns
Features: Automatically moves between frequent/infrequent tiers
Monitoring fee: Small monthly fee
No retrieval fees
Best for: Data with unknown/changing access patterns

5. GLACIER (Archive)
text

Use case: Long-term archive
Retrieval time: Minutes to hours
Minimum storage duration: 90 days
Retrieval fee: Per GB retrieved + request fee
Best for: Compliance archives, long-term backups

6. GLACIER_DEEP_ARCHIVE
text

Use case: Rarely accessed data
Retrieval time: 12 hours
Minimum storage duration: 180 days
Lowest cost storage
Best for: Regulatory/long-term data that rarely needs access

## 🔐 Security & Access Control

1. Bucket Policies (JSON-based)

Resource-level permissions applied to buckets
json

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::example-bucket/*"
        }
    ]
}

2. Access Control Lists (ACLs)

Legacy method for granular permissions

    Less flexible than policies

    Can grant permissions to:

        AWS accounts

        Predefined groups

        Public access

3. IAM Policies

**Identity-based permissions for users/roles**
json

{
    "Effect": "Allow",
    "Action": [
        "s3:GetObject",
        "s3:PutObject"
    ],
    "Resource": "arn:aws:s3:::my-bucket/*"
}

4. Block Public Access

Four settings to prevent accidental public access:

    Block public access via ACLs

    Block public access via policies

    Block public cross-account access via ACLs

    Block public cross-account access via policies

## Best Practice: Always enable all four for non-public buckets

**⚡ S3 Features**

1. Versioning

    Keep multiple versions of objects

    Once enabled, cannot be disabled (only suspended)

    Protects against accidental deletion

    All versions count toward storage costs

2. Lifecycle Rules

## Automate transitions between storage classes

json

{
    "Rules": [
        {
            "ID": "Move to IA after 30 days",
            "Status": "Enabled",
            "Prefix": "logs/",
            "Transitions": [
                {
                    "Days": 30,
                    "StorageClass": "STANDARD_IA"
                }
            ]
        }
    ]
}

3. Cross-Region Replication (CRR)

    Automatic, asynchronous replication

    Requires versioning enabled on source & destination

    Use cases: Compliance, lower latency, backup

4. Transfer Acceleration

    Uses CloudFront Edge Locations

    Faster transfers over long distances

    Endpoint: bucket-name.s3-accelerate.amazonaws.com

5. Event Notifications

Trigger actions when objects are:

    Created (Put, Post, Copy)

    Removed (Delete)

    Restored from Glacier

Destinations:

    SNS (Simple Notification Service)

    SQS (Simple Queue Service)

    Lambda (Serverless functions)

6. S3 Select & Glacier Select

    Retrieve subsets of objects using SQL

    Reduces data transfer costs

    Improves performance

7. Presigned URLs

    Time-limited URLs for object access

    No AWS credentials needed for users

    Expires after specified time

## 💰 S3 Pricing Model

**Cost Components:**

    Storage (per GB/month)

    Requests (PUT, GET, LIST, etc.)

    Data Transfer

        Out to internet

        Cross-region replication

    Management Features

        Inventory, analytics, object tags

Cost Optimization Tips:

    Choose right storage class

    Enable S3 Intelligent-Tiering for unknown patterns

    Use lifecycle policies to move old data

    Compress data before uploading

    Use S3 Select to retrieve only needed data

## 🚀 Hands-On: Creating Your First Bucket

**Step 1: Access S3 Console**
text

AWS Console → Services → S3

**Step 2: Create Bucket**
text

1. Click "Create bucket"
2. Bucket name: my-unique-bucket-name-2025 (must be globally unique)
3. Region: Choose closest to you (e.g., us-east-1)
4. Object Ownership: ACLs disabled (recommended)
5. Block Public Access: ☑ Block all public access
6. Versioning: Disable (for now)
7. Tags: Add Name=MyFirstBucket, Environment=Learning
8. Default encryption: Enable (SSE-S3)
9. Click "Create bucket"

**Step 3: Upload Your First Object**
text

1. Click bucket name
2. Click "Upload"
3. Add files (drag & drop or browse)
4. Properties:
   - Storage class: STANDARD
   - Encryption: SSE-S3
   - Metadata: Add key-value pairs
5. Permissions: Keep default (private)
6. Click "Upload"

**Step 4: Make Object Public (if needed)**
text

1. Select object → Actions → Make public using ACL
   OR
2. Use bucket policy:
   {
     "Version": "2012-10-17",
     "Statement": [{
       "Effect": "Allow",
       "Principal": "*",
       "Action": "s3:GetObject",
       "Resource": "arn:aws:s3:::my-bucket/*"
     }]
   }

## 🏗️ Common Use Cases & Architectures

**Use Case 1: Static Website Hosting**
text

Steps:
1. Create bucket named exactly as domain (www.example.com)
2. Upload HTML, CSS, JS files
3. Enable static website hosting
4. Configure index.html and error.html
5. Set bucket policy for public read
6. Route53 for DNS (or use bucket website endpoint)

Bucket Policy for Website:
json

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::www.example.com/*"
        }
    ]
}

Use Case 2: Data Lake
text

Components:

1. Raw zone (landing area)
2. Processed zone (cleaned data)
3. Analytics zone (query-ready)
4. Use S3 Select, Athena, Redshift Spectrum
5. Enable versioning & lifecycle policies

Use Case 3: Backup & Archive
text

Strategy:

1. Daily backups → STANDARD
2. After 30 days → STANDARD_IA
3. After 90 days → GLACIER
4. After 365 days → GLACIER_DEEP_ARCHIVE
5. Enable cross-region replication for DR

Use Case 4: Application Data Store
text

Pattern:
App → S3 (User uploads)
    → S3 Event → Lambda (Process)
    → S3 (Store processed)
    → CloudFront (Serve to users)

⚙️ Advanced Configuration
Lifecycle Policy Example
json

{
    "Rules": [
        {
            "ID": "MoveToGlacierAfter1Year",
            "Status": "Enabled",
            "Filter": {
                "Prefix": "backups/"
            },
            "Transitions": [
                {
                    "Days": 365,
                    "StorageClass": "GLACIER"
                }
            ],
            "NoncurrentVersionTransitions": [
                {
                    "NoncurrentDays": 30,
                    "StorageClass": "STANDARD_IA"
                }
            ],
            "Expiration": {
                "Days": 2555  # ~7 years
            }
        }
    ]
}

CORS Configuration

Allow cross-origin requests (for web apps):
xml

<CORSConfiguration>
  <CORSRule>
    <AllowedOrigin>https://www.example.com</AllowedOrigin>
    <AllowedMethod>GET</AllowedMethod>
    <AllowedMethod>PUT</AllowedMethod>
    <AllowedHeader>*</AllowedHeader>
  </CORSRule>
</CORSConfiguration>

🔍 Monitoring & Analytics
S3 Storage Lens

    Organization-wide visibility

    29+ metrics and trends

    Free tier: First 30 days, then paid

S3 Inventory

    Scheduled reports of objects and metadata

    CSV/ORC/Parquet output format

    Use cases: Audit, compliance, analytics

CloudWatch Metrics

Available metrics:

    BucketSizeBytes

    NumberOfObjects

    AllRequests

    4xxErrors

    5xxErrors

Setup alarms for:

    Unusual request patterns

    Storage capacity thresholds

🛡️ Security Best Practices

1. Data Protection
text

☑ Enable default encryption (SSE-S3 or SSE-KMS)
☑ Use bucket policies for access control
☑ Enable MFA Delete for critical data
☑ Use VPC endpoints for private access
☑ Enable S3 Object Lock for compliance (WORM)

2. Access Management
text

☑ Use IAM policies over bucket policies when possible
☑ Implement least privilege principle
☑ Regularly audit access using Access Analyzer
☑ Use presigned URLs for temporary access
☑ Monitor CloudTrail logs for S3 API calls

3. Network Security
text

☑ Use VPC Endpoints for private connectivity
☑ Restrict access by IP address in policies
☑ Use S3 Access Points for shared datasets
☑ Implement CORS policies for web applications

🚨 Common Pitfalls & Solutions
Pitfall 1: Accidental Public Access

Solution: Enable all four "Block Public Access" settings
Pitfall 2: High Costs from Frequent Retrievals

Solution: Choose appropriate storage class, use CloudFront
Pitfall 3: Slow Uploads/Downloads

Solution:

    Use multipart upload for large files (>100MB)

    Enable Transfer Acceleration

    Use S3 byte-range fetches

Pitfall 4: 403 Access Denied

Checklist:

    IAM permissions correct?

    Bucket policy allows access?

    Object ACL set correctly?

    Block Public Access disabled for public buckets?

Pitfall 5: Versioning Costs

Remember: All versions incur storage costs
Solution: Lifecycle rules to delete old versions
📊 S3 Limits & Quotas
Soft Limits (Can be increased):
text

Buckets per account: 100
Object size: 5TB (single upload)
Upload parts: 10,000 parts (multipart upload)

Hard Limits:
text

PUT/COPY/POST/DELETE requests: 3,500/sec per prefix
GET/HEAD requests: 5,500/sec per prefix
Key length: 1,024 bytes (UTF-8 encoded)
Metadata: 2KB/user metadata

Note: Use prefixes to increase performance (parallel operations)
🧪 Hands-On Exercises
Exercise 1: Static Website
text

1. Create bucket: www.my-test-site-2025.com
2. Enable static website hosting
3. Upload index.html with simple content
4. Make bucket public
5. Access via: http://www.my-test-site-2025.com.s3-website-us-east-1.amazonaws.com

Exercise 2: Lifecycle Management
text

1. Create "logs/" folder
2. Upload sample log files
3. Create lifecycle rule:
   - Move to STANDARD_IA after 30 days
   - Move to GLACIER after 90 days
   - Expire after 365 days

Exercise 3: Versioning & MFA Delete
text

1. Enable versioning on bucket
2. Upload same file multiple times
3. List object versions
4. Enable MFA Delete (requires root account)
5. Try deleting with/without MFA

Exercise 4: Presigned URLs
bash

# Generate URL valid for 1 hour

aws s3 presign s3://my-bucket/private-file.jpg --expires-in 3600

# Share URL with user

# They can download without AWS credentials

🔗 Integration with Other AWS Services
With CloudFront (CDN)

    Faster delivery globally

    Lower costs (reduced S3 requests)

    Custom SSL certificates

    Geo-restrictions

With Lambda (Serverless)

    Event-driven processing

    Thumbnail generation

    Data validation

    Real-time analytics

With Glacier (Archive)

    Automated archiving

    Compliance storage

    Cost-effective long-term storage

With Athena (Query Service)

    SQL queries on S3 data

    No infrastructure to manage

    Pay per query

With Snow Family

    Petabyte-scale data transfer

    Offline data migration

    Edge computing

📝 Quick Reference Tables

Storage Class Comparison

Class	Durability	Availability	Min Duration	Use Case

STANDARD	11 9's	99.99%	None	Hot data
STANDARD_IA	11 9's	99.9%	30 days	Cool data
ONEZONE_IA	11 9's	99.5%	30 days	Secondary backup
INTELLIGENT	11 9's	99.9%	None	Unknown pattern
GLACIER	11 9's	99.99%*	90 days	Archive
DEEP_ARCHIVE	11 9's	99.99%*	180 days	Rare access

*After retrieval

Encryption Options

Type	Method	Managed By	Use Case

SSE-S3	AES-256	AWS	Default, simple
SSE-KMS	AES-256	Customer	Audit trails, control
SSE-C	AES-256	Customer	Bring your own key
Client-side	Various	Customer	Before upload
HTTP Methods Mapping
Action	HTTP Method	S3 Operation
Create	PUT	PutObject
Read	GET	GetObject
Update	PUT	PutObject (new version)
Delete	DELETE	DeleteObject
List	GET	ListObjects

🎯 S3 Checklist for Production

Before Go-Live:

    Bucket naming follows conventions

    Versioning enabled (if needed)

    Default encryption configured

    Lifecycle policies defined

    Backup strategy implemented

    Access logging enabled

    CORS configured (for web apps)

    CloudFront setup (for performance)

    Cost monitoring alarms set

    Disaster recovery plan tested

Security Review:

    Block Public Access configured

    IAM policies follow least privilege

    KMS encryption for sensitive data

    VPC endpoints for private access

    CloudTrail logging enabled

    Regular access reviews scheduled

🔮 Next Steps After S3 Basics

    Advanced Security:

        S3 Object Lock (WORM)

        Access Points

        Multi-Region Access Points

    Performance Optimization:

        Request Rate Performance

        Transfer Acceleration

        S3 Batch Operations

    Data Processing:

        S3 Object Lambda

        Event Notifications with Lambda

        Athena for analytics

    Cost Optimization:

        S3 Storage Lens

        Intelligent-Tiering Analytics

        Lifecycle policy optimization

Remember: S3 is not a file system! It's object storage with different characteristics:

    No file locking

    No directory renaming (move all objects)

    Eventual consistency for overwrite PUTs and DELETEs

    Strong consistency for new PUTs and list operations

Best Practice: Always design applications for S3's object storage model, not traditional file system expectations.
💡 Pro Tips

    Use multipart upload for files >100MB

    Enable transfer acceleration for global uploads

    Use prefixes to parallelize operations

    Monitor 400/500 errors for access issues

    Test restoration from Glacier before you need it

    Use S3 Select to reduce data transfer costs

    Implement tagging for cost allocation

    Regularly review S3 Storage Lens dashboards

S3 is the foundation of storage in AWS. Master it, and you unlock capabilities across data lakes, backups, web  hosting, and much more. Start simple, practice the basics, then explore advanced features as your needs grow.

Action,Command
List all buckets,aws s3 ls
List contents of a bucket,aws s3 ls s3://your-bucket-name
Upload a file,aws s3 cp filename.txt s3://your-bucket-name
Delete a file,aws s3 rm s3://your-bucket-name/filename.txt
Delete an empty bucket,aws s3 rb s3://your-bucket-name
create bucket,aws s3 mb s3://your-unique-bucket-name
Create bucket with region,aws s3 mb s3://your-unique-bucket-name --region us-west-2