data "aws_route53_zone" "rootzone" {
  name = var.route53_root_fqdn
  tags = var.tags
}

resource "aws_route53_record" "bsc-archive" {
  name    = var.app_name
  type    = "A"
  zone_id = data.aws_route53_zone.rootzone.zone_id
  alias {
    evaluate_target_health = false
    name                   = data.aws_lb.public_alb.dns_name
    zone_id                = data.aws_lb.public_alb.zone_id
  }
}

data "aws_instance" "geth" {
  instance_id = local.instance_id
}
resource "aws_route53_record" "bsc-metric" {
  zone_id = data.aws_route53_zone.rootzone.zone_id
  name = "${var.app_name}-prom"
  type = "CNAME"
  records = [data.aws_instance.geth.private_dns]
  ttl = 30
}