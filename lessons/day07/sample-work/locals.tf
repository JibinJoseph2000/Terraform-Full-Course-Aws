locals{
    bucket_name = "terraform-aws-demo-bucket-12345-${var.environment}"
    vpc_name    = "${var.environment}-vpc"
    instance_name = "${var.environment}-Instance"
}