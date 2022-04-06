resource "aws_lb" "application" {
  name                             = local.name
  internal                         = false
  enable_cross_zone_load_balancing = true
  idle_timeout                     = "60"
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.lb.id]
  subnets                          = var.lb_subnet_ids
  enable_deletion_protection       = false
  tags                             = local.tags

  access_logs {
    bucket  = (var.alb_access_logs_bucket_name != null && var.alb_access_logs_bucket_name != "") ? var.alb_access_logs_bucket_name : "no-op"
    prefix  = "${var.region}/${var.name}"
    enabled = (var.alb_access_logs_bucket_name != null && var.alb_access_logs_bucket_name != "") ? true : false
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.application.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = aws_acm_certificate_validation.cert_validation.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application.arn
  }

  tags = local.tags
}

resource "aws_lb_target_group" "application" {
  name        = local.name
  port        = 443
  protocol    = "HTTPS"
  vpc_id      = var.vpc_id
  target_type = "lambda"
  tags        = local.tags
}
