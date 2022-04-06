resource "aws_security_group" "lambda" {
  name        = local.name
  description = "Security group for the application lambda, ${local.name}"
  vpc_id      = var.vpc_id
  tags        = local.tags
}

resource "aws_security_group_rule" "allow_incoming_application_lambda" {
  security_group_id        = var.database_security_group_id
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lambda.id
}

resource "aws_security_group_rule" "allow_outgoing_lambda" {
  security_group_id = aws_security_group.lambda.id
  type              = "egress"
  from_port         = "1"
  to_port           = "65535"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "lb" {
  name        = "${local.name}-lb"
  description = "Security group for the ${local.name} ALB"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "lb_allow_all_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "lb_allow_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
}
