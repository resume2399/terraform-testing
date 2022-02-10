resource "azurerm_virtual_network" "main" {
  name                = "wlvnet"
  location            = var.location
  resource_group_name = var.rgname
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "main" {
  name                 = "wlsubnet"
  resource_group_name  = var.rgname
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_public_ip" "main" {
  name                = "tfvmpip"
  location            = var.location
  resource_group_name = var.rgname
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

# Create network interface
resource "azurerm_network_interface" "main" {
  name                = var.nicname
  location            = var.location
  resource_group_name = var.rgname

  ip_configuration {
    name                          = "tfvmNicConfiguration"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}
resource "azurerm_linux_virtual_machine" "main" {
  name                            = var.vm_name
  location                        = var.location
  resource_group_name             = var.rgname
  network_interface_ids           = [azurerm_network_interface.main.id]
  size                            = "Standard_F1"
  computer_name                   = var.computer_name
  admin_username                  = var.vmadmin_name
  admin_password                  = var.vmadminpassword
  disable_password_authentication = false

  os_disk {
    name                 = var.osdiskname
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_network_security_group" "main" {
  for_each            = var.network_security_groups
  name                = each.value["name"]
  location            = var.location
  resource_group_name = var.rgname

  dynamic "security_rule" {
    for_each = lookup(each.value, "security_rules", [])
    content {
      name                         = security_rule.value["name"]
      description                  = lookup(security_rule.value, "description", null)
      protocol                     = coalesce(security_rule.value["protocol"], "Tcp")
      direction                    = security_rule.value["direction"]
      access                       = coalesce(security_rule.value["access"], "Allow")
      priority                     = security_rule.value["priority"]
      source_address_prefix        = lookup(security_rule.value, "source_address_prefix", null)
      source_address_prefixes      = lookup(security_rule.value, "source_address_prefixes", null)
      destination_address_prefix   = lookup(security_rule.value, "destination_address_prefix", null)
      destination_address_prefixes = lookup(security_rule.value, "destination_address_prefixes", null)
      source_port_range            = lookup(security_rule.value, "source_port_range", null)
      source_port_ranges           = lookup(security_rule.value, "source_port_ranges", null)
      destination_port_range       = lookup(security_rule.value, "destination_port_range", null)
      destination_port_ranges      = lookup(security_rule.value, "destination_port_ranges", null)
    }
  }
}

# Associates a Network Security Group with a Subnet within a Virtual Network
resource "azurerm_subnet_network_security_group_association" "this" {
  for_each                  = var.network_security_groups
  network_security_group_id = azurerm_network_security_group.main[each.value["name"]]["id"]
  subnet_id                 = azurerm_subnet.main.id
}
