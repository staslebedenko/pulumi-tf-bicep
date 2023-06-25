variable "resource_group_name" {}  
variable "app_service_plan_name" {}  
variable "location" {}  
  
resource "azurerm_app_service_plan" "main" {  
  name                = var.app_service_plan_name  
  location            = var.location  
  resource_group_name = var.resource_group_name  
  kind                = "FunctionApp"  
  
  sku {  
    tier = "Dynamic"  
    size = "Y1"  
  }  
}  
  
output "id" {  
  value = azurerm_app_service_plan.main.id  
}  