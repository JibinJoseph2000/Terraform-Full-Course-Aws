terraform {
  backend "s3" {
    bucket       = "demo-terraform-state-bucket-12345" # Replace with your S3 bucket name
    key          = "terraform/state/main/terraform.tfstate"
    region       = "us-east-1" # Replace with your region
    use_lockfile = true        # S3 Native Locking (No DynamoDB needed)
    encrypt      = true
  }
}
