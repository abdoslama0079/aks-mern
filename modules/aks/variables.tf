variable "location" {}

variable "rg" {
description = "The name of the resource group"
  type        = string
} # This MUST exist here

variable "client_id" {
description = "client id"
  type        = string
}

variable "client_secret" {}

variable "azurerm_container_registry" {}

variable "service_principal_name" {}
