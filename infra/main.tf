# File test
terraform {
  backend "azurerm" {
    resource_group_name  = "TerraformDevOps"
    storage_account_name = "fiservdevopssa"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
# Create a resource group
module "RG" {
  source   = "./modules/RG" #A
  rgname   = var.rgname     #B
  location = var.location
}
# Create Storage Account 
module "SA" {
  source   = "./modules/StorageAccount"
  sname    = var.sname
  rgname   = var.rgname
  location = var.location
}
# Create Azure Container Registry (ACR) 
module "ACR" {
  source   = "./modules/ACR"
  acr_name = var.acr_name
  location = var.location
  rgname   = var.rgname
}
# Create Azure Kubernetes Service(AKS)
module "AKS" {
  source              = "./modules/AKS"
  cluster_name        = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  location            = var.location
  rgname              = var.rgname
  acr_name            = var.acr_name
  node_resource_group = var.node_resource_group
  system_node_count   = var.system_node_count
}
# Create VM
module "VM" {
  source              = "./modules/VM"
  vmadminpassword     = var.vmadminpassword
  location            = var.location
  rgname              = var.rgname
  computer_name       = var.computer_name
  vmadmin_name        = var.vmadmin_name
  node_resource_group = var.node_resource_group
  osdiskname          = var.osdiskname
  nicname             = var.nicname
  vm_name             = var.vm_name
}
# Create Private Endpoints (PE)
module "PE" {
 source              = "./modules/PE"
 subnet_name         = var.pe_network.subnet_name
 virtual_network_name = var.pe_network.vnet_name
 resource_group_name  = var.pe_network.resource_group_name
 rgname = var.pe_resource_group_name
 pe_name             = var.pe_name
 location            = var.location
 connection_name                = var.pe_connection
 private_connection_resource_id = var.endpoint_resource_id
 subresource_names              = var.subresource_names
 dns_name             = var.dns.zone_name
 private_dns_zone_ids = var.dns.zone_ids
}
# Create DNS