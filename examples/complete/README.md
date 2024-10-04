<!-- BEGIN_TF_DOCS -->
# Example: Complete (includes pre-configured Wayfinder SSO)

## Deployment

1. Create a DNS Zone in AWS Route53 and ensure the domain is delegated to the AWS nameservers.
2. Create an AWS Secrets Manager Secret with your Product Licence Key and IDP details:
```sh
$ aws secretsmanager create-secret --name wayfinder-secrets

$ cat secret.json
{
  "licenceKey": "LICENCE-KEY",
  "idpClientId": "CLIENT-ID",
  "idpClientSecret": "CLIENT-SECRET",
  "idpServerUrl": "IDP-SERVER-URL",
  "idpAzureTenantId": ""
}

$ aws secretsmanager put-secret-value --secret-id wayfinder-secrets --secret-string file://secret.json
```
3. Copy the `terraform.tfvars.example` file to `terraform.tfvars` and update with your values.
4. Run `terraform init -upgrade -backend-config="bucket=BUCKET-NAME" -backend-config="key=STATE-FILE.tfstate" -backend-config="encrypt=true" -backend-config="dynamodb_table=TABLE-NAME" -backend-config="region=AWS-REGION"`
5. Run `terraform apply`

## Updating Docs

The `terraform-docs` utility is used to generate this README. Follow the below steps to update:
1. Make changes to the `.terraform-docs.yml` file
2. Fetch the `terraform-docs` binary (https://terraform-docs.io/user-guide/installation/)
3. Run `terraform-docs markdown table --output-file ${PWD}/README.md --output-mode inject .`

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_entries"></a> [access\_entries](#input\_access\_entries) | Map of access entries to add to the cluster. | <pre>map(object({<br/>    kubernetes_groups = optional(list(string))<br/>    principal_arn     = string<br/>    policy_associations = optional(map(object({<br/>      policy_arn = string<br/>      access_scope = object({<br/>        namespaces = optional(list(string))<br/>        type       = string<br/>      })<br/>    })))<br/>  }))</pre> | `{}` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones to deploy into. | `list(string)` | <pre>[<br/>  "eu-west-2a",<br/>  "eu-west-2b",<br/>  "eu-west-2c"<br/>]</pre> | no |
| <a name="input_aws_secretsmanager_name"></a> [aws\_secretsmanager\_name](#input\_aws\_secretsmanager\_name) | The name of the AWS Secrets Manager secret to fetch, which contains IDP configuration. | `string` | `"wayfinder-secrets"` | no |
| <a name="input_clusterissuer_email"></a> [clusterissuer\_email](#input\_clusterissuer\_email) | The email address to use for the cert-manager cluster issuer. | `string` | n/a | yes |
| <a name="input_create_localadmin_user"></a> [create\_localadmin\_user](#input\_create\_localadmin\_user) | Whether to create a localadmin user for access to the Wayfinder Portal and API. | `bool` | `false` | no |
| <a name="input_disable_internet_access"></a> [disable\_internet\_access](#input\_disable\_internet\_access) | Whether to disable internet access for EKS and the Wayfinder ingress controller. | `bool` | `false` | no |
| <a name="input_disable_local_login"></a> [disable\_local\_login](#input\_disable\_local\_login) | Whether to disable local login for Wayfinder. Note: An IDP must be configured within Wayfinder, otherwise you will not be able to log in. | `bool` | `false` | no |
| <a name="input_dns_zone_name"></a> [dns\_zone\_name](#input\_dns\_zone\_name) | The local DNS zone to use (e.g. wayfinder.example.com). | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name we are provisioning. | `string` | `"production"` | no |
| <a name="input_idp_provider"></a> [idp\_provider](#input\_idp\_provider) | The Identity Provider type to configure for Wayfinder (supported: generic, aad). | `string` | `"generic"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources. | `map(any)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for the Wayfinder VPC. | `string` | `"10.0.0.0/21"` | no |
| <a name="input_vpc_private_subnets"></a> [vpc\_private\_subnets](#input\_vpc\_private\_subnets) | List of private subnets in the Wayfinder VPC. | `list(string)` | <pre>[<br/>  "10.0.0.0/24",<br/>  "10.0.1.0/24",<br/>  "10.0.2.0/24"<br/>]</pre> | no |
| <a name="input_vpc_public_subnets"></a> [vpc\_public\_subnets](#input\_vpc\_public\_subnets) | List of public subnets in the Wayfinder VPC. | `list(string)` | <pre>[<br/>  "10.0.3.0/24",<br/>  "10.0.4.0/24",<br/>  "10.0.5.0/24"<br/>]</pre> | no |
| <a name="input_wayfinder_instance_id"></a> [wayfinder\_instance\_id](#input\_wayfinder\_instance\_id) | The instance ID to use for Wayfinder. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the Wayfinder EKS cluster |
| <a name="output_wayfinder_api_url"></a> [wayfinder\_api\_url](#output\_wayfinder\_api\_url) | The URL for the Wayfinder API |
| <a name="output_wayfinder_ui_url"></a> [wayfinder\_ui\_url](#output\_wayfinder\_ui\_url) | The URL for the Wayfinder UI |
<!-- END_TF_DOCS -->