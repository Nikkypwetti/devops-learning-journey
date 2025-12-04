# IAM Cross-Account Learning Journal

## Day 1: Basic Setup

### What I learned:

- How to create IAM roles with trust policies
- The difference between source and target accounts
- How to assume roles using AWS CLI

### Challenges:

- Understanding the trust relationship syntax
- Setting up AWS CLI profiles correctly

### Commands that worked:

```bash
aws sts assume-role --role-arn arn:aws:iam::123456789012:role/TestRole