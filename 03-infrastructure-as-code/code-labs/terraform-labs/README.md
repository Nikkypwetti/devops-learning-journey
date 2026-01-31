# terraform-labs

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_my_ec2"></a> [my\_ec2](#module\_my\_ec2) | ./modules/module-1 | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.terraform_locks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_s3_bucket.terraform_state_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.state_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_public_access_block.state_bucket_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.state_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.state_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | The AWS CLI profile to use | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to deploy resources in | `string` | `"us-east-1"` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | Name of the EC2 instance | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Type of EC2 instance | `string` | `"t3.micro"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Name of the SSH key pair | `string` | n/a | yes |
| <a name="input_public_key_path"></a> [public\_key\_path](#input\_public\_key\_path) | Path to the public SSH key | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_final_public_ip"></a> [final\_public\_ip](#output\_final\_public\_ip) | The public IP address of the server |
| <a name="output_ssh_connection_string"></a> [ssh\_connection\_string](#output\_ssh\_connection\_string) | n/a |
<!-- END_TF_DOCS -->
