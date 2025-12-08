
resource "azurerm_virtual_network" "vnet1" {
    name                = "vnet1"
    location            = azurerm_resource_group.RG1.location
    resource_group_name = azurerm_resource_group.RG1.name
    address_space       = ["10.0.0.0/16"]
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
    admin_username      = "adminuser"
    admin_password      = random_password.db_password.result
  disable_password_authentication = false
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
    computer_name  = "hostname-${count.index + 1}"
}

resource "random_password" "db_password" {
    length  = 16
    special = true
    override_special = "_%@"
}

resource "azurerm_network_interface" "db_nic" {
  name                = "db-nic"
  location            = azurerm_resource_group.database.location
  resource_group_name = azurerm_resource_group.database.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1["database"].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "database_vm" {
  name                = "db-server"
  resource_group_name = azurerm_resource_group.database.name
  location            = azurerm_resource_group.database.location
  size                = "Standard_B2s"
  admin_username      = "dbadmin"
  admin_password      = random_password.db_password.result
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.db_nic.id,
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

  computer_name = "db-hostname"
}

output "password" {
    sensitive = true
    value = random_password.db_password.result
}