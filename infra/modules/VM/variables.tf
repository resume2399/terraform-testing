variable "rgname" {
  type        = string
  description = "RG name in Azure"
}

variable "vmadminpassword" {
  type        = string
  description = "VM password in Azure"
  sensitive   = true
}

variable "location" {
  type = string
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
variable "node_resource_group" {
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
