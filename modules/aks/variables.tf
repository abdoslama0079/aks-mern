variable "location" {
  type    = string
  default = "australiaeast"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
  default     = "aksmern"
}

variable "client_id" {
  type    = string
  default = "0000"
}

variable "client_secret" {
  type      = string
  sensitive = true
}

variable "azurerm_container_registry" {
  type        = string
  description = "The ID of the ACR"
  default     = "azrmregistry"
}

# This isn't used in your current main.tf because we switched to tls_private_key
# but keeping it doesn't hurt.
variable "ssh_public_key" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "service_principal_name" {
  type    = string
  default = "jenkinsservice"
}
