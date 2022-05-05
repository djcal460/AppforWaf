# Route53 data source for an existing hosted zone id
data "aws_route53_zone" "des" {
  name  = var.hosted_zone_name
}

# create an Alias in Route53

data "aws_lb" "alb" {
  name = var.alb_name
}

resource "aws_route53_record" "router_record_set" {
  zone_id = data.aws_route53_zone.des.zone_id
  name    = var.rt53_alias
  type    = "A"
  alias {
    evaluate_target_health = true
    name                   = data.aws_lb.alb.dns_name
    zone_id                = data.aws_lb.alb.zone_id
  }
  latency_routing_policy {
    region = var.region
  }

  set_identifier = "${var.rt53_alias}-${var.region}"
}