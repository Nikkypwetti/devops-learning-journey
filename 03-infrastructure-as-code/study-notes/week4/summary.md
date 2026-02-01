📝 DevOps Technical Summary: January 2026

Project: Production-Grade Terraform CI/CD & Security Hardening
1. The "Ghost" Resource Lesson (State Recovery)

    The Issue: EntityAlreadyExists / 409 Conflict.

    The Cause: Resources existed in AWS but were missing from the local terraform.tfstate.

    The Pro Fix: Use terraform import. You successfully imported the OIDC Provider, IAM Roles, and the S3 State Bucket.

    Key Command: terraform import <resource_address> <physical_id>

2. The "Blind" Tester Lesson (IAM Permissions)

    The Issue: api error UnauthorizedOperation: ... ec2:DescribeImages.

    The Cause: The GitHub Actions IAM role had RunInstances permission but couldn't "see" the AMIs to choose one.

    The Pro Fix: Explicitly add ec2:DescribeImages with Resource = "*" to the IAM policy. Discovery actions usually require a wildcard resource.

3. The "Naked" Bucket Lesson (S3 Hardening)

    The Issue: Trivy reported 4 HIGH vulnerabilities (AVD-AWS-0086, etc.) on the state bucket.

    The Cause: Creating an S3 bucket in Terraform without an explicit aws_s3_bucket_public_access_block.

    The Pro Fix: Always attach a public access block to state buckets, setting all four "block/ignore" parameters to true.

4. The "Pathing" Lesson (GitHub Actions)

    The Issue: Error: Path does not exist: ...checkov.sarif.

    The Cause: Discrepancy between the runner's working-directory and where security tools drop their output files.

    The Pro Fix: Standardize SARIF outputs to the $GITHUB_WORKSPACE (root) to ensure the upload-sarif action can find them regardless of where the scan started.