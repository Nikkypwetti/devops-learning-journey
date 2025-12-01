# Quick Notes & Ideas

## 2024-01-15

- [ ] Research AWS Organizations for multi-account setup
- [ ] Look into Terraform state locking with DynamoDB
- [ ] Practice IAM policy writing

## Interesting Concepts

- **Infrastructure as Code:** Treat infrastructure like software
- **Immutable Infrastructure:** Never modify, always replace
- **Pets vs Cattle:** Servers should be disposable

## Project Ideas

- [ ] Create automated backup system with S3 and Lambda
- [ ] Build monitoring dashboard with CloudWatch
- [ ] Design multi-region disaster recovery setup

## Commands to Remember

```bash
# Get current AWS user
aws sts get-caller-identity

# List S3 buckets
aws s3 ls

# Terraform plan with specific variables
terraform plan -var="instance_type=t3.micro"