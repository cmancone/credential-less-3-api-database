variable "name" {
  type        = string
  description = "The name for this application"

  validation {
    condition     = length(var.name) <= 32
    error_message = "The name must be 32 characters or less to comply with AWS naming requirements."
  }

  validation {
    condition     = can(regex("^[0-9A-Za-z-]+$", var.name))
    error_message = "The name can only contain letters, numbers, and hyphens in order to comply with AWS naming requirements."
  }
}

##############
# Networking #
##############
variable "vpc_id" {
  type        = string
  description = "The id of the VPC to use for all infrastructure"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet ids to make the database accessible in"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones that the database should live in"
}

variable "incoming_security_group_ids" {
  type        = list(string)
  description = "List of security group ids that should be able to access the database"
}

##################
# Database Specs #
##################
variable "engine_version" {
  type        = string
  default     = "5.7.mysql_aurora.2.07.3"
  description = "The Aurora engine to use"
}

variable "tags" {
  type        = map(string)
  description = "Tags to attach to all resources"
  default     = {}
}
