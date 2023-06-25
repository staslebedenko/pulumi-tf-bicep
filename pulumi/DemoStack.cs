using System.Threading.Tasks;
using Pulumi;

public class DemoStack : MyBaseStack
{
    private static string AppName => "fancyapp3535";
    private MyBaseStack _baseStack;

    public DemoStack()
    {
        _baseStack = new MyBaseStack();

        _baseStack.CreateResources(
            resourceGroupName: "demo-res-bicep",
            appName: "conference-demo33",
            appInsightsName: $"{AppName}-ai",
            logAnalyticsName: $"{AppName}-log-analytics",
            keyVaultName: "fanyc33vault"
        );
    }
}
