variable "enabled" {
  type        = bool
  description = "Whether to enable custom endpoint for the Elasticsearch domain."
  default     = true
}

variable "domain_name" {
  type        = string
  description = "Name of the Elasticsearch domain"
}

variable "elasticsearch_version" {
  type        = string
  default     = "7.4"
  description = "Version of Elasticsearch to deploy (_e.g._ `7.4`, `7.1`, `6.8`, `6.7`, `6.5`, `6.4`, `6.3`, `6.2`, `6.0`, `5.6`, `5.5`, `5.3`, `5.1`, `2.3`, `1.5`"
}

variable "availability_zone_count" {
  type        = number
  default     = 2
  description = "Number of Availability Zones for the domain to use."

  validation {
    condition     = contains([2, 3], var.availability_zone_count)
    error_message = "The availibility zone count must be 2 or 3."
  }
}
variable "automated_snapshot_start_hour" {
  type        = number
  description = "Hour at which automated snapshots are taken, in UTC"
  default     = 0
}

variable "advanced_options" {
  type        = map(string)
  default     = {}
  description = "Key-value string pairs to specify advanced configuration options"
}

variable "auto_tune" {
  type = object({
    enabled             = bool
    rollback_on_disable = string
    starting_time       = string
    cron_schedule       = string
    duration            = number
  })

  default = {
    enabled             = false
    rollback_on_disable = "NO_ROLLBACK"
    starting_time       = null
    cron_schedule       = null
    duration            = null
  }

  description = <<-EOT
    This object represents the auto_tune configuration. It contains the following filed:
    - enabled - Whether to enable autotune.
    - rollback_on_disable - Whether to roll back to default Auto-Tune settings when disabling Auto-Tune.
    - starting_time - Date and time at which to start the Auto-Tune maintenance schedule in RFC3339 format. Time should be in the future.
    - cron_schedule - A cron expression specifying the recurrence pattern for an Auto-Tune maintenance schedule.
    - duration - Autotune maintanance window duration time in hours.
  EOT

  validation {
    condition     = var.auto_tune.enabled == false || var.auto_tune.cron_schedule != null
    error_message = "Variable auto_tune.cron_schedule should be set if var.auto_tune.enabled == true."
  }

  validation {
    condition     = var.auto_tune.enabled == false || var.auto_tune.duration != null
    error_message = "Variable auto_tune.duration should be set if var.auto_tune.enabled == true."
  }

  validation {
    condition     = contains(["DEFAULT_ROLLBACK", "NO_ROLLBACK"], var.auto_tune.rollback_on_disable)
    error_message = "Variable auto_tune.rollback_on_disable valid values: DEFAULT_ROLLBACK or NO_ROLLBACK."
  }
}

variable "access_policies" {
  type        = string
  description = "IAM policy document specifying the access policies for the domain"
  default     = null
}

variable "vpc_name" {
  type        = string
  description = "VPC Name"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Map of tags for the AWS resources"
}

variable "vpc_options" {
  type = object({
    subnet_ids         = optional(list(string))
    security_group_ids = list(string)
    subnet_names       = optional(list(string))
  })
  description = "Configuration block containing VPC information"
  default     = null
}

variable "encrypt_at_rest" {
  type = object({
    enabled       = bool
    kms_key_id    = optional(string)
    kms_key_alias = optional(string)
  })
  description = "Configuration block containing encryption at rest options"
  default = {
    enabled       = true
    kms_key_id    = null
    kms_key_alias = null
  }
}

variable "advanced_security_options" {
  type = object({
    enabled                        = bool
    internal_user_database_enabled = bool
    master_user_options = list(object({
      master_user_arn      = optional(string)
      master_user_name     = optional(string)
      master_user_password = optional(string)
    }))
  })
  description = "Configuration block containing advanced security options"
  default     = null
}

variable "domain_endpoint_options" {
  type = object({
    enforce_https                   = bool
    tls_security_policy             = optional(string)
    custom_endpoint_enabled         = bool
    custom_endpoint                 = optional(string)
    custom_endpoint_certificate_arn = optional(string)
  })
  description = "Configuration block containing domain endpoint options"
  default     = null
}


variable "ebs_options" {
  type = object({
    ebs_enabled = bool
    volume_size = number
    volume_type = string
    iops        = number
    throughput  = number
  })
  description = "Configuration block containing EBS options"
  default     = null
}

variable "cluster_config" {
  type = object({
    instance_type            = string
    instance_count           = number
    dedicated_master_enabled = bool
    dedicated_master_count   = number
    dedicated_master_type    = string
    zone_awareness_enabled   = bool
    zone_awareness_config = list(object({
      availability_zone_count = number
    }))
    warm_enabled = bool
    warm_count   = number
    warm_type    = string
    cold_storage_options = list(object({
      enabled      = bool
      storage_type = optional(string)
    }))
  })
  description = "Configuration block containing cluster configuration options"
  default     = null
}

variable "auto_tune_options" {
  type = object({
    desired_state = string
    maintenance_schedule = list(object({
      cron_expression_for_recurrence = optional(string)
      duration = list(object({
        value = number
        unit  = string
      }))
      start_at = optional(string)
    }))
    rollback_on_disable = optional(string)
  })
  description = "Configuration block containing auto-tune options"
  default     = null
}

variable "node_to_node_encryption_enabled" {
  type        = bool
  default     = true
  description = "Whether to enable node-to-node encryption"
}


variable "cognito_options" {
  type = object({
    enabled          = bool
    identity_pool_id = optional(string)
    role_arn         = optional(string)
    user_pool_id     = optional(string)
  })
  description = "Configuration block containing cognito options"
  default     = null
}

variable "log_publishing_options" {
  type = list(object({
    cloudwatch_log_group_arn = optional(string)
    enabled                  = optional(bool)
    log_type                 = optional(string)
  }))
  description = "Configuration block containing log publishing options"
  default     = null
}
