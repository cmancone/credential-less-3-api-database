terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "[your-bucket-here]"
    key    = "products-service.json"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region
}

module "database" {
  source = "./database"

  name                         = var.name
  region                       = var.region
  vpc_id                       = var.vpc_id
  availability_zones           = var.database_availability_zones
  subnet_ids                   = var.database_subnet_ids
  database_security_group_id   = aws_security_group.database.id
  zip_filename                 = var.zip_filename
  bastion_subnet_id            = var.database_bastion_subnet_id
  engine_version               = var.database_engine_version
  incoming_security_group_ids  = concat(var.database_incoming_security_group_ids, [var.akeyless_gateway_security_group_id])
  akeyless_api_host            = var.akeyless_api_host
  akeyless_folder              = var.akeyless_folder
  akeyless_gateway_domain_name = var.akeyless_gateway_domain_name
  akeyless_terraform_access_id = var.akeyless_terraform_access_id
}

module "application" {
  source = "./application"

  name                            = var.name
  region                          = var.region
  vpc_id                          = var.vpc_id
  subnet_ids                      = var.database_subnet_ids
  database_security_group_id      = aws_security_group.database.id
  zip_filename                    = var.zip_filename
  akeyless_api_host               = var.akeyless_api_host
  akeyless_database_producer_path = module.database.database_producer_path_application
  akeyless_terraform_access_id    = var.akeyless_terraform_access_id
  akeyless_folder                 = var.akeyless_folder
  database_name                   = module.database.database_name
  database_host                   = module.database.database_host
  lb_subnet_ids                   = var.application_lb_subnet_ids
  route_53_hosted_zone_name       = var.application_route_53_hosted_zone_name
  domain_name                     = var.application_domain_name
}
