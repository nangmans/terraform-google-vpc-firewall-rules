resource "time_static" "timestamp" {
  for_each = local.firewall_rules
  triggers = {
    name = md5(jsonencode(each.value))
  }
}

resource "google_compute_firewall" "rules" {
  for_each = local.firewall_rules
  project  = var.project_id
  name = each.key
  description = format(
    "%s rule in network %s for %s created at %s managed by terraform",
    each.value.direction,
    var.network_name,
    each.key,
    time_static.timestamp[each.key].rfc3339
  )

  network   = var.network_name
  direction = each.value.direction
  priority  = try(each.value.priority, 1000)
  disabled  = try(each.value.disabled, null)

  source_ranges           = try(each.value.source_ranges, each.value.direction == "INGRESS" ? [] : null)
  source_tags             = try(each.value.source_tags, null)
  source_service_accounts = try(each.value.source_service_accounts, null)

  destination_ranges      = try(each.value.destination_ranges, each.value.direction == "EGRESS" ? [] : null)
  target_tags             = try(each.value.target_tags, null)
  target_service_accounts = try(each.value.target_service_accounts, null)

  dynamic "allow" {
    for_each = { for block in try(each.value.allow, []) :
      "${block.protocol}-${join("-", block.ports)}" => {
        ports    = [for port in block.ports : tostring(port)]
        protocol = block.protocol
      }
    }
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  dynamic "deny" {
    for_each = { for block in try(each.value.deny, []) :
      "${block.protocol}-${join("-", block.ports)}" => {
        ports    = [for port in block.ports : tostring(port)]
        protocol = block.protocol
      }
    }
    content {
      protocol = deny.value.protocol
      ports    = deny.value.ports
    }
  }

  dynamic "log_config" {
    for_each = var.log_config != null ? [""] : []
    content {
      metadata = var.log_config.metadata
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}