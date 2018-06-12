[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]     
    [string]$ModulePath,
    [Parameter(Mandatory=$true)]    
    [string]$ApplicationId,
    [Parameter(Mandatory=$true)]
    [String]$AppPassword,
    [Parameter(Mandatory=$true)]
    [string]$FunctionAppName,
    [Parameter(Mandatory=$true)]
    [string]$SubscriptionName
)

Import-Module $ModulePath

$SecurePwd = ConvertTo-SecureString -String $AppPassword -AsPlainText -Force

Enable-Swagger -ApplicationId $ApplicationId -AppPassword $SecurePwd -FunctionAppName $FunctionAppName -SubscriptionName $SubscriptionName -Verbose:$VerbosePreference