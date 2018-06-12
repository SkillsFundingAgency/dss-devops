
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
        [string]$ApiResourceName,
        [Parameter(Mandatory=$true)]
        [string]$ResourceGroupName
    )

    $MasterKey = Get-FunctionAppMasterkey -ResourceGroupName $ResourceGroupName -FunctionAppName $FunctionAppName
    $Uri = "https://$FunctionAppName.azurewebsites.net/admin/host/systemkeys/swaggerdocumentationkey"
    $SwaggerKey = Invoke-RestMethod -Method post -Headers @{'x-functions-key'="$MasterKey"} -Uri $Uri -UseBasicParsing
    
    $Uri = "https://$FunctionAppName.azurewebsites.net/api/$ApiResourceName/api-definition?code=$($SwaggerKey.value)"
    $Swagger = Invoke-RestMethod -Method GET -Uri $Uri -UseBasicParsing
    $Swagger
}
