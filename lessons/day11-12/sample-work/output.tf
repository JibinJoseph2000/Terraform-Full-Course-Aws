output "formatted_project_name" {
  value = local.formatted_project_name
}

output "port_list" {
  value = local.port_list
}

output "sg_rules" {
  value = local.sg_rules
}

output "instance_sizes"{
  value = local.instance_sizes
}

output "credentials_info" {
  value = var.credential
  sensitive = true
}

output "all_locations"{
  value = local.all_locations
}

output "unique_locations"{
  value = local.unique_locations
}

output "positive_cost"{
  value = local.positive_cost
}

output "max_cost"{
  value = local.max_cost
}

output "min_cost"{
  value = local.min_cost
}

output "sum_cost"{
  value = local.sum_cost
}

output "avg_cost" {
  value = local.avg_cost
}

output "config_data" {
  value = local.config_data
}