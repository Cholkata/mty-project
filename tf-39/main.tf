terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "~> 3.0"

        }
    }
    backend "azurerm" {
      resource_group_name = "tfstate"
      storage_account_name = "statefiletf01"
      container_name       = "tfstate"
      key                 = "terraform.tfstate"
    }
}

provider "azurerm" {
    features {}
}

data "azurerm_subscription" "primary" {}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "RG1" {
    name     = "resource-group-1"
    location = "France Central"
}

resource "azurerm_resource_group" "database" {
    name     = "rg-database-manual"
    location = "France Central"
}