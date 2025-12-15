resource "random_string" "keyvault_suffix" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_key_vault" "credentials_key_vault" {
  name                        = "kv-${random_string.keyvault_suffix.result}"
  location                    = azurerm_resource_group.RG1.location
  resource_group_name         = azurerm_resource_group.RG1.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = false
  enable_rbac_authorization = true
}

resource "azurerm_role_assignment" "key_vault_access" {
  scope                = azurerm_key_vault.credentials_key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azurerm_client_config.current.object_id
}


resource "azurerm_key_vault_secret" "vm_secret" {
  name         = "credentials-secret"
  value = jsonencode({
    username = "adminuser"
    password = random_password.db_password.result
  })
  key_vault_id = azurerm_key_vault.credentials_key_vault.id
  depends_on = [ azurerm_role_assignment.key_vault_access ]
  content_type = "application/json"
}