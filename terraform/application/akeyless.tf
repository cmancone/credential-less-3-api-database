terraform {
  required_providers {
    akeyless = {
      version = ">= 1.0.0"
      source  = "akeyless-community/akeyless"
    }
  }
}

provider "akeyless" {
  aws_iam_login {
    access_id = var.akeyless_terraform_access_id
  }
}

# We want to setup authentication/authorization for the application lambda.
resource "akeyless_auth_method_aws_iam" "application" {
  bound_aws_account_id = [data.aws_caller_identity.current.account_id]
  name = "${var.akeyless_folder}/${local.name}"
  bound_role_name = [local.name]
}

# and then a role with permissions
resource "akeyless_role" "application" {
  name = "${var.akeyless_folder}/${local.name}"

  assoc_auth_method {
    am_name = trimprefix(akeyless_auth_method_aws_iam.application.name, "/")
  }

  rules {
    capability = ["read"]
    path = var.akeyless_database_producer_path
    rule_type = "item-rule"
  }
}
