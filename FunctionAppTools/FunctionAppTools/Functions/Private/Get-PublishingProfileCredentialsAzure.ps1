<#
    .SUMMARY 
    Function to get publishing profile
#>
function Get-PublishingProfileCredentialsAzure{   
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]    
        $ResourceGroupName,
        [Parameter(Mandatory=$true)]
        $FunctionAppName
    )
 
    $ResourceType = "Microsoft.Web/sites/config"
    $ResourceName = "$FunctionAppName/publishingcredentials"
 
    $PublishingCredentials = Invoke-AzureRmResourceAction -ResourceGroupName $ResourceGroupName -ResourceType $ResourceType -ResourceName $ResourceName -Action list -ApiVersion 2015-08-01 -Force
 
    return $PublishingCredentials
}