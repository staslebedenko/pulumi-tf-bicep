variable "resource_group_name" {}  
variable "app_insights_name" {}  
variable "location" {}

resource "azurerm_application_insights" "main" {  
  name                = var.app_insights_name  
  location            = var.location 
  resource_group_name = var.resource_group_name  
  application_type    = "web"  
}  
  
output "instrumentation_key" {  
  value       = azurerm_application_insights.main.instrumentation_key  
  description = "The Application Insights Instrumentation Key"  
}  
