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

variable "bastion_subnet_id" {
  type        = string
  description = "The id of the subnet to put the bastion in"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones that the database should live in"
}

variable "incoming_security_group_ids" {
  type        = list(string)
  description = "List of security group ids that should be able to access the database"
}

####################
# Database workers #
####################
variable "instance_class" {
  type        = string
  description = "The instance type to use for the database workers"
  default     = "db.t3.small"
}

variable "instance_count" {
  type        = number
  description = "The number of database workers to launch"
  default     = 1
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

############
# AKeyless #
############
variable "akeyless_api_host" {
  type        = string
  description = "The URL to the gateway where the service will login and fetch credentials from"
}

variable "akeyless_folder" {
  type        = string
  description = "The desired path to the folder where all database targets/producers will be kept"
}

####################
# Migration Lambda #
####################
variable "zip_filename" {
  type        = string
  description = "Filename for the zip file containing the build of the database migrator"
}

variable "migration_handler" {
  type        = string
  description = "Handler for the lambda migrator"
  default     = "migrate_database.lambda_handler"
}

variable "migration_runtime" {
  type        = string
  description = "Runtime for the lambda migrator"
  default     = "python3.8"
}

########
# Misc #
########
variable "akeyless_ca_public_key" {
  type        = string
  description = "The public key of the AKeyless CA that will be used for cert-based authentication to SSH into the bastion"
}
