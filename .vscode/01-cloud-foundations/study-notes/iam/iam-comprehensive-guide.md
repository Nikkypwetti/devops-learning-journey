📚 IAM (Identity and Access Management) - Comprehensive Notes
📅 Created: $(2025-12-1)
🏷️ Category: Cloud Foundations → AWS Services
📖 Topic: Identity and Access Management (IAM)
🎯 Relevance: Foundational security service for all AWS resources

1. 🎯 What is IAM?

IAM is the authentication and authorization service for AWS. It controls:

    WHO can access your AWS resources (authentication)

    WHAT they can do with those resources (authorization)

Analogy: IAM is like the security system of a building:

    Users = People with ID cards

    Groups = Departments (Development, Finance, etc.)

    Roles = Temporary access badges for contractors

    Policies = Rules about who can enter which rooms

2. 🏗️ IAM Core Components
2.1 IAM Users

    Definition: Individual people or applications that need AWS access

    Best Practice: Create individual users, NEVER share credentials

    Authentication Methods:

        Username/Password (for console)

        Access Keys (for programmatic/CLI access)

        SSH keys (for EC2 instances)

bash

# CLI: Create IAM user

aws iam create-user --user-name Alice

# CLI: Create access key

aws iam create-access-key --user-name Alice

2.2 IAM Groups

    Definition: Collection of IAM users

    Purpose: Apply permissions to multiple users at once

    Best Practice: Group users by job function (Developers, Admins, etc.)

bash

# Create group

aws iam create-group --group-name Developers

# Add user to group

aws iam add-user-to-group --user-name Alice --group-name Developers

2.3 IAM Roles

    Definition: AWS identity with permission policies

    Key Feature: Temporary credentials (1-12 hours)

    Use Cases:

        EC2 instances needing AWS access

        Cross-account access

        AWS services accessing other services

        Federation (Active Directory, SAML, etc.)

json

// Example: Trust policy for EC2 role
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}

2.4 IAM Policies

    Definition: JSON documents defining permissions

    Two Types:

        Identity-based: Attached to users/groups/roles

        Resource-based: Attached to resources (S3 buckets, SNS topics)

