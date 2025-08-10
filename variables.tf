# Required variables

variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where RDS will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs"
  type        = list(string)
}

variable "name_prefix" {
  description = "Name prefix used for RDS identifier and related resources"
  type        = string

  validation {
    condition     = length(var.name_prefix) > 0 && length(var.name_prefix) <= 63
    error_message = "name_prefix must be 1-63 characters long."
  }

  validation {
    condition     = lower(var.name_prefix) == var.name_prefix
    error_message = "name_prefix must be lowercase."
  }

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*$", var.name_prefix))
    error_message = "name_prefix must start with a letter and contain only lowercase letters, numbers, and hyphens."
  }

  validation {
    condition     = length(regexall("--", var.name_prefix)) == 0
    error_message = "name_prefix must not contain consecutive hyphens ('--')."
  }

  validation {
    condition     = endswith(var.name_prefix, "-") == false
    error_message = "name_prefix must not end with a hyphen."
  }
}

variable "database_name" {
  description = "The name of the database to create"
  type        = string

  validation {
    condition     = length(var.database_name) > 0 && length(var.database_name) <= 63
    error_message = "database_name must be 1-63 characters long."
  }

  validation {
    condition     = lower(var.database_name) == var.database_name
    error_message = "database_name must be lowercase."
  }

  validation {
    condition     = can(regex("^[a-z][a-z0-9_]*$", var.database_name))
    error_message = "database_name must start with a letter and contain only lowercase letters, numbers, and underscores."
  }
}

variable "username" {
  description = "Username for the master DB user"
  type        = string

  validation {
    condition     = length(var.username) > 0 && length(var.username) <= 63
    error_message = "username must be 1-63 characters long."
  }

  validation {
    condition     = lower(var.username) == var.username
    error_message = "username must be lowercase."
  }

  validation {
    condition     = can(regex("^[a-z][a-z0-9]*$", var.username))
    error_message = "username must start with a letter and contain only lowercase letters and numbers."
  }

  validation {
    condition     = !(var.username == "postgres" || var.username == "rdsadmin")
    error_message = "username cannot be one of the reserved names: postgres, rdsadmin."
  }
}

variable "password" {
  description = "Password for the master DB user (8-128 chars)."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.password) >= 8 && length(var.password) <= 128
    error_message = "password must be 8-128 characters long."
  }
}

# Optional variables with defaults

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "17.4"
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)"
  type        = string
  default     = "gp2"
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = true
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "The daily time range during which automated backups are created"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "The window to perform maintenance in"
  type        = string
  default     = "Mon:04:00-Mon:05:00"
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Enable deletion protection to prevent accidental DB instance deletion"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}

variable "ingress_cidr_blocks" {
  description = "List of CIDR blocks to allow access to the database. If not provided, allows access from anywhere."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "egress_cidr_blocks" {
  description = "List of CIDR blocks to allow egress traffic from the database. If not provided, allows traffic to anywhere."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
