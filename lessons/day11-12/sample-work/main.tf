locals {
  formatted_project_name = lower(replace(var.project-name," ","-"))
  formatted_bucket_name = replace(replace(substr(lower(var.bucket-name),0,63)," ","-"),"!","")

  port_list = split(",",var.allowed_ports)
  sg_rules = [for port in local.port_list :{
    name = "port-${port}"
    port = port
    description = "Allow port on traffic ${port}"
  }]

  ports_sentence = "Allowed ports are: ${join(", ", local.port_list)}"

  instance_sizes = lookup(var.instance_sizes,var.environment,"t2.nano")

  all_locations = concat(var.user_locations,var.default_locations)
  unique_locations = toset(local.all_locations)

  positive_cost = [for cost in var.monthly_costs : abs(cost)]
  max_cost = max(local.positive_cost...)
  min_cost = min(local.positive_cost...)
  sum_cost = sum(local.positive_cost)
  avg_cost = local.sum_cost / length(local.positive_cost)

  current_time = timestamp()
  format1 = formatdate("yyyyMMdd", local.current_time)
  format2 = formatdate("YYYY-MM-DD", local.current_time)
  timestampname = "backup-${local.format1}.tar.gz"

  # config_file_exists = fileexists("./config.json")
  config_file_exists = fileexists("${dirname(path.module)}/config.json")

  
  config_data = local.config_file_exists ? jsondecode(file("./config.json")) : {}
}


resource "aws_s3_bucket" "my-demo-bucket"{
  bucket = local.formatted_bucket_name
  tags   = merge(var.default_tags, var.environment_tags)
}