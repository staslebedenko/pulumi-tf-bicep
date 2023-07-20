# pulumi-tf-bicep

az group create --name demo-res-bicep --location westeurope  

az deployment group create --resource-group demo-res-bicep --name bicepDeploy --template-file function-app.bicep --parameters @function-app.parameters.json  


pulumi login 
az login
pulumi up


terraform init  
terraform validate  
terraform apply  
