using Pulumi;
using Pulumi.AzureNative.Insights;
using Pulumi.AzureNative.KeyVault;
using Pulumi.AzureNative.KeyVault.Inputs;
using Pulumi.AzureNative.OperationalInsights;
using Pulumi.AzureNative.Resources;
using Pulumi.AzureNative.Web;
using Pulumi.AzureNative.Web.Inputs;
using Pulumi.AzureNative.Authorization;
using Pulumi.AzureNative.Authorization.Inputs;
using System.Collections.Generic;

public class MyBaseStack 
{
    protected ResourceGroup ResourceGroup;
    protected Component AppInsights;
    protected Workspace LogAnalytics;
    protected WebApp FunctionsApp;
    protected AppServicePlan Plan;
    protected Vault KeyVault;
    protected Secret Secret;
    public Output<string> FunctionAppConnectionString { get; set; }
    
    public void CreateResources(string resourceGroupName, string appName, string appInsightsName, string logAnalyticsName, string keyVaultName)
    {
        ResourceGroup = new ResourceGroup(resourceGroupName, new ResourceGroupArgs
        {
            Location = "westeurope"
        });

        AppInsights = new Component(appInsightsName, new ComponentArgs
        {
            ResourceGroupName = ResourceGroup.Name,
            Kind = "web",
            ApplicationType = "web"
        });

        LogAnalytics = new Workspace(logAnalyticsName, new WorkspaceArgs
        {
            ResourceGroupName = ResourceGroup.Name
        });

        Plan = new AppServicePlan($"{appName}-plan", new AppServicePlanArgs
        {
            ResourceGroupName = ResourceGroup.Name,
            Kind = "FunctionApp",
            Sku = new SkuDescriptionArgs
            {
                Tier = "Standard",
                Name = "S1"
            }
        });

        FunctionsApp = new WebApp(appName, new WebAppArgs
        {
            ResourceGroupName = ResourceGroup.Name,
            ServerFarmId = Plan.Id,
            Kind = "function",
            SiteConfig = new SiteConfigArgs
            {
                AppSettings = new InputList<NameValuePairArgs>
                {
                    new NameValuePairArgs { Name = "APPINSIGHTS_INSTRUMENTATIONKEY", Value = AppInsights.InstrumentationKey },
                    new NameValuePairArgs { Name = "ApplicationInsightsAgent_EXTENSION_VERSION", Value = "~4" },
                    new NameValuePairArgs { Name = "FUNCTIONS_WORKER_RUNTIME", Value = "dotnet" },
                    new NameValuePairArgs { Name = "WEBSITE_RUN_FROM_PACKAGE", Value = "https://microsoft.github.io/azure-functions/functionsapp.zip" },
                }
            }
        });

        //var appFunctionKey = Output.Tuple(ResourceGroup.Name, FunctionsApp.Name).Apply(names =>
        //{
        //    (string resourceGroupName, string functionName) = names;
        //    var appFunctionKeys = ListWebAppFunctionKeys.InvokeAsync(new ListWebAppFunctionKeysArgs
        //    {
        //        ResourceGroupName = resourceGroupName,
        //        FunctionName = functionName
        //    });
        //    return appFunctionKeys.Result.Value;
        //});

        var currentUserId = Output.Create(GetClientConfig.InvokeAsync())
            .Apply(config => config.ObjectId);


        //KeyVault = new Vault(keyVaultName, new VaultArgs
        //{
        //    ResourceGroupName = ResourceGroup.Name,
        //    Properties = new VaultPropertiesArgs
        //    {
        //        TenantId = AppInsights.TenantId,
        //        Sku = new SkuArgs
        //        {
        //            Name = SkuName.Standard,
        //            Family = SkuFamily.A
        //        },
        //        AccessPolicies = { }
        //    }
        //});

        KeyVault = new Vault(keyVaultName, new VaultArgs
        {
            ResourceGroupName = ResourceGroup.Name,
            Properties = new VaultPropertiesArgs
            {
                TenantId = AppInsights.TenantId,
                Sku = new SkuArgs
                {
                    Name = SkuName.Standard,
                    Family = SkuFamily.A
                },
                AccessPolicies = new List<Input<AccessPolicyEntryArgs>>
        {
            new AccessPolicyEntryArgs
            {
                ObjectId = currentUserId,
                TenantId = AppInsights.TenantId,
                Permissions = new PermissionsArgs
                {
                    Keys = new InputList<Union<string, KeyPermissions>>
                    {
                        KeyPermissions.Get,
                        KeyPermissions.List,
                        KeyPermissions.Update,
                        KeyPermissions.Create,
                        KeyPermissions.Import,
                        KeyPermissions.Delete,
                        KeyPermissions.Recover,
                        KeyPermissions.Backup,
                        KeyPermissions.Restore
                    },
                    Secrets = new InputList <Union<string, SecretPermissions>>
                    {
                        SecretPermissions.Get,
                        SecretPermissions.List,
                        SecretPermissions.Set,
                        SecretPermissions.Delete,
                        SecretPermissions.Recover,
                        SecretPermissions.Backup,
                        SecretPermissions.Restore
                    },
                    Certificates = new InputList <Union<string, CertificatePermissions>>
                    {
                        CertificatePermissions.Get,
                        CertificatePermissions.List,
                        CertificatePermissions.Update,
                        CertificatePermissions.Create,
                        CertificatePermissions.Import,
                        CertificatePermissions.Delete,
                        CertificatePermissions.Recover,
                        CertificatePermissions.Backup,
                        CertificatePermissions.Restore,
                    }
                }
            }
        }
            }
        });



        //Secret = new Secret("function-connection-string", new SecretArgs
        //{
        //    VaultUri = KeyVault.Properties.Apply(p => p.VaultUri),
        //    Properties = new SecretPropertiesArgs
        //    {
        //        Value = appFunctionKey
        //    }
        //});

        // FunctionAppConnectionString = appFunctionKey;
    }
}
