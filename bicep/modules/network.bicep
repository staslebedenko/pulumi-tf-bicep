// Deploys virtual network for the function app

param rootPrefix string
param location string = resourceGroup().location
param environment string

param vnetCidrRange string
param enableVnet bool

targetScope = 'resourceGroup'

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = if (enableVnet) {
  name: '${rootPrefix}vnet${environment}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetCidrRange
      ]
    }
  }
}


output vnetName string = vnet.name
output vnetId string = vnet.id

// this section is for the future needs. There is a problem with subnet removal as of june 2023
// param subnetName string = 'MySubnet2'
// param subnetAddressPrefix string = '10.0.0.0/24'

// resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' = if (enableVnet) {
//   // name: '${vnet.name}${subnetName}'
//   name: '${rootPrefix}subnet${environment}' //'${subnetName}'
//   parent: vnet
//   properties: {  
//     addressPrefix: subnetAddressPrefix  
//     delegations: [  
//       {  
//         name: 'webappdelegation'  
//         properties: {  
//           serviceName: 'Microsoft.Web/serverFarms'  
//         }  
//       }  
//     ]  
//   }  
// }

// resource virtualNetworkIntegration 'Microsoft.Web/sites/networkConfig@2019-08-01' = if (enableVnet) {
//   name: '${functionApp.name}/virtualNetwork'
//   properties: {  
//     subnetResourceId: subnet.id  
//   }  
// }  
