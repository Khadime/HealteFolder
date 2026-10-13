terraform {
  required_version = ">= 1.9"
  required_providers { azurerm = { source = "hashicorp/azurerm", version = "~> 4.0" } }
}
provider "azurerm" { features {} }
variable "prefix" { type = string }
variable "location" { type = string }
variable "mysql_password" { type = string
  sensitive = true
}
resource "azurerm_resource_group" "health" { name = "${var.prefix}-health"
  location = var.location
}
resource "azurerm_virtual_network" "health" { name = "health-vnet"
  location = var.location
  resource_group_name = azurerm_resource_group.health.name
  address_space = ["10.40.0.0/16"]
}
resource "azurerm_subnet" "mysql" { name = "mysql"
  resource_group_name = azurerm_resource_group.health.name
  virtual_network_name = azurerm_virtual_network.health.name
  address_prefixes = ["10.40.1.0/24"]
  delegation { name = "mysql"
    service_delegation { name = "Microsoft.DBforMySQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}
resource "azurerm_private_dns_zone" "mysql" { name = "${var.prefix}.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.health.name
}
resource "azurerm_private_dns_zone_virtual_network_link" "mysql" { name = "mysql"
  resource_group_name = azurerm_resource_group.health.name
  private_dns_zone_name = azurerm_private_dns_zone.mysql.name
  virtual_network_id = azurerm_virtual_network.health.id
}
resource "azurerm_mysql_flexible_server" "health" { name = "${var.prefix}-mysql"
  resource_group_name = azurerm_resource_group.health.name
  location = var.location
  administrator_login = "healthadmin"
  administrator_password = var.mysql_password
  sku_name = "GP_Standard_D2ds_v4"
  version = "8.0.21"
  delegated_subnet_id = azurerm_subnet.mysql.id
  private_dns_zone_id = azurerm_private_dns_zone.mysql.id
  backup_retention_days = 35
  high_availability { mode = "ZoneRedundant" }
  depends_on = [azurerm_private_dns_zone_virtual_network_link.mysql]
}
resource "azurerm_mysql_flexible_database" "health" { name = "HealthPlatform"
  resource_group_name = azurerm_resource_group.health.name
  server_name = azurerm_mysql_flexible_server.health.name
  charset = "utf8mb4"
  collation = "utf8mb4_unicode_ci"
}
