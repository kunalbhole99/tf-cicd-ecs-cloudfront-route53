########### Cloudfront Distribution #####################


resource "aws_cloudfront_distribution" "cdn_static_site" {
  enabled             = true
  is_ipv6_enabled     = true
  #default_root_object = "index.html"
  comment             = "my cloudfront in front of the alb"

  origin {
    domain_name              = aws_alb.app_lb.dns_name
    origin_id                = "my-alb-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
  }

  default_cache_behavior {
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "my-alb-origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  aliases = ["www.wearecloudengineer.monster", "wearecloudengineer.monster"]

}


###################### aws_cloudfront_origin_access_control ###################

resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "cloudfront OAC"
  description                       = "description of OAC"
  origin_access_control_origin_type = "mediastore"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}