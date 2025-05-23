output "s3_bucket_name" {
  value = aws_s3_bucket.dashboard_bucket.bucket
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.dashboard_distribution.domain_name
}