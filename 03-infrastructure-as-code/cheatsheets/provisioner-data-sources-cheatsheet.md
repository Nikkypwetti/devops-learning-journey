# Provisioners & Data Sources Cheatsheet

## Provisioner Types:

1. **file** - Copy files to remote
2. **remote-exec** - Execute commands on remote
3. **local-exec** - Execute commands locally
4. **chef** - Chef provisioner
5. **puppet** - Puppet provisioner
6. **ansible** - Ansible provisioner

## Provisioner Behavior:

- run on create/destroy
- before/after resource actions
- on_failure: continue/fail
- when: create/destroy

## Common Data Sources:

- aws_ami - Find AMI IDs
- aws_availability_zones - List AZs
- aws_vpc - Get VPC info
- aws_subnets - Get subnet IDs
- aws_iam_policy_document - Generate IAM policies
- template_file - Generate templates

## Best Practices:

✅ Use provisioners as last resort
✅ Prefer user_data for EC2
✅ Use null_resource for complex provisioning
✅ Implement retries for flaky operations
✅ Clean up resources on destroy

🔗 **Additional Resources**

- [Provisioner Syntax](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)
- [Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)
- [Connection Blocks](https://developer.hashicorp.com/terraform/language/resources/provisioners/connection)