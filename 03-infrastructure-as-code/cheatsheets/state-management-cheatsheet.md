# State Management Cheatsheet

## State Commands:

- `terraform state list` - List resources in state
- `terraform state show RESOURCE` - Show resource details
- `terraform state mv SOURCE DEST` - Move resource in state
- `terraform state rm RESOURCE` - Remove from state
- `terraform state pull` - Download state
- `terraform state push` - Upload state

## Backend Types:

1. **Local** - File on disk (default)
2. **S3** - AWS S3 with DynamoDB locking
3. **AzureRM** - Azure storage account
4. **GCS** - Google Cloud Storage
5. **HTTP** - REST API backend
6. **Terraform Cloud** - HashiCorp managed

## Best Practices:

✅ Always use remote state for teams
✅ Enable versioning on state bucket
✅ Use DynamoDB for state locking
✅ Never edit .tfstate manually
✅ Backup state regularly
✅ Limit access to state bucket
✅ Use workspaces for environments

🔗 **Additional Resources**

- [State Backends](https://developer.hashicorp.com/terraform/language/settings/backends/configuration)
- [State Commands](https://developer.hashicorp.com/terraform/cli/commands/state)
- [S3 Backend Configuration](https://developer.hashicorp.com/terraform/language/settings/backends/s3)
