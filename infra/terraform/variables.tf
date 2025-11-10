variable "location" {
  type        = string
  default     = "East US"
  description = "Azure region for resources."
}

variable "resource_group_name" {
  type        = string
  default     = "devops.experiment"   # use your existing RG
  description = "Existing resource group where resources will be created."
}

variable "aks_cluster_name" {
  type        = string
  default     = "aks-demoapp"
  description = "Name of AKS cluster."
}

variable "acr_name" {
  type        = string
  description = "Globally unique ACR name (lowercase, 5-50 chars)."
}

variable "dns_zone_name" {
  type        = string
  default     = "techis.store"
  description = "Optional DNS zone managed in Azure DNS (bonus)."
}
