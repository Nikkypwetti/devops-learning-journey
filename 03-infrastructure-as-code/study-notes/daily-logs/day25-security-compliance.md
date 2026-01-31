# Day 25: Security & Compliance (IaC)

## What I Learned

Concept 1: DevSecOps in IaC
    Security and Compliance shifts "left" in the development lifecycle. Instead of auditing resources after they are created, we scan the Terraform code (Infrastructure as Code) to find vulnerabilities before the "terraform apply" command is ever executed.

Concept 2: Static Analysis (Sast)
    Static analysis tools like tfsec and Checkov examine your source code without executing it. They look for patterns that represent security risks, such as hardcoded passwords, unencrypted storage, or overly permissive network rules.

Concept 3: Policy as Code (PaC)
    Policy as Code allows you to define organizational requirements (e.g., "All S3 buckets must be private") as machine-readable files. This automates the enforcement of compliance standards like CIS Benchmarks, HIPAA, or PCI-DSS.

Concept 4: tfsec vs. Checkov
    - tfsec: A fast, lightweight scanner specifically for Terraform that uses static analysis to detect potential security issues.
    - Checkov: A more comprehensive tool that supports Terraform, CloudFormation, Kubernetes, and Docker. It provides hundreds of pre-defined policies out of the box.

Concept 5: Least Privilege in Terraform
    The IAM credentials used by Terraform should follow the Principle of Least Privilege. Only grant the specific permissions needed to manage the resources in your configuration to minimize the "blast radius" in case of a credential leak.

Concept 6: Protecting the State File
    The Terraform State file often contains sensitive data in plain text. Secure state management involves storing files in encrypted backends (like S3 with KMS) and using locking (DynamoDB) to prevent concurrent modifications.

## Code Practice Terraform

main.tf - Identifying a security risk (Public S3 Bucket)

resource "aws_s3_bucket" "insecure_bucket" { bucket = "my-devops-project-bucket-12345" }
This resource would be flagged by tfsec/Checkov

resource "aws_s3_bucket_public_access_block" "example" { bucket = aws_s3_bucket.insecure_bucket.id

block_public_acls = true block_public_policy = true ignore_public_acls = true restrict_public_buckets = true }
security_group.tf - Flagged for open ingress

resource "aws_security_group" "bad_sg" { name = "allow_all" description = "Insecure security group"

ingress { from_port = 22 to_port = 22 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] # Flagged: SSH open to the world } }

## Commands Used Bash

Install security scanning tools

brew install tfsec checkov
Run tfsec on your current directory

tfsec .
Run Checkov and output results to the console

checkov -d .
Run Checkov and skip specific non-critical checks

checkov -d . --skip-check CKV_AWS_20,CKV_AWS_52
Output tfsec results in JSON format for CI/CD integration

tfsec . --format json > security-report.json
The Security Scan Report

The scan output provides a detailed breakdown of your infrastructure's health.

File: security-report.json (optional output)

Findings: The tools will list "Critical," "High," "Medium," and "Low" risks. Each finding usually includes a link to documentation explaining why it is a risk and how to fix it.

Why it's there: This ensures that your GitHub portfolio projects demonstrate professional-grade security standards, making your repositories more attractive to recruiters.

## Challenges

Problem: Tool flagging a resource that is intentionally public (e.g., a public website S3 bucket).

Solution: Used "inline suppressions." In Terraform, you can add a comment like `#tfsec:ignore:aws-s3-no-public-access-with-acl` or a Checkov comment `#checkov:skip=CKV_AWS_18:Public_access_needed_for_static_site` to acknowledge and bypass specific rules.

## Resources

Video Tutorial
    Video: [https://www.youtube.com/watch?v=5_2mS7mN83Y](https://www.youtube.com/watch?v=5_2mS7mN83Y) (22 mins)

## Documentation

    Reading: [https://www.terraform-best-practices.com/key-concepts/security](https://www.terraform-best-practices.com/key-concepts/security)
    Practice: [https://www.checkov.io/1.Welcome/Quick%20Start.html](https://www.checkov.io/1.Welcome/Quick%20Start.html)

## Practice Task: Security Scanning Workflow

To master this day, follow these steps in your local environment:

    Install the Tools: If you use Homebrew, run brew install tfsec checkov.

    Run a Scan: Navigate to one of your existing GitHub portfolio projects (like your Golden AMI pipeline) and run tfsec ..

    Analyze Results: Look for "High" or "Critical" alerts. Common issues include unencrypted EBS volumes or wide-open Security Groups (0.0.0.0/0).

    Remediation: Modify your Terraform code to fix the flagged security risks and re-run the scan until it passes.

    Documentation: Add a "Security" section to your Project README on GitHub, explaining that you use tfsec or Checkov to ensure compliant infrastructure. This is a highly sought-after skill for Cloud Engineering roles.

## Pro-Tip: How to "Ignore" a Check

Sometimes you know a port is open for a reason (like our lab). You can tell tfsec to ignore a specific resource by adding a comment in your main.tf:
Terraform

resource "aws_security_group" "allow_web" {
  #tfsec:ignore:aws-vpc-no-public-ingress-sgr
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## Pro-Tip: Skipping a Checkov Rule

Just like tfsec, if Checkov flags something you intentionally want (like a public test bucket), you can add an inline comment to ignore it:
Terraform

# checkov:skip=CKV_AWS_20: "I need this bucket public for my portfolio static site"
resource "aws_s3_bucket" "portfolio" {
  bucket = "my-awesome-portfolio-bucket"
}

1. The "Public Access" Fail (S3 & Security Groups)

Checkov hates 0.0.0.0/0 (the whole internet).

The Fail: CKV_AWS_24: Ensure no security groups allow ingress from 0.0.0.0:0 to port 22. The Fix: Instead of opening SSH to the world, restrict it to your specific IP address.
Terraform

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow inbound web traffic"

  ingress {
    description = "SSH from my home office"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Replace with your actual public IP followed by /32
    cidr_blocks = ["1.2.3.4/32"] 
  }
}

2. The "Encryption at Rest" Fail (S3)

If you have an S3 bucket in your portfolio, Checkov will insist it is encrypted.

The Fail: CKV_AWS_19: Ensure all data stored in the S3 bucket is securely encrypted at rest. The Fix: Add a server-side encryption configuration block.
Terraform

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

3. The "Missing Metadata Service" Fail (EC2)

This is a modern security standard (IMDSv2) that prevents certain types of cloud attacks.

The Fail: CKV_AWS_79: Ensure Instance Metadata Service Version 2 (IMDSv2) is enabled. The Fix: Add a metadata_options block to your aws_instance.
Terraform

resource "aws_instance" "web_server" {
  ami           = data.aws_ami.selected.id
  instance_type = "t3.micro"

  # Fix for CKV_AWS_79
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
}

How to handle these results in your Workflow

    Run the check: pre-commit run --all-files

    Analyze the Fail: Look at the "Resource" and the "Check ID" (e.g., CKV_AWS_79).

    Apply the Fix: Update your code as shown above.

    Re-run: The check should now turn Green.

## Tomorrow's Plan

Topic 1: Terraform Cloud & Enterprise (Remote Operations)

Topic 2: Setting up a Terraform CI/CD Pipeline with GitHub Actions
