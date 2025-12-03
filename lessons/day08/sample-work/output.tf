output "demo_bucket_names" {
  value = [for b in aws_s3_bucket.demo_bucket : b.bucket]
}

output "demo_bucket_ids" {
  value = [for b in aws_s3_bucket.demo_bucket : b.id]
}

output "demo_bucket_set_names" {
  value = { for k, b in aws_s3_bucket.demo_bucket_set : k => b.bucket }
}

output "demo_bucket_set_ids" {
  value = { for k, b in aws_s3_bucket.demo_bucket_set : k => b.id }
}


