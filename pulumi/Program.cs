using System.Collections.Generic;
using Pulumi;

return await Deployment.RunAsync(() =>
{
    // Create an instance of DemoStack  
    var stack = new DemoStack();

    // Export outputs here  
    return new Dictionary<string, object?>
    {
        ["outputKey"] = "outputValue"
    };
});
