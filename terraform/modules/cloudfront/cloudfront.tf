resource "aws_cloudfront_distribution" "this" {
  price_class         = "PriceClass_All"
  http_version        = "http2and3"
  enabled             = true
  is_ipv6_enabled     = true
  aliases             = var.domains
  comment             = var.application_name

  origin {
    domain_name              = var.origin_domain
    origin_id                = var.origin_domain
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.origin_domain
    compress         = false

    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      cookies {
        forward = "all"
      }
      headers = ["*"]
      query_string = true
    }

    lambda_function_association {
      event_type   = "viewer-request"
      lambda_arn   = var.lambda_arn
      include_body = true
    }

  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = var.tags

  viewer_certificate {
    minimum_protocol_version = "TLSv1.2_2021"
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
  }
}
