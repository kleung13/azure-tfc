variable "resource_group_name" {
  default = "default-resource-group"
}

variable "location" {
  default = "centralus"
}

variable "region" {
  type        = string
  description = "(optional) Default Azure region to deploy to."
  default     = "centralus"
}

variable "VAULT_TOKEN" {
  type        = string
  description = "Vault token for pipeline"
  default     = ""
}