Basic Policy Structure:
json

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowS3Actions",
            "Effect": "Allow",  // or "Deny"
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::my-bucket/*",
            "Condition": {
                "IpAddress": {
                    "aws:SourceIp": "192.168.1.0/24"
                }
            }
        }
    ]
}

3. 🔐 IAM Policy Elements Deep Dive
3.1 Effect

    Allow - Grants permission

    Deny - Explicitly denies permission

    Important: Deny always overrides Allow

3.2 Action

    AWS API operations (e.g., s3:GetObject, ec2:RunInstances)

    Wildcards: s3:* or ec2:Describe*

3.3 Resource

    AWS resource ARN (Amazon Resource Name)

    Format: arn:partition:service:region:account-id:resource

    Examples:

        arn:aws:s3:::my-bucket

        arn:aws:ec2:us-east-1:123456789012:instance/i-12345

3.4 Condition

    Optional constraints for when policy applies

    Common condition keys:

        aws:SourceIp - Restrict by IP address

        aws:MultiFactorAuthPresent - Require MFA

        aws:PrincipalTag - Based on user tags

        aws:RequestedRegion - Restrict by region

4. 🛡️ IAM Security Best Practices
4.1 Root Account Security
bash

# NEVER use root for daily tasks

# ALWAYS enable MFA on root account

# Delete root access keys if they exist

aws iam delete-access-key --access-key-id ROOT_KEY_ID

4.2 Principle of Least Privilege

    Grant minimum permissions needed

    Start restrictive, expand as needed

    Use Deny for sensitive operations

4.3 Password Policy
bash

aws iam update-account-password-policy \
    --minimum-password-length 14 \
    --require-symbols \
    --require-numbers \
    --require-uppercase-characters \
    --require-lowercase-characters \
    --allow-users-to-change-password \
    --max-password-age 90 \
    --password-reuse-prevention 24

4.4 Multi-Factor Authentication (MFA)

    Required for:

        Root account

        IAM users with console access

        Privileged users

    MFA devices: Virtual (Google Authenticator) or Hardware

4.5 Regular Audits
bash

# Generate credential report

aws iam generate-credential-report

# Get unused access keys (older than 90 days)

aws iam list-access-keys --user-name Alice

5. 🔄 IAM Policies Evaluation Logic

When AWS evaluates permissions:

    Default Deny: All requests start as denied

    Explicit Allow: If ANY policy allows → request allowed

    Explicit Deny: If ANY policy denies → request denied (overrides Allow)

    Final Decision: If no explicit Allow or Deny → implicit Deny

Visual Flow:
text

Request → IAM → 
    ↓
    Is there an Explicit DENY?
    │
    Yes → Request DENIED ❌
    │
    No
    │
    Is there an Explicit ALLOW?
    │
    Yes → Request ALLOWED ✅
    │
    No
    │
    Request DENIED ❌ (Implicit Deny)

6. 🎭 IAM Roles vs Users: When to Use What
Aspect	IAM Users	IAM Roles
Credentials	Long-term (rotate every 90 days)	Temporary (1-12 hours)
Attached to	People/Applications	AWS Services/EC2/Cross-Account
Best For	Human access, CLI automation	Service accounts, cross-account
Security	Higher risk (long-term creds)	Lower risk (temp creds)
MFA	Required for console access	Not applicable

Golden Rule: Use Roles whenever possible, especially for:

    EC2 instances

    Lambda functions

    Cross-account access

    Federated users

7. 🌐 Cross-Account Access Patterns
7.1 Simple Cross-Account Access
text

Account A (Source) → Assume Role → Account B (Target)
   │                         │
   └── IAM User             └── IAM Role

Implementation Steps:

    Target Account (B): Create role with trust policy allowing Source Account (A)

    Source Account (A): Give users permission to assume the role

    Assume Role: User assumes role, gets temporary credentials

7.2 Trust Policy Example
json

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::123456789012:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "Bool": {
          "aws:MultiFactorAuthPresent": "true"
        }
      }
    }
  ]
}

8. 🛠️ IAM Policy Types
8.1 Managed Policies

    AWS Managed: Created/maintained by AWS (e.g., AdministratorAccess)

    Customer Managed: Created/maintained by you

    Best Practice: Use managed policies for reusability

8.2 Inline Policies

    Embedded directly in users/groups/roles

    Deleted when parent is deleted

    Good for unique, one-off permissions

8.3 Permission Boundaries

    Purpose: Set maximum permissions a user/role can have

    Use Case: Delegating IAM administration safely

    Important: Acts as a permissions ceiling

9. 📊 IAM Monitoring & Auditing
9.1 IAM Access Analyzer

    Analyzes resource policies for external access

    Helps identify unintended resource sharing

bash

# Create analyzer

aws accessanalyzer create-analyzer \
    --analyzer-name MyAnalyzer \
    --type ACCOUNT

9.2 CloudTrail Integration

    All IAM actions logged in CloudTrail

    Essential for compliance and security audits

9.3 IAM Credential Report

    CSV report of all users and credential status

    Shows password age, MFA status, access key age

bash

# Generate report

aws iam generate-credential-report

# Download report

aws iam get-credential-report

10. 💡 Practical Examples & Use Cases
10.1 Developer Access Policy
json

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DeveloperEC2Access",
            "Effect": "Allow",
            "Action": [
                "ec2:Describe*",
                "ec2:StartInstances",
                "ec2:StopInstances",
                "ec2:RebootInstances"
            ],
            "Resource": "*"
        },
        {
            "Sid": "DenyProductionModification",
            "Effect": "Deny",
            "Action": "ec2:TerminateInstances",
            "Resource": "arn:aws:ec2:*:*:instance/*",
            "Condition": {
                "StringEquals": {
                    "ec2:ResourceTag/Environment": "Production"
                }
            }
        }
    ]
}

10.2 S3 Read-Only Policy
json

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListBuckets",
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": "*"
        },
        {
            "Sid": "ReadBucketObjects",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::my-bucket",
                "arn:aws:s3:::my-bucket/*"
            ]
        }
    ]
}

11. 🚨 Common IAM Mistakes to Avoid

    ❌ Using root account for daily tasks

    ❌ Not enabling MFA on privileged accounts

    ❌ Using wildcards (*) unnecessarily

    ❌ Hardcoding credentials in code

    ❌ Not rotating access keys regularly

    ❌ Granting permissions at account level instead of resource level

    ❌ Not using IAM roles for EC2 instances

    ❌ Ignoring IAM Access Analyzer findings

12. 🔍 IAM Troubleshooting Guide
Symptom: "Access Denied"

    Check explicit Deny policies

    Verify resource ARN matches

    Check condition constraints (IP, MFA, etc.)

    Use Policy Simulator in AWS Console

Symptom: Can't assume role

    Verify trust policy allows your principal

    Check if MFA is required

    Verify role exists in correct region/account

    Check session duration limits

Useful Commands:
bash

# Test policy with simulator

aws iam simulate-principal-policy \
    --policy-source-arn arn:aws:iam::123456789012:user/Alice \
    --action-names s3:GetObject

# Get user's effective permissions

aws iam get-user-policy --user-name Alice --policy-name MyPolicy

# List all policies attached to user

aws iam list-attached-user-policies --user-name Alice

13. 📈 IAM Learning Path Checklist
Beginner Level (Week 1)

    Understand IAM Users, Groups, Roles

    Create IAM user with console access

    Set up MFA on root account

    Create basic IAM policy

    Attach policy to user/group

Intermediate Level (Week 2)

    Create IAM roles for EC2

    Implement cross-account access

    Use IAM policy conditions

    Set up password policy

    Generate credential reports

Advanced Level (Week 3)

    Implement permission boundaries

    Use IAM Access Analyzer

    Set up federation (SAML/OIDC)

    Create organization SCPs

    Automate IAM with Terraform

14. 🔗 Resources for Further Learning
Official Documentation

    AWS IAM Documentation

    IAM Policy Reference

    IAM Best Practices

Practice Tools

    IAM Policy Simulator

    IAM Policy Generator

    IAM Access Analyzer

Video Tutorials

    AWS IAM Deep Dive

    IAM Policies Explained

15. 📝 Key Takeaways

    IAM is fundamental to AWS security - understand it deeply

    Follow least privilege principle - start restrictive

    Use roles over users for services and temporary access

    Enable MFA everywhere - especially for privileged accounts

    Monitor and audit regularly - security is not set-and-forget

    Automate IAM management - reduces human error

    Test permissions before applying to production

🎯 Next Study Topics

    AWS Organizations & SCPs - Multi-account governance

    AWS SSO - Centralized identity management

    AWS KMS - Key management for encryption

    AWS Secrets Manager - Secure credential storage

"IAM is the gatekeeper of your AWS kingdom. Master it, and you master AWS security."
