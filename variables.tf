variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "s3_bucket_prefix" {
  description = "Prefix for S3 bucket name"
  type        = string
  default     = "dashboard-krish"
}

variable "cloudfront_ttl" {
  description = "CloudFront TTL settings"
  type        = map(number)
  default = {
    dev     = 0
    staging = 300
    prod    = 86400
  }
}