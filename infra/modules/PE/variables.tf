variable "location" {
  type        = string
  description = "Resources location in Azure"
}
variable "endpoint_resource_id" {
  description = "The ID of the resource that the new Private Endpoint will be assigned to."
  type        = string
}
variable "subresource_names" {
  type    = string
  default = null
}
variable "pe_resource_id" {
  type    = string
  default = null
}
variable "pe_network.subnet_name" {
  type    = string
  default = null
}

variable "dns_name"  {
  type    = string
  default = null
}
