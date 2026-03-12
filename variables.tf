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


