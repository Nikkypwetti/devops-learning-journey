# static-website-project

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | >= 3.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_my_static_website"></a> [my\_static\_website](#module\_my\_static\_website) | ./modules/static-website | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | The AWS CLI profile to use | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to deploy resources in | `string` | `"us-east-1"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Must be globally unique | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_url"></a> [cloudfront\_url](#output\_cloudfront\_url) | The domain name of the CloudFront distribution |
| <a name="output_s3_website_endpoint"></a> [s3\_website\_endpoint](#output\_s3\_website\_endpoint) | n/a |
<!-- END_TF_DOCS -->
