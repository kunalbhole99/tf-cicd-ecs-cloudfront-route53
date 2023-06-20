################ Route53 zone creation ###############

resource "aws_route53_zone" "zone" {
  name = var.domain_name_simple
    tags = {
    Environment = "dev"
  }
}


/*
resource "aws_route53_record" "cert_validation" {
  provider = aws.north_virginia
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  zone_id         = aws_route53_zone.zone.zone_id
  ttl             = 60
}

*/

resource "aws_route53_record" "validation_record_1" {
  zone_id = aws_route53_zone.example_zone.zone_id
  name    = "*.wearecloudengineer.monster"  # Replace with the actual validation domain name provided by ACM
  type    = "CNAME"
  ttl     = 300
  records = [aws_acm_certificate.cert.domain_validation_options[0].resource_record_name]
}

resource "aws_route53_record" "validation_record_2" {
  zone_id = aws_route53_zone.example_zone.zone_id
  name    = "wearecloudengineer.monster"  # Replace with the actual validation domain name provided by ACM
  type    = "CNAME"
  ttl     = 300
  records = [aws_acm_certificate.cert.domain_validation_options[1].resource_record_name]
}

################# AWS Route53 'A' Record creation for cloudfront distribution ##################

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.zone.id
  name    = "www.${var.domain_name_simple}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn_static_site.domain_name
    zone_id                = aws_cloudfront_distribution.cdn_static_site.hosted_zone_id
    evaluate_target_health = false
  }
}


resource "aws_route53_record" "apex" {
  zone_id = aws_route53_zone.zone.id
  name    = var.domain_name_simple
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn_static_site.domain_name
    zone_id                = aws_cloudfront_distribution.cdn_static_site.hosted_zone_id
    evaluate_target_health = false
  }
}