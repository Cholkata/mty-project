resource "azurerm_network_interface" "phpmyadmin_nic" {
    name                = "phpmyadmin-nic"
    location            = azurerm_resource_group.RG1.location
    resource_group_name = azurerm_resource_group.RG1.name

    ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.subnet1["database"].id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.phpmyadmin_public_ip.id
    }
}

resource "random_password" "db_password" {
    length  = 16
    special = true
    override_special = "_%@"
}

resource "azurerm_linux_virtual_machine" "phpmyadmin_vm" {
    name                = "phpmyadmin-vm"
    resource_group_name = azurerm_resource_group.RG1.name
    location            = azurerm_resource_group.RG1.location
    size                = "Standard_B1s"
    admin_username      = "adminuser"
    admin_password      = random_password.db_password.result
    disable_password_authentication = false
    network_interface_ids = [
        azurerm_network_interface.phpmyadmin_nic.id,
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
    computer_name  = "phpmyadmin-hostname"
}

output "password" {
    sensitive = true
    value = random_password.db_password.result
}

resource "azurerm_public_ip" "phpmyadmin_public_ip" {
    name                = "phpmyadmin-public-ip"
    location            = azurerm_resource_group.RG1.location
    resource_group_name = azurerm_resource_group.RG1.name
    allocation_method   = "Static"
    sku                 = "Standard"
  
}