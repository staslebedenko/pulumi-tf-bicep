// Deploys App Service Plan with Log Analytics Diagnostics Settings

param location string
param appServicePlanName string
param tags object
param logAnalyticsId string

param planType string

param dedicatedPlanSize string

param premiumPlanSize string

// param appServicePlanName string = (planType != 'consumption') ? functionAppName : '${app_service_name}-plan'  
param planSize string = (planType == 'Dynamic') ? 'Y1' : (planType == 'Standard') ? dedicatedPlanSize : premiumPlanSize  
  
targetScope = 'resourceGroup'  
  
resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {  
  name: appServicePlanName  
  location: location  
  tags: tags  
  // properties: {  
  //   zoneRedundant: false  
  //   // targetWorkerCount: 1  
  // }  
  sku: {  
    name: planSize  
    tier: planType  
  }  
}  
  
resource servicePlanDiagnosticsSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {  
  name: 'la-diag-settings'  
  properties: {  
    workspaceId: logAnalyticsId  
    metrics: [  
      {  
        category: 'AllMetrics'  
        enabled: true  
        retentionPolicy: {  
          enabled: true  
          days: 90  
        }  
      }  
    ]  
  }  
  scope: appServicePlan  
}  
  
output servicePlanName string = appServicePlanName  
output servicePlanId string = appServicePlan.id  


// resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
//   name: app_service_name
//   location: location
//   tags: tags
//   properties: {
//     zoneRedundant: false
//     targetWorkerCount: 1
//   }
//   sku: {
//     name: planSize
//     tier: 'WorkflowStandard'
//   }
// }

// resource servicePlanDiagnosticsSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
//   name: 'la-diag-settings'
//   properties: {
//     workspaceId: logAnalyticsId
//     metrics: [
//       {
//         category: 'AllMetrics'
//         enabled: true
//         retentionPolicy: {
//           enabled: true
//           days: 90
//         }
//       }
//     ]
//   }
//   scope: appServicePlan
// }

// Deploys Azure Functions with Consumption, Dedicated (Basic/Standard/Premium), or Elastic Premium Plan  
  
