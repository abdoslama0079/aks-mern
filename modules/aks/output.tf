output "config" {
    value = azurerm_kubernetes_cluster.aks-cluster.kube_config_raw

}
output "private_key_pem" {
  value     = tls_private_key.aks_key.private_key_pem
  sensitive = true
}