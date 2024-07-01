locals {
  s3_origin_id   = "${var.S3_NAME}-origin"
  s3_domain_name = "${var.S3_NAME}.s3-website-${var.region}.amazonaws.com"
}

resource "aws_cloudfront_distribution" "distrib" {
  depends_on = [aws_acm_certificate_validation.validation]


  enabled         = true
  is_ipv6_enabled = true

  aliases = ["${var.subdomain_name}.${var.domain_name}"]

  origin {
    # origin_id   = local.s3_origin_id
    ## domain_name = aws_s3_bucket_website_configuration.bucket.bucket_regional_domain_name
    # domain_name = "${aws_s3_bucket.bucket.id}.s3-website.${aws_s3_bucket.bucket.region}.amazonaws.com"
    domain_name = aws_s3_bucket_website_configuration.bucket.website_endpoint
    origin_id   = aws_s3_bucket_website_configuration.bucket.website_endpoint


    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }


  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket_website_configuration.bucket.website_endpoint

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    ssl_support_method  = "sni-only"
  }

  price_class = "PriceClass_100"

}