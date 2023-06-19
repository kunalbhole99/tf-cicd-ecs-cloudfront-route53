resource "aws_acm_certificate" "cert" {
  provider                  = aws.north_virginia
  domain_name               = "*.${var.domain_name_simple}"
  validation_method         = "DNS"
  subject_alternative_names = [var.domain_name_simple]

  lifecycle {
    create_before_destroy = true
  }
}


##################### AWS ACM Certificate validation ##################

resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.north_virginia
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}