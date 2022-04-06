# we have to create the security group for the database "out here", because it needs to
# be used in both the database module and the application module
locals {
  database_cluster_name = "${var.name}-db"
}

resource "aws_security_group" "database" {
  name        = local.database_cluster_name
  description = "Security group for the database ${local.database_cluster_name}"
  vpc_id      = var.vpc_id
  tags = merge(var.tags, {
    Name = "${var.name}-db"
  })
}

resource "aws_security_group_rule" "allow_incoming" {
  count = length(var.database_incoming_security_group_ids)

  security_group_id        = aws_security_group.database.id
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  source_security_group_id = var.database_incoming_security_group_ids[count.index]
}
