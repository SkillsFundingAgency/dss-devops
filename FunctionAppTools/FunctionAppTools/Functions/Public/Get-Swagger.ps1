
function Get-Swagger{
<#
    .NOTES
    Depends on Invoke-AzureRmResourceAction (called in private function Get-PublishingProfileCredentialsAzure) which runs only when logged on with a Service Principal
#>
    param(
        $FunctionAppName,
        $ResourceGroupName
    )

    $MasterKey = Get-FunctionAppMasterkey -ResourceGroupName $ResourceGroupName -FunctionAppName $FunctionAppName
    $Uri = "https://$FunctionAppName.azurewebsites.net/admin/host/systemkeys/swaggerdocumentationkey"
    $SwaggerKey = Invoke-RestMethod -Method post -Headers @{'x-functions-key'="$MasterKey"} -Uri $Uri
    
    $Uri = "https://$FunctionAppName.azurewebsites.net/admin/host/swagger?code=$($SwaggerKey.value)"
    $Swagger = Invoke-RestMethod -Method GET -Uri $Uri
    $Swagger
}
