output "acr_login_server" {
  description = "Login server for ACR."
  value       = azurerm_container_registry.acr.login_server
}

output "aks_name" {
  description = "Name of AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.name
}

output "kube_config" {
  description = "Raw kubeconfig for the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}
