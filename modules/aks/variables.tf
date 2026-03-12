variable "location" {
  type    = string
  default = "australiaeast"
}
 variable "resource_group_name" {
    type        = string
  description = "resource group name"
  default = "aksmern"
 }

variable "service_principal_name" {
    type = string
  default = "jenkinsservice"
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "client_id" {
  default = "0000"
}
variable "client_secret" {
  type = string
  sensitive = true
}

variable "azurerm_container_registry" {
  type = string
  default = "azrmregistry"
}
