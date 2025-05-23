terraform {
  backend "s3" {
    bucket         = "my-tf-state-krish123" # Replace with your S3 bucket name
    key            = "terraform/state"
    region         = "us-east-1"
    dynamodb_table = "tf-state-lock-krish"      # Replace with your DynamoDB table name
  }
}