terraform {
    backend "s3" {
        bucket = "demo-terraform-state-bucket-12345"
        key    = "dev/terraform.tfstate"
        region = "us-east-1"
        encrypt = true
        use_lockfile = false
    }
}