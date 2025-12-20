resource "aws_identitystore_user" "users" {
  for_each = {
    for user in local.users :
    lower("${substr(user.first_name,0,1)}${user.last_name}") => user
  }

  identity_store_id = local.identity_store_id
  user_name         = each.key

  name {
    given_name  = each.value.first_name
    family_name = each.value.last_name
  }

  display_name = "${each.value.first_name} ${each.value.last_name}"

  emails {
    value   = each.value.email
    primary = true
  }
}

