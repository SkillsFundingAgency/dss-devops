param(
    [Parameter(Mandatory=$true)]     
    [string]$ModulePath,
    [Parameter(Mandatory=$true)]    
    [string]$ApplicationId,
    [Parameter(Mandatory=$true)]
    [System.Security.SecureString]$AppPassword,
    [Parameter(Mandatory=$true)]
    [string]$FunctionAppName,
    [Parameter(Mandatory=$true)]
    [string]$SubscriptionName
)

Import-Module $ModulePath

Enable-Swagger -ApplicationId $ApplicationId -AppPassword $AppPassword -FunctionAppName $FunctionAppName -SubscriptionName $SubscriptionName