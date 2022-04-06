data "aws_route53_zone" "application" {
  name = var.route_53_hosted_zone_name
}

resource "aws_route53_record" "application" {
  zone_id = data.aws_route53_zone.application.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.application.dns_name
    zone_id                = aws_lb.application.zone_id
    evaluate_target_health = true
  }
}
