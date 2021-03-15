data "aws_route53_zone" "rootzone" {
  name = var.route53_root_fqdn
}

resource "aws_route53_record" "bsc-archive" {
  name    = "bsc"
  type    = "A"
  zone_id = data.aws_route53_zone.rootzone.zone_id
  alias {
    evaluate_target_health = false
    name                   = data.aws_lb.public_alb.dns_name
    zone_id                = data.aws_lb.public_alb.zone_id
  }
}