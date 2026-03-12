variable "rgname" {
  type        = string
  description = "resource group name"
  default = "aksmern"
}

variable "location" {
  type    = string
  default = "australiaeast"
}

variable "service_principal_name" {
  type = string
  default = "jenkinsservice"
}

variable "keyvault_name" {
  type = string
  default = "meranapp002833"
}

variable "SUB_ID" {
  type = string
  default = data.azurerm_subscription.current.id
}
