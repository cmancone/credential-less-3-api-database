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

##########
# Python #
##########
variable "zip_filename" {
  type        = string
  description = "The zip file with all the python code for the service"
  default     = "python.zip"
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
  default     = "5.7.mysql_aurora.2.07.1"
  description = "The Aurora engine to use"
}

variable "database_incoming_security_group_ids" {
  type        = list(string)
  default     = []
  description = "List of security group ids that should be able to access the database"
}

#############
# AKeyless ##
#############
variable "akeyless_terraform_access_id" {
  type        = string
  description = "The access id for Terraform to use when logging into AKeyless"
}

variable "akeyless_folder" {
  type        = string
  description = "The desired path to the folder where all database targets/producers will be kept"
}

variable "akeyless_api_host" {
  type        = string
  description = "The URL to the gateway where the service will login and fetch credentials from"
  default     = "https://api.akeyless.io"
}

variable "akeyless_gateway_domain_name" {
  type        = string
  description = "The domain where your gateway lives, and where dynamic producers will be created"
}

variable "akeyless_gateway_security_group_id" {
  type        = string
  description = "The security group id for your gateway (so it can be granted database access)"
}

###############
# Application #
###############
variable "application_lb_subnet_ids" {
  type        = list(string)
  description = "The IDs of the subnets to put the load balancer in (typically public subnets)"
}

variable "application_route_53_hosted_zone_name" {
  type        = string
  description = "The Route53 hosted zone where that will hold the load balancer domain name"
}

variable "application_domain_name" {
  type        = string
  description = "The domain name for the application load balancer"
}

########
# Misc #
########
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to attach to all resources"
}
