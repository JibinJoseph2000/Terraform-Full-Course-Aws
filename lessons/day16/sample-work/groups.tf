resource "aws_identitystore_group" "engineers" {
  identity_store_id = local.identity_store_id
  display_name      = "Engineers"
}

resource "aws_identitystore_group" "education" {
  identity_store_id = local.identity_store_id
  display_name      = "Education"
}

resource "aws_identitystore_group" "managers" {
  identity_store_id = local.identity_store_id
  display_name      = "Managers"
}


 resource "aws_identitystore_group_membership" "engineers_membership" {
  for_each = {
    for user in local.users :
    lower("${substr(user.first_name,0,1)}${user.last_name}") => user
    if user.department == "Engineering"
  }

  identity_store_id = local.identity_store_id
  group_id          = aws_identitystore_group.engineers.group_id
  member_id         = aws_identitystore_user.users[each.key].user_id
}

resource "aws_identitystore_group_membership" "education_membership" {
   for_each = {
    for user in local.users :
    lower("${substr(user.first_name,0,1)}${user.last_name}") => user
    if user.department == "Education"
  }

  identity_store_id = local.identity_store_id
  group_id          = aws_identitystore_group.education.group_id
  member_id         = aws_identitystore_user.users[each.key].user_id
}

resource "aws_identitystore_group_membership" "managers_membership" {
 for_each = {
    for user in local.users :
    lower("${substr(user.first_name,0,1)}${user.last_name}") => user
    if can(regex("Manager|CEO", user.job_title))
  }

  identity_store_id = local.identity_store_id
  group_id          = aws_identitystore_group.managers.group_id
  member_id         = aws_identitystore_user.users[each.key].user_id
}

resource "aws_ssoadmin_permission_set" "engineers" {
  name         = "EngineersAccess"
  instance_arn = local.sso_instance_arn

  session_duration = "PT8H"
}

resource "aws_ssoadmin_permission_set" "education" {
  name         = "EducationAccess"
  instance_arn = local.sso_instance_arn

  session_duration = "PT8H"
}

resource "aws_ssoadmin_permission_set" "managers" {
  name         = "ManagersAccess"
  instance_arn = local.sso_instance_arn

  session_duration = "PT8H"
}

resource "aws_ssoadmin_managed_policy_attachment" "engineers_ec2" {
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.engineers.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_ssoadmin_managed_policy_attachment" "engineers_s3" {
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.engineers.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_ssoadmin_managed_policy_attachment" "education_readonly" {
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.education.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_ssoadmin_managed_policy_attachment" "managers_billing" {
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.managers.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/Billing"
}

resource "aws_ssoadmin_account_assignment" "engineers_assignment" {
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.engineers.arn

  principal_type = "GROUP"
  principal_id   = aws_identitystore_group.engineers.group_id

  target_type = "AWS_ACCOUNT"
  target_id   = var.aws_account_id
}

resource "aws_ssoadmin_account_assignment" "education_assignment" {
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.education.arn

  principal_type = "GROUP"
  principal_id   = aws_identitystore_group.education.group_id

  target_type = "AWS_ACCOUNT"
  target_id   = var.aws_account_id
}

resource "aws_ssoadmin_account_assignment" "managers_assignment" {
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.managers.arn

  principal_type = "GROUP"
  principal_id   = aws_identitystore_group.managers.group_id

  target_type = "AWS_ACCOUNT"
  target_id   = var.aws_account_id
}