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
  api_gateway_address = "https://api.akeyless.io"

  api_key_login {
    access_id  = "p-een80gwlzam6"
    access_key = "DCHFoz/XYgvtLCm9QUESdm4TvbRSB3CmagdFsVeBuZE="
  }
}

module "database" {
  source = "./database"

  name                        = var.name
  region                      = var.region
  vpc_id                      = var.vpc_id
  availability_zones          = var.database_availability_zones
  subnet_ids                  = var.database_subnet_ids
  zip_filename                = var.zip_filename
  bastion_subnet_id           = var.database_bastion_subnet_id
  engine_version              = var.database_engine_version
  incoming_security_group_ids = var.database_incoming_security_group_ids
  akeyless_access_id          = var.akeyless_access_id
  akeyless_ca_public_key      = var.akeyless_ca_public_key
  akeyless_api_host           = var.akeyless_api_host
  akeyless_folder             = var.akeyless_folder
}
