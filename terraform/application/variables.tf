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
  description = "List of subnet ids to deploy the lambda to"
}

variable "database_security_group_id" {
  type        = string
  description = "The security group id for the database"
}

############
# AKeyless #
############
variable "akeyless_access_id" {
  type        = string
  description = "The access id for the lambdas to use when logging into AWS"
}

variable "akeyless_api_host" {
  type        = string
  description = "The URL to the gateway where the service will login and fetch credentials from"
}

variable "akeyless_database_producer_path" {
  type        = string
  description = "The path to the MySQL database producer that the application will use to fetch credentials"
}

######################
# Application Lambda #
######################
variable "database_host" {
  type        = string
  description = "The URL to the database cluster to connect to"
}

variable "database_name" {
  type        = string
  description = "The name of the database to use (in the database cluster)"
}

variable "zip_filename" {
  type        = string
  description = "Filename for the zip file containing the build of the database migrator"
  default     = "python.zip"
}

variable "application_handler" {
  type        = string
  description = "Handler for the lambda migrator"
  default     = "api.lambda_handler"
}

variable "application_runtime" {
  type        = string
  description = "Runtime for the lambda migrator"
  default     = "python3.8"
}

#################
# Load Balancer #
#################
variable "lb_subnet_ids" {
  type        = list(string)
  description = "The IDs of the subnets to put the load balancer in (typically public subnets)"
}

variable "route_53_hosted_zone_name" {
  type        = string
  description = "The Route53 hosted zone where that will hold the load balancer domain name"
}

variable "domain_name" {
  type        = string
  description = "The domain name for the application load balancer"
}

variable "alb_access_logs_bucket_name" {
  type        = string
  description = "The name of the bucket to send load balancer logs to"
  default     = null
}

variable "ssl_policy" {
  type        = string
  description = "The AWS SSL policy to use"
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

########
# Misc #
########
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to attach to all resources"
}
