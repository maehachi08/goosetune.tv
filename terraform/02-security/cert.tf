# Data source for existing Route53 hosted zone
data "aws_route53_zone" "goosetune_tv" {
  name         = "goosetune.tv"
  private_zone = false
}

# AWS Certificate Manager certificate with DNS validation
resource "aws_acm_certificate" "goosetune_tv" {
  domain_name               = "goosetune.tv"
  subject_alternative_names = ["*.goosetune.tv"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "goosetune-tv-acm"
  }
}

# Route53 records for certificate validation
resource "aws_route53_record" "goosetune_tv_validation" {
  for_each = {
    for dvo in aws_acm_certificate.goosetune_tv.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.goosetune_tv.zone_id
}

# Certificate validation
resource "aws_acm_certificate_validation" "goosetune_tv" {
  certificate_arn         = aws_acm_certificate.goosetune_tv.arn
  validation_record_fqdns = [for record in aws_route53_record.goosetune_tv_validation : record.fqdn]

  timeouts {
    create = "5m"
  }
}
