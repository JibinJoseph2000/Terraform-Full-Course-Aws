locals {
  users = csvdecode(file("users.csv"))
}

# locals {
#   sso_instance_arn = data.aws_ssoadmin_instances.this.arns[0]
#   identity_store_id = data.aws_ssoadmin_instances.this.identity_store_ids[0]
# }

locals {
  sso_instance_arn = "arn:aws:sso:::instance/ssoins-1234567890abcdef"
  identity_store_id = "d-1234567890"
}