module "resource_group" {  
  source  = "./modules/resource_group"  
  
  resource_group_name = "demo-res-terraform"
  location            = "westeurope" 
}  
  
module "app_insights" {  
  source  = "./modules/app_insights"  
  
  resource_group_name = module.resource_group.name  
  app_insights_name   = "fancyapp4435-ai"
  location            = "westeurope" 
}  
  
module "log_analytics" {  
  source  = "./modules/log_analytics"  
  
  resource_group_name = module.resource_group.name  
  log_analytics_name  = "fancyapp4435-log-analytics"
  location            = "westeurope" 
}  
  
module "key_vault" {  
  source  = "./modules/key_vault"  
  
  resource_group_name = module.resource_group.name  
  key_vault_name      = "fanyc44vault" 
  location            = "westeurope" 
}  

module "app_service_plan" {  
  source = "./modules/app_service_plan"  
  
  resource_group_name    = module.resource_group.name  
  app_service_plan_name  = "fancyapp4435-plan"  
  location               = "westeurope"  
}  
  
module "function_app" {  
  source = "./modules/function_app"  
  
  resource_group_name = module.resource_group.name  
  function_app_name   = "fancyapp4435-function"  
  app_service_plan_id = module.app_service_plan.id
  app_insights_key    = module.app_insights.instrumentation_key  
  location            = "westeurope"  
}  