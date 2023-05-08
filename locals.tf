locals {

  firewall_rule_files = flatten(
    [
      for config_path in var.config_directories :
      concat(
        [
          for config_file in fileset("${path.root}/${config_path}", "**/*.yaml") :
          "${path.root}/${config_path}/${config_file}"
        ]
      )

    ]
  )

  firewall_rules = merge(
    [
      for config_file in local.firewall_rule_files :
      try(yamldecode(file(config_file)), {})
    ]...
  )

  module_name    = "terraform-google-vpc-firewall-rules"
  module_version = "v0.0.1"
  
}