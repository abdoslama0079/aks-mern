terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.8.0"
    }
  }

  # THIS IS YOUR NEW BACKEND BLOCK
  backend "azurerm" {
    resource_group_name  = "rg-terraform-backend"
    storage_account_name = "abdotfstatef4ff53c8"
    container_name       = "tfstate"
    key                  = "mern-project.terraform.tfstate"
    
    # Optional: Use Azure AD for the state file access (more secure)
    use_azuread_auth     = true
  }
}

provider "azurerm" {
  features {}
}
