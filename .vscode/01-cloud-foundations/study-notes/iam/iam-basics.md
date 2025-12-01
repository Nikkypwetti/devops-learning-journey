IAM (Identity and Access Management) Basics
Created: 2025-11-20
Updated: 2025-11-28
📚 Core Concepts
What is IAM?

Identity and Access Management (IAM) is the AWS service that helps you securely control access to AWS resources. It manages:

    Who can access your AWS account (identities)

    What they can do (permissions)

    Which resources they can access

Key Features

    Global service (not region-specific)

    Free to use (no additional charges)

    Integrated with most AWS services

    Granular permissions through policies

👥 IAM Identities

1. Users

Individual people or applications that need access to your AWS account.

Types:

    Root User: The account owner (created during sign-up)

        ⚠️ Never use for daily operations

        Use only for account-level tasks

    IAM Users: Individual users with specific permissions

        Can have programmatic access (Access Keys) and/or console access

        Can belong to multiple groups

Best Practices:

    Create individual IAM users for each person

    Never share credentials

    Enable MFA for all users

2. Groups

A collection of IAM users. Groups make it easier to manage permissions for multiple users.

Characteristics:

    Groups can contain multiple users

    Users can belong to multiple groups

    Groups cannot contain other groups

    Groups don't have credentials (cannot log in)

Example:
text

Developers Group
├── User1 (Developer)
├── User2 (Developer)
└── User3 (Developer)

3. Roles

An IAM identity with specific permissions that can be assumed by trusted entities.

Use Cases:

    AWS Services: EC2 instances needing S3 access

    Cross-Account Access: Access between AWS accounts

    Federation: External users (Active Directory, SAML, OIDC)

Key Points:

    Roles have temporary credentials (security tokens)

    No long-term credentials (passwords/access keys)

    Defined by trust policy (who can assume) and permission policy (what they can do)

🔐 IAM Policies
Policy Structure

JSON documents that define permissions:
json

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::example-bucket",
            "Condition": {
                "IpAddress": {"aws:SourceIp": "203.0.113.0/24"}
            }
        }
    ]
}

Policy Elements:

    Effect: "Allow" or "Deny"

    Action: Which API actions are allowed/denied (e.g., s3:GetObject)

    Resource: Which AWS resources the policy applies to (ARN format)

    Condition: Optional constraints (time, IP, tags, etc.)

Policy Types:

    Identity-based Policies

        Attached to users, groups, or roles

        Defines what the identity can do

    Resource-based Policies

        Attached directly to resources (S3 buckets, SQS queues, etc.)

        Defines who can access the resource

        Example: S3 bucket policy

    Permissions Boundaries

        Sets maximum permissions an identity can have

        Used for delegation scenarios

    Organization SCPs (Service Control Policies)

        Applied at AWS Organizations level

        Defines maximum permissions for accounts in the organization

    Session Policies

        Temporary policies for federated users or assumed roles

⚙️ IAM Features
Multi-Factor Authentication (MFA)

Adds an extra layer of security beyond username and password.

MFA Devices:

    Virtual MFA (Google Authenticator, Authy)

    Hardware MFA (YubiKey, Gemalto)

    Universal 2nd Factor (U2F) security keys

Best Practice: Enable MFA for:

    Root user (mandatory)

    IAM users with console access

    Sensitive operations (deleting resources)

Access Keys

Used for programmatic access to AWS APIs.

Components:

    Access Key ID (public identifier)

    Secret Access Key (private key - like a password)

Security Practices:

    Rotate keys regularly (every 90 days)

    Never commit keys to code repositories

    Use IAM Roles for applications when possible

Password Policy

Enforce strong password requirements:
json

{
    "MinimumPasswordLength": 8,
    "RequireSymbols": true,
    "RequireNumbers": true,
    "RequireUppercaseCharacters": true,
    "RequireLowercaseCharacters": true,
    "AllowUsersToChangePassword": true,
    "MaxPasswordAge": 90,
    "PasswordReusePrevention": 24,
    "HardExpiry": false
}

🛡️ Security Best Practices

1. Principle of Least Privilege

Grant only the permissions needed to perform a task.

Example:

    Developer needs S3: Read-only access → Don't grant S3: FullAccess

2. Use Roles Instead of Users for Applications
yaml

# Instead of storing access keys in EC2:

EC2 Instance → IAM Role → Access AWS Services

# Benefits:

# - No credential management
# - Automatic rotation
# - Temporary permissions

3. Regular Auditing

    Review IAM policies periodically

    Use IAM Access Analyzer

    Check CloudTrail logs

    Remove unused credentials

4. Enable CloudTrail

Track all API calls made in your AWS account.
🔍 IAM Tools & Services
IAM Access Analyzer

Helps identify resources shared with external entities.

Features:

    Analyzes resource-based policies

    Identifies public and cross-account access

    Provides actionable recommendations

IAM Credential Report

Downloadable report showing:

    Password last used/changed

    Access key last used/rotated

    MFA device status

AWS Organizations

Manage multiple AWS accounts with:

    Consolidated billing

    Service Control Policies (SCPs)

    Cross-account roles

🚫 Common Mistakes to Avoid

    Using root user for daily operations

    Overly permissive policies ("*" actions/resources)

    Hard-coding credentials in applications

    Not enabling MFA for privileged users

    Not rotating access keys regularly

    Ignoring IAM Access Analyzer findings

🏗️ Real-World Examples
Example 1: Web Application on EC2
yaml

Scenario: EC2 instance needs to write logs to S3

Solution:
1. Create IAM Role "WebAppS3WriteRole"
2. Attach policy allowing s3:PutObject to specific bucket
3. Attach role to EC2 instance

Example 2: Cross-Account Access
yaml

Scenario: DevOps team in Account A needs to manage EC2 in Account B

Solution:
1. Account B: Create role "CrossAccountDevOpsRole"
2. Account B: Define trust policy allowing Account A
3. Account A: Users assume role using STS

Example 3: S3 Bucket with Fine-Grained Access
json

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {"AWS": "arn:aws:iam::123456789012:user/Bob"},
            "Action": ["s3:GetObject", "s3:ListBucket"],
            "Resource": [
                "arn:aws:s3:::company-documents",
                "arn:aws:s3:::company-documents/*"
            ],
            "Condition": {
                "IpAddress": {"aws:SourceIp": "10.0.0.0/16"}
            }
        }
    ]
}

📊 IAM Limits

    Users per account: 5,000 (soft limit, can be increased)

    Groups per account: 300

    Roles per account: 1,000

    Policies per entity: 10 managed policies

    Policy size: 6,144 characters (user/group/role policy)

    Inline policies per entity: 2

🔗 Related Topics

    [[../aws-basics/cloud-computing-concepts.md]]

    [[../sts/sts-basics.md]]

    [[../organizations/organizations-basics.md]]

    [[../s3/s3-security.md]]

📝 Summary

IAM is the foundation of AWS security. Remember:

    Never use root credentials for daily tasks

    Apply least privilege principle

    Enable MFA everywhere

    Use roles for applications

    Regularly audit permissions

Next Steps: Practice creating IAM users, groups, roles, and policies in the AWS Management Console. Test permission boundaries and understand policy evaluation logic.
This response is AI-generated, for reference only.
