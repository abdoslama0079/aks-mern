variable "location" {}

variable "resource_group_name" {
description = "The name of the resource group"
  type        = string
  default = "abdo"

} # This MUST exist here

variable "client_id" {}

variable "client_secret" {}

variable "azurerm_container_registry" {}

variable "service_principal_name" {}
