variable "resource_group_name" {}  
variable "key_vault_name" {}  
variable "location" {}  
  
data "azurerm_client_config" "current" {}  
  
resource "azurerm_key_vault" "main" {  
  name                = var.key_vault_name  
  location            = var.location  
  resource_group_name = var.resource_group_name  
  tenant_id           = data.azurerm_client_config.current.tenant_id  
  
  sku_name = "standard"  
  
  access_policy {  
    tenant_id = data.azurerm_client_config.current.tenant_id  
    object_id = data.azurerm_client_config.current.client_id  
  
    key_permissions = [  
      "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore",  
    ]  
  
    secret_permissions = [  
      "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore",  
    ]  
  
    certificate_permissions = [  
      "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers",  
    ]  
  }  
  
  timeouts {  
    create = "30m"  
    read   = "30m"  
    update = "30m"  
    delete = "30m"  
  }  
}  
