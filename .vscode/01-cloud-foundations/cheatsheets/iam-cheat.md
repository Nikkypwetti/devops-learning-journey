AWS IAM Cheat Sheets

🔐 IAM CHEAT SHEET
🎯 Quick Reference
IAM Components
text

Users (👤)  →  Individual people/applications
Groups (👥) →  Collection of users
Roles (🎭)  →  Temporary permissions for services
Policies (📜) → JSON documents defining permissions

ARN Format
text

arn:partition:service:region:account:resource-type/resource-id
Example: arn:aws:iam::123456789012:user/john.doe

📋 IAM CLI Commands
User Management
bash

# Create user

aws iam create-user --user-name alice

# List users

aws iam list-users

# Get user info

aws iam get-user --user-name alice

# Delete user

aws iam delete-user --user-name alice

Group Management
bash

# Create group

aws iam create-group --group-name Developers

# Add user to group

aws iam add-user-to-group --user-name alice --group-name Developers

# List groups for user

aws iam list-groups-for-user --user-name alice

Policy Management
bash

# Create policy from JSON file

aws iam create-policy --policy-name S3ReadOnly --policy-document file://policy.json

# Attach policy to user

aws iam attach-user-policy --user-name alice --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

# List attached policies

aws iam list-attached-user-policies --user-name alice

Role Management
bash

# Create role

aws iam create-role --role-name EC2-S3-Role --assume-role-policy-document file://trust-policy.json

# Assume role (get temporary credentials)

aws sts assume-role --role-arn arn:aws:iam::123456789012:role/EC2-S3-Role --role-session-name MySession

Access Key Management
bash

# Create access key

aws iam create-access-key --user-name alice

# List access keys

aws iam list-access-keys --user-name alice

# Delete access key

aws iam delete-access-key --user-name alice --access-key-id AKIAIOSFODNN7EXAMPLE

Password Policy
bash

# Update password policy

aws iam update-account-password-policy \
    --minimum-password-length 8 \
    --require-symbols \
    --require-numbers \
    --require-uppercase-characters \
    --require-lowercase-characters \
    --allow-users-to-change-password \
    --max-password-age 90 \
    --password-reuse-prevention 24

📜 Policy Examples
Minimal S3 Read-Only Policy
json

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
                "arn:aws:s3:::my-bucket",
                "arn:aws:s3:::my-bucket/*"
            ]
        }
    ]
}

EC2 Describe Only Policy
json

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ec2:Describe*",
            "Resource": "*"
        }
    ]
}

Deny Specific Region Policy
json

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "Action": "*",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:RequestedRegion": "us-west-2"
                }
            }
        }
    ]
}

🛡️ Security Best Practices Cheat Sheet
DOs:
text

✅ Enable MFA for all users (especially root)
✅ Use IAM Roles for EC2 instances
✅ Apply principle of least privilege
✅ Regularly rotate access keys (every 90 days)
✅ Enable CloudTrail logging
✅ Use IAM Access Analyzer
✅ Implement password policies
✅ Tag IAM resources for tracking

DON'Ts:
text

❌ Never use root for daily tasks
❌ Don't share access keys
❌ Avoid "*" in policies (be specific)
❌ Don't hardcode credentials in code
❌ Don't use IAM users for cross-account access (use roles)
❌ Don't ignore credential reports

⚡ Quick Commands for Common Tasks
Check User Permissions
bash

# Simulate policy evaluation

aws iam simulate-principal-policy \
    --policy-source-arn arn:aws:iam::123456789012:user/alice \
    --action-names s3:GetObject ec2:DescribeInstances

Generate Credential Report
bash

# Request report

aws iam generate-credential-report

# Download report

aws iam get-credential-report --output text | base64 --decode > credential-report.csv

Check Password Policy
bash

aws iam get-account-password-policy

List All Policies for User
bash

# Directly attached policies

aws iam list-attached-user-policies --user-name alice

# Inline policies

aws iam list-user-policies --user-name alice

# Group policies

aws iam list-groups-for-user --user-name alice

📊 IAM Limits & Quotas
text

Users per account: 5,000
Groups per account: 300
Roles per account: 1,000
Managed policies per entity: 10
Inline policies per entity: 2
Policy size: 6,144 characters
Access keys per user: 2
MFA devices per user: 8

🔍 Troubleshooting Commands
Debug Access Issues
bash

# Who am I?

aws sts get-caller-identity

# Get session context

aws sts get-session-token

# Decode error messages

aws sts decode-authorization-message --encoded-message <encoded-message>

Check Last Access
bash

# Get service last accessed

aws iam generate-service-last-accessed-details --arn arn:aws:iam::123456789012:user/alice

Quick Tips
IAM Tips:

    Use aws sts get-caller-identity to check current identity

    Enable MFA for programmatic access too

    Use policy conditions for extra security

    Regularly review CloudTrail logs

📱 Quick Commands for Mobile Reference

5 Most Used IAM Commands:

bash
aws sts get-caller-identity
aws iam list-users
aws iam list-attached-user-policies --user-name <name>
aws iam create-user --user-name <name>
aws iam create-role --role-name <name> --assume-role-policy-document file://trust.json

# IAM Aliases

alias iamusers='aws iam list-users --output table'
alias iamgroups='aws iam list-groups --output table'
alias iamwho='aws sts get-caller-identity'
