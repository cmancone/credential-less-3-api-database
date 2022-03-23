locals {
  name = "${var.name}-db"
  tags = merge(var.tags, {
    Name = "${var.name}-db"
  })

  bastion_name = "${var.name}-db-bastion"
  bastion_tags = merge(var.tags, {
    Name = "{$var.name}-db-bastion"
  })

  migration_lambda_name = "${var.name}-db-migration"
  migration_lambda_tags = merge(var.tags, {
    Name = "{$var.name}-db-migration"
  })
}
