<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.67 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.67 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_elasticsearch_domain.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain) | resource |
| [aws_kms_key.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_subnet.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_policies"></a> [access\_policies](#input\_access\_policies) | IAM policy document specifying the access policies for the domain | `string` | `null` | no |
| <a name="input_advanced_options"></a> [advanced\_options](#input\_advanced\_options) | Key-value string pairs to specify advanced configuration options | `map(string)` | `{}` | no |
| <a name="input_advanced_security_options"></a> [advanced\_security\_options](#input\_advanced\_security\_options) | Configuration block containing advanced security options | <pre>object({<br>    enabled                        = bool<br>    internal_user_database_enabled = bool<br>    master_user_options = list(object({<br>      master_user_arn      = optional(string)<br>      master_user_name     = optional(string)<br>      master_user_password = optional(string)<br>    }))<br>  })</pre> | `null` | no |
| <a name="input_auto_tune"></a> [auto\_tune](#input\_auto\_tune) | This object represents the auto\_tune configuration. It contains the following filed:<br>- enabled - Whether to enable autotune.<br>- rollback\_on\_disable - Whether to roll back to default Auto-Tune settings when disabling Auto-Tune.<br>- starting\_time - Date and time at which to start the Auto-Tune maintenance schedule in RFC3339 format. Time should be in the future.<br>- cron\_schedule - A cron expression specifying the recurrence pattern for an Auto-Tune maintenance schedule.<br>- duration - Autotune maintanance window duration time in hours. | <pre>object({<br>    enabled             = bool<br>    rollback_on_disable = string<br>    starting_time       = string<br>    cron_schedule       = string<br>    duration            = number<br>  })</pre> | <pre>{<br>  "cron_schedule": null,<br>  "duration": null,<br>  "enabled": false,<br>  "rollback_on_disable": "NO_ROLLBACK",<br>  "starting_time": null<br>}</pre> | no |
| <a name="input_auto_tune_options"></a> [auto\_tune\_options](#input\_auto\_tune\_options) | Configuration block containing auto-tune options | <pre>object({<br>    desired_state = string<br>    maintenance_schedule = list(object({<br>      cron_expression_for_recurrence = optional(string)<br>      duration = list(object({<br>        value = number<br>        unit  = string<br>      }))<br>      start_at = optional(string)<br>    }))<br>    rollback_on_disable = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_automated_snapshot_start_hour"></a> [automated\_snapshot\_start\_hour](#input\_automated\_snapshot\_start\_hour) | Hour at which automated snapshots are taken, in UTC | `number` | `0` | no |
| <a name="input_availability_zone_count"></a> [availability\_zone\_count](#input\_availability\_zone\_count) | Number of Availability Zones for the domain to use. | `number` | `2` | no |
| <a name="input_cluster_config"></a> [cluster\_config](#input\_cluster\_config) | Configuration block containing cluster configuration options | <pre>object({<br>    instance_type            = string<br>    instance_count           = number<br>    dedicated_master_enabled = bool<br>    dedicated_master_count   = number<br>    dedicated_master_type    = string<br>    zone_awareness_enabled   = bool<br>    zone_awareness_config = list(object({<br>      availability_zone_count = number<br>    }))<br>    warm_enabled = bool<br>    warm_count   = number<br>    warm_type    = string<br>    cold_storage_options = list(object({<br>      enabled      = bool<br>      storage_type = optional(string)<br>    }))<br>  })</pre> | `null` | no |
| <a name="input_cognito_options"></a> [cognito\_options](#input\_cognito\_options) | Configuration block containing cognito options | <pre>object({<br>    enabled          = bool<br>    identity_pool_id = optional(string)<br>    role_arn         = optional(string)<br>    user_pool_id     = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_domain_endpoint_options"></a> [domain\_endpoint\_options](#input\_domain\_endpoint\_options) | Configuration block containing domain endpoint options | <pre>object({<br>    enforce_https                   = bool<br>    tls_security_policy             = optional(string)<br>    custom_endpoint_enabled         = bool<br>    custom_endpoint                 = optional(string)<br>    custom_endpoint_certificate_arn = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Name of the Elasticsearch domain | `string` | n/a | yes |
| <a name="input_ebs_options"></a> [ebs\_options](#input\_ebs\_options) | Configuration block containing EBS options | <pre>object({<br>    ebs_enabled = bool<br>    volume_size = number<br>    volume_type = string<br>    iops        = number<br>    throughput  = number<br>  })</pre> | `null` | no |
| <a name="input_elasticsearch_version"></a> [elasticsearch\_version](#input\_elasticsearch\_version) | Version of Elasticsearch to deploy (\_e.g.\_ `7.4`, `7.1`, `6.8`, `6.7`, `6.5`, `6.4`, `6.3`, `6.2`, `6.0`, `5.6`, `5.5`, `5.3`, `5.1`, `2.3`, `1.5` | `string` | `"7.4"` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether to enable custom endpoint for the Elasticsearch domain. | `bool` | `true` | no |
| <a name="input_encrypt_at_rest"></a> [encrypt\_at\_rest](#input\_encrypt\_at\_rest) | Configuration block containing encryption at rest options | <pre>object({<br>    enabled       = bool<br>    kms_key_id    = optional(string)<br>    kms_key_alias = optional(string)<br>  })</pre> | <pre>{<br>  "enabled": true,<br>  "kms_key_alias": null,<br>  "kms_key_id": null<br>}</pre> | no |
| <a name="input_log_publishing_options"></a> [log\_publishing\_options](#input\_log\_publishing\_options) | Configuration block containing log publishing options | <pre>list(object({<br>    cloudwatch_log_group_arn = optional(string)<br>    enabled                  = optional(bool)<br>    log_type                 = optional(string)<br>  }))</pre> | `null` | no |
| <a name="input_node_to_node_encryption_enabled"></a> [node\_to\_node\_encryption\_enabled](#input\_node\_to\_node\_encryption\_enabled) | Whether to enable node-to-node encryption | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags for the AWS resources | `map(string)` | `{}` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | VPC Name | `string` | n/a | yes |
| <a name="input_vpc_options"></a> [vpc\_options](#input\_vpc\_options) | Configuration block containing VPC information | <pre>object({<br>    subnet_ids         = optional(list(string))<br>    security_group_ids = list(string)<br>    subnet_names       = optional(list(string))<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the Elasticsearch domain |
| <a name="output_id"></a> [id](#output\_id) | Unique identifier for the Elasticsearch domain |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
