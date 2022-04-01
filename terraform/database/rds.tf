resource "aws_rds_cluster" "database" {
  cluster_identifier      = var.name
  engine                  = "aurora-mysql"
  engine_mode             = "provisioned"
  engine_version          = var.engine_version
  storage_encrypted       = true
  database_name           = local.database_name
  master_username         = "root"
  master_password         = random_password.password.result
  availability_zones      = var.availability_zones
  vpc_security_group_ids  = [aws_security_group.database.id]
  db_subnet_group_name    = aws_db_subnet_group.database.name
  kms_key_id              = aws_kms_key.database.arn
  skip_final_snapshot     = true
  backup_retention_period = 14

  tags = local.tags

  lifecycle {
    # AKeyless will rotate our master password for us and we don't want terraform to reset it,
    # so we need to ignore changes to the master password
    ignore_changes = [master_password]
  }
}

resource "aws_rds_cluster_instance" "database" {
  instance_class     = var.instance_class
  count              = var.instance_count
  identifier_prefix  = var.name
  cluster_identifier = aws_rds_cluster.database.id
  engine             = aws_rds_cluster.database.engine
  engine_version     = aws_rds_cluster.database.engine_version
}

resource "random_password" "password" {
  length           = 16
  override_special = "!#$%&*()-_=+[]{}<>:?"
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
