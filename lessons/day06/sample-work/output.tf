output "details" {
  value = {
    bucket_id = aws_s3_bucket.demo-bucket.id
    bucket_arn = aws_s3_bucket.demo-bucket.arn
    vpc_id = aws_vpc.sample.id
    instance_id = aws_instance.name.id
  }
}