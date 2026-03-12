data "azurerm_subscription" "current" {}
resource "azurerm_resource_group" "rg1" {
  name     = var.rgname
  location = var.location
}

module "ServicePrincipal" {
  source                 = "./modules/ServicePrincipal"
  service_principal_name = var.service_principal_name

  depends_on = [
    azurerm_resource_group.rg1
  ]
}

resource "azurerm_role_assignment" "rolespn" {

  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = module.ServicePrincipal.service_principal_object_id

  depends_on = [
    module.ServicePrincipal
  ]
}

# 2. The Wait Timer
resource "time_sleep" "wait_60_seconds" {
  depends_on = [azurerm_role_assignment.rolespn]

  create_duration = "60s"
}

resource "azurerm_key_vault_secret" "example" {
  name         = module.ServicePrincipal.client_id
  value        = module.ServicePrincipal.client_secret
  key_vault_id = module.keyvault.keyvault_id

  depends_on = [
    module.keyvault,
    time_sleep.wait_60_seconds
  ]
}
# 4. Upload SSH Key to Key Vault
resource "azurerm_key_vault_secret" "ssh_key" {
  name         = "aks-ssh-key"
  # Pulls the private key generated inside the module or root
  value        = module.aks.private_key_pem
  key_vault_id = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${var.rgname}/providers/Microsoft.KeyVault/vaults/${var.keyvault_name}"

  depends_on = [time_sleep.wait_60_seconds]
}


module "keyvault" {
  source                      = "./modules/Keyvault"
  keyvault_name               = var.keyvault_name
  location                    = var.location
  resource_group_name         = var.rgname
  service_principal_name      = var.service_principal_name
  service_principal_object_id = module.ServicePrincipal.service_principal_object_id
  service_principal_tenant_id = module.ServicePrincipal.service_principal_tenant_id

  depends_on = [
    module.ServicePrincipal
  ]
}



resource "azurerm_container_registry" "acrrgist" {
  name                = "contrainerRegistry242421"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  sku                 = "Basic"

}
resource "azurerm_role_assignment" "acr_spa_link" {
  scope                = azurerm_container_registry.acrrgist.id
  role_definition_name = "AcrPush"                                           # Or "AcrPull" depending on what it needs to do
  principal_id         = module.ServicePrincipal.service_principal_object_id # Note: Use principal_id, NOT client_id
}



#create Azure Kubernetes Service
module "aks" {
  source                     = "./modules/aks/"
  service_principal_name     = var.service_principal_name
  var_client_id              = module.ServicePrincipal.client_id
  client_secret              = module.ServicePrincipal.client_secret
  location                   = var.location
  rg                         = var.rgname
  azurerm_container_registry = azurerm_container_registry.acrrgist.id
  depends_on = [
    module.ServicePrincipal
  ]

}

resource "local_file" "kubeconfig" {
  depends_on = [module.aks]
  filename   = "./kubeconfig"
  content    = module.aks.config

}

