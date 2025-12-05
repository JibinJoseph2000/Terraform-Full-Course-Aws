# pre condition to validate region before creating the bucket

resource "aws_s3_bucket" "regional_validation" {
  bucket = "validated-region-bucket"

  lifecycle {
    precondition {
      condition     = contains(var.allowed_regions, "us-east-1")
      error_message = "ERROR: Can only deploy in allowed regions: ${join(", ", var.allowed_regions)}"
    }
  }
}

# post condition to ensure 'Project' tag is present

resource "aws_s3_bucket" "compliance_bucket" {
  bucket = "compliance-bucket"

  tags = var.tags
  lifecycle {
    postcondition {
      condition     = contains(keys(self.tags), "project")
      error_message = "ERROR: Bucket must have an 'Test' tag!"
    }
  }
}