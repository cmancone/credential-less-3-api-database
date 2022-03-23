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

variable "region" {
  type        = string
  description = "The name of the region that the infrastructure lives in"
}

variable "vpc_id" {
  type        = string
  description = "The id of the VPC to use for all infrastructure"
}

############
# Database #
############
variable "database_subnet_ids" {
  type        = list(string)
  description = "List of subnet ids to make the database accessible in"
}

variable "database_bastion_subnet_id" {
  type        = string
  description = "The id of the (public) subnet to put the bastion in"
}

variable "database_availability_zones" {
  type        = list(string)
  description = "List of availability zones that the database should live in"
}

variable "database_engine_version" {
  type        = string
  default     = "5.7.mysql_aurora.2.07.3"
  description = "The Aurora engine to use"
}

variable "database_incoming_security_group_ids" {
  type        = list(string)
  default     = []
  description = "List of security group ids that should be able to access the database"
}

variable "database_path_to_provider" {
  type        = string
  description = "The desired path for the database provider"
}

########
# Misc #
########
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to attach to all resources"
}
