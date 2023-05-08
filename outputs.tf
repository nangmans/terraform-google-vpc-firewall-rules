output "egress_allow_rules" {
  description = "Egress rules with allow blocks."
  value = [
    for rule in google_compute_firewall.rules :
    rule if rule.direction == "EGRESS" && length(rule.allow) > 0
  ]
}

output "egress_deny_rules" {
  description = "Egress rules with allow blocks."
  value = [
    for rule in google_compute_firewall.rules :
    rule if rule.direction == "EGRESS" && length(rule.deny) > 0
  ]
}

output "ingress_allow_rules" {
  description = "Ingress rules with allow blocks."
  value = [
    for rule in google_compute_firewall.rules :
    rule if rule.direction == "INGRESS" && length(rule.allow) > 0
  ]
}

output "ingress_deny_rules" {
  description = "Ingress rules with deny blocks."
  value = [
    for rule in google_compute_firewall.rules :
    rule if rule.direction == "INGRESS" && length(rule.deny) > 0
  ]
}