resource "aws_s3_bucket" "bucket" {
  bucket = var.S3_NAME

  force_destroy = true
}

resource "aws_s3_bucket_cors_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "GET", "DELETE", "PUT", "HEAD"]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }

  depends_on = [aws_s3_bucket_public_access_block.bucket]
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Need for avoid `Error putting S3 policy: AccessDenied: Access Denied`
resource "time_sleep" "wait_2_seconds" {
  depends_on      = [aws_s3_bucket_website_configuration.bucket]
  create_duration = "2s"
}


resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket     = aws_s3_bucket.bucket.id
  depends_on = [time_sleep.wait_2_seconds]

  policy = <<POLICY
{
  "Id": "Policy",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.bucket.bucket}/*",
      "Principal": "*"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_acl" "bucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.bucket,
    aws_s3_bucket_public_access_block.bucket,
  ]

  bucket = aws_s3_bucket.bucket.id
  acl    = "public-read"
}


resource "aws_s3_bucket_website_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }

}

# resource "aws_s3_object" "dist" {
#   depends_on = [aws_cloudfront_distribution.distrib]
#   bucket     = aws_s3_bucket.bucket.id

#   for_each = fileset("../dist/", "**/*")

#   key          = each.value
#   source       = "../dist/${each.value}"
#   content_type = "text/html"
#   # etag makes the file update when it changes; see https://stackoverflow.com/questions/56107258/terraform-upload-file-to-s3-on-every-apply
#   etag                = filemd5("../dist/${each.value}")
#   content_disposition = "inline"
# }