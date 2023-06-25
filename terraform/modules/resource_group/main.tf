variable "resource_group_name" {}  
variable "location" {}

resource "azurerm_resource_group" "main" {  
  name     = var.resource_group_name  
  location = var.location
}  
  
output "name" {  
  value = azurerm_resource_group.main.name  
}  
