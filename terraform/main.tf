terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    akeyless = {
      version = ">= 1.0.0"
      source  = "akeyless-community/akeyless"
    }
  }
  backend "s3" {
    bucket = "always-upgrade-terraform-state"
    key    = "products-service.json"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region
}

provider "akeyless" {
  alias               = "global-cloud"
  api_gateway_address = "https://api.akeyless.io"

  aws_iam_login {
    access_id = "p-x93k1uragthy"
  }
}

provider "akeyless" {
  alias               = "gateway"
  api_gateway_address = "https://us.gateway.akeyless.always-upgrade.us"

  aws_iam_login {
    access_id = "p-x93k1uragthy"
  }
}

module "database" {
  source = "./database"
  providers = {
    akeyless-global-cloud = akeyless.global-cloud
    akeyless-gateway      = akeyless.gateway
  }

  name                        = var.name
  region                      = var.region
  vpc_id                      = var.vpc_id
  availability_zones          = var.database_availability_zones
  subnet_ids                  = var.database_subnet_ids
  database_security_group_id  = aws_security_group.database.id
  zip_filename                = var.zip_filename
  bastion_subnet_id           = var.database_bastion_subnet_id
  engine_version              = var.database_engine_version
  incoming_security_group_ids = var.database_incoming_security_group_ids
  akeyless_access_id          = var.akeyless_access_id
  akeyless_ca_public_key      = var.akeyless_ca_public_key
  akeyless_api_host           = var.akeyless_api_host
  akeyless_folder             = var.akeyless_folder
}

module "application" {
  source = "./application"

  name                            = var.name
  region                          = var.region
  vpc_id                          = var.vpc_id
  subnet_ids                      = var.database_subnet_ids
  database_security_group_id      = aws_security_group.database.id
  zip_filename                    = var.zip_filename
  akeyless_access_id              = var.akeyless_access_id
  akeyless_api_host               = var.akeyless_api_host
  akeyless_database_producer_path = "${var.akeyless_folder}/application"
  database_name                   = module.database.database_name
  database_host                   = module.database.database_host
  lb_subnet_ids                   = var.application_lb_subnet_ids
  route_53_hosted_zone_name       = var.application_route_53_hosted_zone_name
  domain_name                     = var.application_domain_name
}
