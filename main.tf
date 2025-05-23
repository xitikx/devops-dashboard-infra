provider "aws" {
  region = var.aws_region
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "dashboard_bucket" {
  bucket = "${var.s3_bucket_prefix}-${var.environment}-${random_string.bucket_suffix.result}"
  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket_policy" "dashboard_bucket_policy" {
  bucket = aws_s3_bucket.dashboard_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.dashboard_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_cloudfront_distribution" "dashboard_distribution" {
  origin {
    domain_name = aws_s3_bucket.dashboard_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.dashboard_bucket.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.dashboard_bucket.id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl               = var.cloudfront_ttl[var.environment]
    default_ttl           = var.cloudfront_ttl[var.environment]
    max_ttl               = var.cloudfront_ttl[var.environment]
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Environment = var.environment
  }
}