
# Create a Route 53 hosted zone

resource "aws_route53_zone" "zone" {
    name       = var.domain_name

    tags       = {
        Name   = "${var.project_name}_route53_zone"
    }
}

##################################################################

# Create a Route 53 record set

resource "aws_route53_record" "record" {
    zone_id                  = aws_route53_zone.zone.zone_id
    name                     = var.subdomain_name
    type                     = "A"

    alias {
        name                   = var.application_load_balancer_dns_name
        zone_id                = var.application_load_balancer_zone_id
        evaluate_target_health = true
    }
}