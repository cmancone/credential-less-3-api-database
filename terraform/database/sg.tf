resource "aws_security_group_rule" "allow_incoming_bastion" {
  security_group_id        = var.database_security_group_id
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "allow_additional_db_access" {
  for_each                 = { for index, security_group_id in var.incoming_security_group_ids : index => security_group_id }

  security_group_id        = var.database_security_group_id
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  source_security_group_id = each.value
}

resource "aws_security_group_rule" "allow_incoming_lambda" {
  security_group_id        = var.database_security_group_id
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lambda.id
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

resource "aws_security_group" "lambda" {
  name        = "${local.name}-lambda"
  description = "Security group for the lambdas for ${local.name}"
  vpc_id      = var.vpc_id
  tags        = local.tags
}

resource "aws_security_group_rule" "allow_outgoing_lambda" {
  security_group_id = aws_security_group.lambda.id
  type              = "egress"
  from_port         = "1"
  to_port           = "65535"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
