# VPC outputs:

output "vpc-id" {
  value = module.vpc.default_vpc_id
}

output "app-alb-url" {
  value = aws_alb.app_lb.dns_name
}





################## Cloudfront Outouts ###################

output "cloudfront_url" {
  value = aws_cloudfront_distribution.cdn_static_site.domain_name
}

################### Route53 Nameservers Records #####################

output "ns-records" {
  value = aws_route53_zone.zone.name_servers
}

output "A-record" {
  value = aws_route53_record.www.fqdn
}