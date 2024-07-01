resource "ovh_domain_zone_record" "dns" {
  depends_on = [aws_cloudfront_distribution.distrib]
  zone       = var.domain_name
  subdomain  = var.subdomain_name
  fieldtype  = "CNAME"
  target     = "${aws_cloudfront_distribution.distrib.domain_name}."
  ttl        = 60
}

resource "ovh_domain_zone_record" "cert-cname" {

  depends_on = [aws_acm_certificate.cert]
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  subdomain = "${split(".", each.value.name)[0]}.${split(".", each.value.name)[1]}"
  target    = each.value.record
  ttl       = 60
  fieldtype = each.value.type
  zone      = var.domain_name
}

# Need for avoid `Error putting S3 policy: AccessDenied: Access Denied`
resource "time_sleep" "wait_30_seconds" {
  depends_on      = [ovh_domain_zone_record.cert-cname]
  create_duration = "30s"
}

output "DNSTYPE" {
  value = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
}


resource "aws_acm_certificate_validation" "validation" {
  provider                = aws.virginia
  depends_on              = [time_sleep.wait_30_seconds]
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in ovh_domain_zone_record.cert-cname : "${record.subdomain}.${record.zone}"]
}

# resource "ovh_domain_zone_redirection" "dns" {
#   depends_on = [aws_cloudfront_distribution.distrib]
#   zone      = "${var.domain_name}"
#   subdomain = "${var.subdomain_name}"
#   type      = "invisible"
#   target    = aws_cloudfront_distribution.distrib.domain_name
# }

# output "VMCount" {
#   value = nonsensitive("ENV!!!!! ; ${local.envs["APPLICATION_KEY"]}")
# }

# output "VMCount" {
#   value = aws_cloudfront_distribution.distrib.domain_name
# }