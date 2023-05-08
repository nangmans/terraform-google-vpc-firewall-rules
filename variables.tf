variable "config_directories" {
  description = "List of paths to folders where firewall configs are stored in yaml format. Folder may include subfolders with configuration files. Files suffix must be `.yaml`."
  type        = list(string)
}

variable "log_config" {
  description = "Log configuration. Possible values for `metadata` are `EXCLUDE_ALL_METADATA` and `INCLUDE_ALL_METADATA`. Set to `null` for disabling firewall logging."
  type = object({
    metadata = string
  })
  default = null
}

variable "network_name" {
  description = "Name of the network this set of firewall rules applies to."
  type        = string
}

variable "project_id" {
  description = "Project Id."
  type        = string
}

variable "impersonate_sa" {
  description = "Email of the service account to use for Terraform"
  type        = string
}

variable "validate_labels" {
  description = "validate labels"
  type        = map(string)
}

