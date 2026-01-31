# module-1

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.28.0 |
| <a name="provider_http"></a> [http](#provider\_http) | 3.5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.amazon_linux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [http_http.my_ip](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | The name tag for the EC2 instance | `string` | `"MyModuleInstance"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The type of EC2 instance to create | `string` | `"t3.micro"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | The name of the SSH key pair in AWS | `string` | n/a | yes |
| <a name="input_public_key_path"></a> [public\_key\_path](#input\_public\_key\_path) | The local path to the public key (.pub) file | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | n/a |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | The public IP of the EC2 instance |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group |
<!-- END_TF_DOCS -->
