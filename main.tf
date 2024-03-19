#already defined in dynamic "domain_endpoint_options", dynamic "log_publishing_options", dynamic "encrypt_at_rest" 
#trivy:ignore:avd-aws-0046 trivy:ignore:avd-aws-0042 trivy:ignore:avd-aws-0048 trivy:ignore:avd-aws-0126
resource "aws_elasticsearch_domain" "default" {
  count                 = var.enabled ? 1 : 0
  domain_name           = var.domain_name
  elasticsearch_version = var.elasticsearch_version

  advanced_options = var.advanced_options

  access_policies = var.access_policies

  dynamic "advanced_security_options" {
    for_each = var.advanced_security_options != null ? [var.advanced_security_options] : []
    content {
      enabled                        = advanced_security_options.value.enabled
      internal_user_database_enabled = advanced_security_options.value.internal_user_database_enabled

      dynamic "master_user_options" {
        for_each = length(advanced_security_options.value.master_user_options) > 0 ? advanced_security_options.value.master_user_options : []
        content {
          master_user_arn      = try(master_user_options.value.master_user_arn, null)
          master_user_name     = try(master_user_options.value.master_user_name, null)
          master_user_password = try(master_user_options.value.master_user_password, null)
        }
      }
    }
  }

  dynamic "ebs_options" {
    for_each = var.ebs_options != null ? [var.ebs_options] : []
    content {
      ebs_enabled = ebs_options.value.ebs_enabled
      volume_size = try(ebs_options.value.volume_size, null)
      volume_type = try(ebs_options.value.volume_type, null)
      iops        = ebs_options.value.iops > 0 ? ebs_options.value.iops : null
      throughput  = ebs_options.value.throughput > 125 ? ebs_options.value.throughput : null
    }
  }

  dynamic "encrypt_at_rest" {
    for_each = var.encrypt_at_rest != null ? [var.encrypt_at_rest] : []
    content {
      enabled    = encrypt_at_rest.value.enabled
      kms_key_id = lookup(var.encrypt_at_rest, "kms_key_alias", null) != null ? data.aws_kms_key.kms[0].id : try(encrypt_at_rest.value.kms_key_id, null)
    }
  }

  dynamic "domain_endpoint_options" {
    for_each = var.domain_endpoint_options != null ? [var.domain_endpoint_options] : []
    content {
      enforce_https                   = try(domain_endpoint_options.value.enforce_https, true)
      tls_security_policy             = try(domain_endpoint_options.value.tls_security_policy, "Policy-Min-TLS-1-2-2019-07")
      custom_endpoint_enabled         = domain_endpoint_options.value.custom_endpoint_enabled
      custom_endpoint                 = try(domain_endpoint_options.value.custom_endpoint, null)
      custom_endpoint_certificate_arn = try(domain_endpoint_options.value.custom_endpoint_certificate_arn, null)
    }
  }

  dynamic "cluster_config" {
    for_each = var.cluster_config != null ? [var.cluster_config] : []
    content {
      instance_count           = cluster_config.value.instance_count
      instance_type            = cluster_config.value.instance_type
      dedicated_master_enabled = cluster_config.value.dedicated_master_enabled
      dedicated_master_count   = cluster_config.value.dedicated_master_enabled ? cluster_config.value.dedicated_master_count : null
      dedicated_master_type    = cluster_config.value.dedicated_master_enabled ? cluster_config.value.dedicated_master_type : null
      zone_awareness_enabled   = cluster_config.value.zone_awareness_enabled
      warm_enabled             = cluster_config.value.warm_enabled
      warm_count               = cluster_config.value.warm_enabled ? cluster_config.value.warm_count : null
      warm_type                = cluster_config.value.warm_enabled ? cluster_config.value.warm_type : null

      dynamic "zone_awareness_config" {
        for_each = cluster_config.value.zone_awareness_config != null ? cluster_config.value.zone_awareness_config : []
        content {
          availability_zone_count = zone_awareness_config.value.availability_zone_count
        }
      }

      dynamic "cold_storage_options" {
        for_each = cluster_config.value.cold_storage_options != null ? cluster_config.value.cold_storage_options : []
        content {
          enabled = cold_storage_options.value.enabled
        }
      }
    }
  }

  dynamic "auto_tune_options" {
    for_each = var.auto_tune_options != null ? [var.auto_tune_options] : []
    content {
      desired_state = auto_tune_options.value.desired_state
      dynamic "maintenance_schedule" {
        for_each = length(auto_tune_options.value.maintenance_schedule) > 0 ? auto_tune_options.value.maintenance_schedule : []
        content {
          cron_expression_for_recurrence = maintenance_schedule.value.cron_expression_for_recurrence
          duration {
            value = maintenance_schedule.value.duration[0].value
            unit  = maintenance_schedule.value.duration[0].unit
          }
          start_at = maintenance_schedule.value.start_at
        }
      }
    }
  }

  node_to_node_encryption {
    enabled = var.node_to_node_encryption_enabled
  }

  dynamic "vpc_options" {
    for_each = var.vpc_options != null ? [var.vpc_options] : []
    content {
      security_group_ids = vpc_options.value.security_group_ids
      subnet_ids         = lookup(vpc_options.value, "subnet_names", null) != null ? data.aws_subnet.default[*].id : vpc_options.value.subnet_ids
    }
  }

  snapshot_options {
    automated_snapshot_start_hour = var.automated_snapshot_start_hour
  }

  dynamic "cognito_options" {
    for_each = var.cognito_options != null ? [var.cognito_options] : []
    content {
      enabled          = cognito_options.value.enabled
      user_pool_id     = cognito_options.value.user_pool_id
      identity_pool_id = cognito_options.value.identity_pool_id
      role_arn         = cognito_options.value.role_arn
    }
  }

  dynamic "log_publishing_options" {
    for_each = var.log_publishing_options != null ? var.log_publishing_options : []
    content {
      cloudwatch_log_group_arn = log_publishing_options.value.cloudwatch_log_group_arn
      enabled                  = log_publishing_options.value.enabled
      log_type                 = log_publishing_options.value.log_type
    }
  }

  tags = var.tags

}
