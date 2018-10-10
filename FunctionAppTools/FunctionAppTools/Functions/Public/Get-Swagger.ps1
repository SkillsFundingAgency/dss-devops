
function Get-Swagger{
<#
    . SUMMARY
    Calls api-defintion method in DSS function apps to return the swagger definition for that resource
    .NOTES
    Depends on Invoke-AzureRmResourceAction (called in private function Get-PublishingProfileCredentialsAzure) which runs only when logged on with a Service Principal
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$FunctionAppName,
        [Parameter(Mandatory=$true)]
        [string]$FunctionAppDomain,
        [Parameter(Mandatory=$true)]
        [string]$ApiResourceName,
        [Parameter(Mandatory=$true)]
        [string]$ResourceGroupName
    )

    $MasterKey = Get-FunctionAppHostKey -ResourceGroupName $ResourceGroupName -FunctionAppName $FunctionAppName -FunctionAppDomain $FunctionAppDomain
    
    $Uri = "https://$FunctionAppName.$FunctionAppDomain/api/$ApiResourceName/api-definition?code=$($MasterKey)"
    $Swagger = Invoke-RestMethod -Method GET -Uri $Uri -UseBasicParsing
    $Swagger
}
