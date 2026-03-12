variable "keyvault_name" {
  type    = string
  default = "meranapp002833"
}

variable "location" {
  type    = string
  default = "australiaeast"
}
variable "resource_group_name" {
  type        = string
  description = "resource group name"
  default     = "aksmern"
}

variable "service_principal_name" {
  type    = string
  default = "default"
}

variable "service_principal_object_id" { default = "default" }
variable "service_principal_tenant_id" { default = "default" }

