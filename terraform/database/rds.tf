resource "aws_rds_cluster" "database" {
  cluster_identifier                  = var.name
  engine                              = "aurora-mysql"
  engine_mode                         = "serverless"
  engine_version                      = var.engine_version
  database_name                       = local.name
  master_username                     = local.name
  master_password                     = random_password.password.result
  availability_zones                  = var.availability_zones
  vpc_security_group_ids              = [aws_security_group.database.id]
  db_subnet_group_name                = aws_db_subnet_group.database.name
  iam_database_authentication_enabled = true
  kms_key_id                          = aws_kms_key.database.arn
  skip_final_snapshot                 = true
  backup_retention_period             = 14
  enabled_cloudwatch_logs_exports     = ["error"]

  tags = local.tags

  lifecycle {
    # AKeyless will rotate our master password for us and we don't want terraform to reset it,
    # so we need to ignore changes to the master password
    ignore_changes = [master_password]
  }
}

resource "random_password" "password" {
  length = 16
}

resource "aws_db_subnet_group" "database" {
  name       = local.name
  subnet_ids = var.subnet_ids
  tags       = local.tags
}

resource "aws_kms_key" "database" {
  description         = "KMS for ${local.name}"
  tags                = local.tags
  enable_key_rotation = true
}
