terraform {
  required_providers {
    akeyless = {
      version = ">= 1.0.0"
      source  = "akeyless-community/akeyless"
    }
  }
}

provider "akeyless" {
  alias = "global-cloud"

  aws_iam_login {
    access_id = var.akeyless_terraform_access_id
  }
}

provider "akeyless" {
  alias               = "gateway"
  api_gateway_address = "https://${var.akeyless_gateway_domain_name}:8081"

  aws_iam_login {
    access_id = var.akeyless_terraform_access_id
  }
}

# Put the database master password/host in a target
resource "akeyless_target_db" "root" {
  provider  = akeyless.global-cloud
  db_type   = "mysql"
  name      = "${var.akeyless_folder}/root"
  db_name   = aws_rds_cluster.database.database_name
  host      = aws_rds_cluster.database.endpoint
  user_name = "root"
  pwd       = random_password.password.result
  port      = "3306"

  lifecycle {
    # AKeyless will rotate our master password for us and we don't want terraform to reset it,
    # so we need to ignore changes to the master password
    ignore_changes = [pwd]
  }

  depends_on = [aws_rds_cluster.database]
}

# Create a rotator for the database master password target.  Note that, as part of its creation,
# this will automatically rotate the master password
resource "akeyless_rotated_secret" "db_master_rotator" {
  provider = akeyless.gateway

  name = "${var.akeyless_folder}/${var.name}-db-rotator"
  rotator_type = "target"
  target_name = trimprefix(akeyless_target_db.root.name, "/")
  rotation_interval = "1"
  authentication_credentials = "use-target-creds"

  # Some of our AKeyless resources are hard for terraform to update because
  # credentials are no longer managed by terraform after the initial creation.
  # Therefore, we don't want to update them in the future.
  lifecycle {
    ignore_changes = all
  }
}

# create a database producer that will be consumed by our application (therefore, simple CRUD permissions)
resource "akeyless_producer_mysql" "application" {
  provider = akeyless.gateway
  name = "${var.akeyless_folder}/application"
  mysql_host = aws_rds_cluster.database.endpoint
  mysql_dbname = aws_rds_cluster.database.database_name
  mysql_screation_statements = "CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}' PASSWORD EXPIRE INTERVAL 1 DAY;GRANT DELETE,INSERT,SELECT,UPDATE ON ${aws_rds_cluster.database.database_name}.* TO '{{name}}'@'%';"
  mysql_port = "3306"
  target_name = trimprefix(akeyless_target_db.root.name, "/")
}

# create a database producer that will be consumed by our migration (therefore, full database access)
resource "akeyless_producer_mysql" "migration" {
  provider = akeyless.gateway
  name = "${var.akeyless_folder}/migration"
  mysql_host = aws_rds_cluster.database.endpoint
  mysql_dbname = aws_rds_cluster.database.database_name
  mysql_screation_statements = "CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}' PASSWORD EXPIRE INTERVAL 1 DAY;GRANT all ON ${aws_rds_cluster.database.database_name}.* TO '{{name}}'@'%';"
  mysql_port = "3306"
  target_name = trimprefix(akeyless_target_db.root.name, "/")
}

# We need a key that will be used by our SSH certificate issuer
resource "akeyless_dfc_key" "bastion" {
  provider = akeyless.global-cloud

  alg = "RSA4096"
  name = "${var.akeyless_folder}/ssh-cert-key"
}

# and then our SSH certificate issuer
resource "akeyless_ssh_cert_issuer" "bastion" {
  provider = akeyless.global-cloud

  allowed_users = "ubuntu,ec2-user"
  name = "${var.akeyless_folder}/ssh-cert-issuer"
  signer_key_name = trimprefix(akeyless_dfc_key.bastion.name, "/")
  ttl = 3600
}

# We can get the public key from here
data "akeyless_rsa_pub" "bastion" {
  provider = akeyless.global-cloud

  name = trimprefix(akeyless_dfc_key.bastion.name, "/")
}

# finally we want to setup authentication/authorization for the migration lambda.
resource "akeyless_auth_method_aws_iam" "migration" {
  provider = akeyless.global-cloud

  bound_aws_account_id = [data.aws_caller_identity.current.account_id]
  name = "${var.akeyless_folder}/${local.migration_lambda_name}"
  bound_role_name = [local.migration_lambda_name]
}

# and then a role with permissions
resource "akeyless_role" "migration" {
  provider = akeyless.global-cloud

  name = "${var.akeyless_folder}/${local.migration_lambda_name}"

  assoc_auth_method {
    am_name = trimprefix(akeyless_auth_method_aws_iam.migration.name, "/")
  }

  rules {
    capability = ["read"]
    path = akeyless_producer_mysql.migration.name
    rule_type = "item-rule"
  }
}
