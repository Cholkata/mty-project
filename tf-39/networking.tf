
resource "azurerm_virtual_network" "vnet1" {
    name                = "vnet1"
    location            = azurerm_resource_group.RG1.location
    resource_group_name = azurerm_resource_group.RG1.name
    address_space       = ["10.0.0.0/22"]
}


variable "subnets" {
    type = map(string)
    default =  {
        "frontend" = "10.0.1.0/24"
        "database" = "10.0.2.0/24"
    }
}

resource "azurerm_subnet" "subnet1" {
    for_each             = var.subnets
    name                 = each.key
    resource_group_name  = azurerm_resource_group.RG1.name
    virtual_network_name = azurerm_virtual_network.vnet1.name
    address_prefixes     = [each.value]
}

resource "azurerm_network_security_group" "nsg1" {
    name                = "nsg1"
    location            = azurerm_resource_group.RG1.location
    resource_group_name = azurerm_resource_group.RG1.name

    security_rule  {
      name                      = "Allow-HTTP"
      priority                  = 1000
      direction                 = "Inbound"
      access                    = "Allow"
      protocol                  = "Tcp"
      source_port_range         = "*"
      destination_port_range    = "80"
      source_address_prefix     = "*"
      destination_address_prefix = "*"
    }

    security_rule {
      name                      = "Allow-SSH"
      priority                  = 1001
      direction                 = "Inbound"
      access                    = "Allow"
      protocol                  = "Tcp"
      source_port_range         = "*"
      destination_port_range    = "22"
      source_address_prefix     = "*"
      destination_address_prefix = "*"
      }
      
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
    for_each            = var.subnets
    subnet_id           = azurerm_subnet.subnet1[each.key].id
    network_security_group_id = azurerm_network_security_group.nsg1.id
}

resource "azurerm_network_interface" "nic" {
    count = 2
    name                = "nic-${count.index + 1}"
    location            = azurerm_resource_group.RG1.location
    resource_group_name = azurerm_resource_group.RG1.name
    ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.subnet1["frontend"].id
        private_ip_address_allocation = "Dynamic"
    }
}
resource "azurerm_linux_virtual_machine" "vm" {
  count               = 2
  name                = "linux-vm-${count.index + 1}"
  resource_group_name = azurerm_resource_group.RG1.name
  location            = azurerm_resource_group.RG1.location
  size                = "Standard_B1s"

  admin_username                  = "adminuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/tf-ssh.pub")
  }

  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  computer_name = "hostname-${count.index + 1}"
}
