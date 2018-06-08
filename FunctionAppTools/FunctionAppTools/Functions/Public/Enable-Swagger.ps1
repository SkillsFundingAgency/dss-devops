function Enable-Swagger {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]    
        [string]$ApplicationId,
        [Parameter(Mandatory=$true)]
        [System.Security.SecureString]$AppPassword,
        [Parameter(Mandatory=$true)]
        [string]$FunctionAppName,
        [Parameter(Mandatory=$true)]
        [string]$SubscriptionName
    )
    $BearerToken = Get-AzureApiBearerToken -SubscriptionName $SubscriptionName -ApplicationId $ApplicationId -AppPassword $AppPassword

    $Uri = "https://$FunctionAppName.scm.azurewebsites.net/api/functions/config"
    $Body = '{"swagger": {"enabled": true}}'
    Invoke-RestMethod -Method PUT -Headers @{'authorization'="Bearer $($BearerToken.access_token)"} -Uri $Uri -Body $Body -ContentType application/json
}
