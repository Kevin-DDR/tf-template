resource "aws_acm_certificate" "cert" {
  domain_name       = "${var.subdomain_name}.${var.domain_name}"
  validation_method = "DNS"

  provider = aws.virginia

  depends_on = []

  lifecycle {
    create_before_destroy = true
  }
}