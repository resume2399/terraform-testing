variable "rgname" {
  description = "Resource Group Name"
  default     = "tfaks_rg"
  type        = string
}
variable "location" {
  description = "Azure location"
  default     = "East US"
  type        = string
}
variable "sname" {
  description = "Azure Storage Account"
  type        = string
}
variable "cluster_name" {
  type        = string
  description = "AKS name in Azure"
}
variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
}
variable "system_node_count" {
  type        = number
  description = "Number of AKS worker nodes"
}
variable "node_resource_group" {
  type        = string
  description = "RG name for cluster resources in Azure"
}
variable "acr_name" {
  type        = string
  description = "ACR name in Azure"
}
variable "vmadminpassword" {
  type        = string
  description = "VM password in Azure"
  sensitive   = true
}
variable "nicname" {
  type = string
}
variable "vm_name" {
  type = string
}
variable "computer_name" {
  type = string
}
variable "vmadmin_name" {
  type = string
}
variable "osdiskname" {
  type = string
}
variable "network_security_groups" {
  type = map(object({
    name                      = string
    tags                      = map(string)
    subnet_name               = string
    vnet_name                 = string
    networking_resource_group = string
    security_rules = list(object({
      name                                         = string
      description                                  = string
      protocol                                     = string
      direction                                    = string
      access                                       = string
      priority                                     = number
      source_address_prefix                        = string
      source_address_prefixes                      = list(string)
      destination_address_prefix                   = string
      destination_address_prefixes                 = list(string)
      source_port_range                            = string
      source_port_ranges                           = list(string)
      destination_port_range                       = string
      destination_port_ranges                      = list(string)
      source_application_security_group_names      = list(string)
      destination_application_security_group_names = list(string)
    }))
  }))
  description = "The network security groups with their properties."
  default     = {}
}
variable "pe_network.subnet_name" {
  type    = string
  default = null
}

