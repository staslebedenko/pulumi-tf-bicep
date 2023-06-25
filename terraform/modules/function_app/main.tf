variable "resource_group_name" {}  
variable "function_app_name" {}  
variable "app_service_plan_id" {}  
variable "app_insights_key" {}  
variable "location" {}  
  
resource "azurerm_function_app" "main" {  
  name                       = var.function_app_name  
  location                   = var.location  
  resource_group_name        = var.resource_group_name  
  app_service_plan_id        = var.app_service_plan_id  
  storage_account_name       = azurerm_storage_account.main.name  
  storage_account_access_key = azurerm_storage_account.main.primary_access_key  
  version                    = "~3"  
  
  app_settings = {  
    "APPINSIGHTS_INSTRUMENTATIONKEY" = var.app_insights_key  
  }  
}  
  
resource "azurerm_storage_account" "main" {  
  name                     = "fancyapp3535storage"  
  resource_group_name      = var.resource_group_name  
  location                 = var.location  
  account_tier             = "Standard"  
  account_replication_type = "LRS"  
}  
