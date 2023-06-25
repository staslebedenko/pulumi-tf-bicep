variable "resource_group_name" {}  
variable "log_analytics_name" {}  
variable "location" {}

resource "azurerm_log_analytics_workspace" "main" {  
  name                = var.log_analytics_name  
  location            = var.location
  resource_group_name = var.resource_group_name  
  sku                 = "PerGB2018"  
}  
  
output "id" {  
  value = azurerm_log_analytics_workspace.main.id  
}  
