@description('Location of the connection, defaults to resource group location')
param location string = resourceGroup().location

param root_prefix string

@allowed([
  'dev'
  'test'
  'prod'
])
param environment string
param app_insights string

param app_name string

param enable_vnet string  
  
var enableVnet = (toLower(enable_vnet) == 'true') ? true : false  

param logAnalytics_name string = 'fdsfefew23r3f'

@allowed([
  'Dynamic'  
  'Standard'  
  'PremiumV2'
])
param plan_type string =  'Standard'

@allowed([
  'S1'  
  'S2'  
  'S3'
  'None'
])
param dedicated_plan_size string = 'S1'

@allowed([
  'P1v2'
  'P2v2'
  'None'
])
param premium_plan_size string = 'P1v2'

param vnet_cidr_range string = '10.0.0.0/16'  

param app_service_name string = 'fbgui06yg-funcst-dev'

param key_vault_name string = '${root_prefix}demo3${environment}'

var tags = {
  usage: environment
  description: 'environment'
}

module keyVaultModule 'modules/key-vault.bicep' = {  
  name: 'keyVaultModule'  
  params: {  
    keyVaultSku: 'Standard'
    keyVaultName: key_vault_name  
    location: location  
    enabledForDeployment: false  
    enabledForDiskEncryption: false  
    enabledForTemplateDeployment: true  
  }  
} 

module network 'modules/network.bicep' = {  
  name: 'networkModule'  
  dependsOn: [  
    keyVaultModule  
  ]
  params: {  
    enableVnet: enableVnet
    environment: environment
    location: location
    rootPrefix: root_prefix
    vnetCidrRange: vnet_cidr_range
  }  
}  

var vnetId = network.outputs.vnetId  

module monitoring 'modules/application-insights.bicep' = {  
  name: 'logging-la-standard'  
  dependsOn: [
    network
  ]
  params: {  
    location: location  
    logAnalyticsWorkspaceName: logAnalytics_name  
    appInsightsName: 'ai-test-to-delete55e3'  
  }  
}  

var logAnalyticsId = monitoring.outputs.logAnalyticsId  

module functionAppsplan 'modules/service-plan.bicep' = {
  name: 'commonFuncAppsPlan6475'
  dependsOn: [
    monitoring
  ]
  params: {
    tags: tags
    location: location
    appServicePlanName: app_service_name
    planType: plan_type
    dedicatedPlanSize: dedicated_plan_size
    premiumPlanSize: premium_plan_size
    logAnalyticsId: logAnalyticsId
  }
}

module functionApp 'modules/function-app.bicep' = {
  name: 'functionApp'
  dependsOn: [
    functionAppsplan  
  ]
  params: {
    appInsightsName: app_insights
    appServicePlanName: app_service_name
    appName: app_name
    rootPrefix: root_prefix
    environment: environment
    location: location
    vnetId: vnetId
    enableVnet: enableVnet
    keyVaultName: key_vault_name
  }
}

