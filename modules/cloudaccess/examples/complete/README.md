<!-- BEGIN_TF_DOCS -->
## Providers

No providers.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_policy_arns"></a> [custom\_policy\_arns](#input\_custom\_policy\_arns) | List of custom IAM policy ARNs to attach to the role in addition to the built-in policies. | `list(string)` | `[]` | no |
| <a name="input_custom_policy_documents"></a> [custom\_policy\_documents](#input\_custom\_policy\_documents) | List of custom IAM policy documents in JSON format. Each policy will be created as a separate IAM policy resource with an auto-generated name. | `list(string)` | `[]` | no |
| <a name="input_enable_cloud_info_permissions"></a> [enable\_cloud\_info\_permissions](#input\_enable\_cloud\_info\_permissions) | Whether to grant Cloud Info permissions to the generated IAM Role | `bool` | `false` | no |
| <a name="input_enable_cluster_manager_permissions"></a> [enable\_cluster\_manager\_permissions](#input\_enable\_cluster\_manager\_permissions) | Whether to grant Cluster Manager permissions to the generated IAM Role | `bool` | `false` | no |
| <a name="input_enable_dns_zone_manager_permissions"></a> [enable\_dns\_zone\_manager\_permissions](#input\_enable\_dns\_zone\_manager\_permissions) | Whether to grant DNS Zone Manager permissions to the generated IAM Role | `bool` | `false` | no |
| <a name="input_enable_network_manager_permissions"></a> [enable\_network\_manager\_permissions](#input\_enable\_network\_manager\_permissions) | Whether to grant Network Manager permissions to the generated IAM Role | `bool` | `false` | no |
| <a name="input_enable_peering_acceptor_permissions"></a> [enable\_peering\_acceptor\_permissions](#input\_enable\_peering\_acceptor\_permissions) | Whether to grant Peering Acceptor permissions to the generated IAM Role | `bool` | `false` | no |
| <a name="input_from_aws"></a> [from\_aws](#input\_from\_aws) | Whether Wayfinder is running on AWS. | `bool` | `true` | no |
| <a name="input_from_azure"></a> [from\_azure](#input\_from\_azure) | Whether Wayfinder is running on Azure. | `bool` | `false` | no |
| <a name="input_from_gcp"></a> [from\_gcp](#input\_from\_gcp) | Whether Wayfinder is running on GCP. | `bool` | `false` | no |
| <a name="input_provision_oidc_trust"></a> [provision\_oidc\_trust](#input\_provision\_oidc\_trust) | Provisions an AWS OIDC Provider reference for Azure tenant ID. Set to false if you are managing OIDC provider trusts elsewhere. | `bool` | `true` | no |
| <a name="input_resource_suffix"></a> [resource\_suffix](#input\_resource\_suffix) | Suffix to apply to all generated resources. We recommend using workspace key + stage. | `string` | `""` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name to use for the generated role, will have resource\_suffix appended | `string` | `"wayfinder"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources created. | `map(string)` | `{}` | no |
| <a name="input_wayfinder_identity_aws_role_arn"></a> [wayfinder\_identity\_aws\_role\_arn](#input\_wayfinder\_identity\_aws\_role\_arn) | ARN of Wayfinder's identity to give access to. Populate when Wayfinder is running on AWS with IRSA, or with the user ARN when using a credential-based AWS identity. | `string` | `""` | no |
| <a name="input_wayfinder_identity_azure_client_id"></a> [wayfinder\_identity\_azure\_client\_id](#input\_wayfinder\_identity\_azure\_client\_id) | Client ID of Wayfinder's Azure AD managed identity to give access to. Populate when Wayfinder is running on Azure with AzureAD Workload Identity. | `string` | `""` | no |
| <a name="input_wayfinder_identity_azure_tenant_id"></a> [wayfinder\_identity\_azure\_tenant\_id](#input\_wayfinder\_identity\_azure\_tenant\_id) | Tenant ID of Wayfinder's Azure AD managed identity to give access to. Populate when Wayfinder is running on Azure with AzureAD Workload Identity. | `string` | `""` | no |
| <a name="input_wayfinder_identity_gcp_service_account"></a> [wayfinder\_identity\_gcp\_service\_account](#input\_wayfinder\_identity\_gcp\_service\_account) | Email address of Wayfinder's GCP service account to give access to. Populate when Wayfinder is running on GCP with Workload Identity. | `string` | `""` | no |
| <a name="input_wayfinder_identity_gcp_service_account_id"></a> [wayfinder\_identity\_gcp\_service\_account\_id](#input\_wayfinder\_identity\_gcp\_service\_account\_id) | Numerical ID  of Wayfinder's GCP service account to give access to. Populate when Wayfinder is running on GCP with Workload Identity. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudaccess"></a> [cloudaccess](#output\_cloudaccess) | n/a |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | ARNs of Cloud Resource IAM role to use in your CloudAccessConfig |
<!-- END_TF_DOCS -->