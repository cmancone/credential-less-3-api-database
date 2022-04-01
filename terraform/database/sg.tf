resource "aws_security_group" "database" {
  name        = local.name
  description = "Security group for the database ${local.name}"
  vpc_id      = var.vpc_id
  tags        = local.tags
}

resource "aws_security_group_rule" "allow_incoming" {
  count = length(var.incoming_security_group_ids)

  security_group_id        = aws_security_group.database.id
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  source_security_group_id = var.incoming_security_group_ids[count.index]
}

resource "aws_security_group_rule" "allow_incoming_bastion" {
  security_group_id        = aws_security_group.database.id
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group" "bastion" {
  name        = local.bastion_name
  description = "Security group for the bastion host for ${local.name}"
  vpc_id      = var.vpc_id
  tags        = local.bastion_tags
}

resource "aws_security_group_rule" "allow_outgoing_bastion" {
  security_group_id = aws_security_group.bastion.id
  type              = "egress"
  from_port         = "1"
  to_port           = "65535"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
