# Datasource to get Latest Azure AKS latest Version
# Check if there is a var with the version name , if not , use the 
# latest version, if there is a var, use that version
# make sure the version specified in var is valid

data "azurerm_kubernetes_service_versions" "current" {
  location = var.location
  include_preview = false  
}

# 1. Generate a new private/public key pair
resource "tls_private_key" "aks_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                  = "techtutorialwithpiyush-aks-cluster"
  location              = var.location
  resource_group_name   = var.rg
  dns_prefix            = "${var.rg}-cluster"           
  kubernetes_version    =  data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${var.rg}-nrg"

identity {
    type = "SystemAssigned"
  }
  acr_profile {
    acr_id = var.acr_cont
  }

  default_node_pool {
    name       = "defaultpool"
    vm_size    = "Standard_D2s_v3"
    # zones   = [1, 2, 3]
    auto_scaling_enabled = true
    max_count            = 3
    min_count            = 1
    os_disk_size_gb      = 30
    type                 = "VirtualMachineScaleSets"
    node_labels = {
      "nodepool-type"    = "system"
      "environment"      = "prod"
      "nodepoolos"       = "linux"
     } 
   tags = {
      "nodepool-type"    = "system"
      "environment"      = "prod"
      "nodepoolos"       = "linux"
   } 
  }


# upload the key to key vault

  linux_profile {
    admin_username = "ubuntu"
    ssh_key {
        key_data = tls_private_key.aks_key.public_key_openssh
    }
  }

  network_profile {
      network_plugin = "azure"
      load_balancer_sku = "standard"
  }


  }


