[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$SubscriptionId,
    
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$true)]
    [string]$ApimInstanceName,
    
    [Parameter(Mandatory=$true)]
    [string]$ApimLoggerId,
    
    [Parameter(Mandatory=$true)]
    [Guid]$ApplicationId,
    
    [Parameter(Mandatory=$true)]
    [System.Security.SecureString]$AppPassword
)

Import-Module (Resolve-Path -Path $PSScriptRoot\..\Modules\Helpers.psm1).Path

$SecurePassword = ConvertTo-SecureString $AppPassword -Force -AsPlainText

$BearerToken = Get-AzureApiBearerToken -ApplicationId $ApplicationId -AppPassword $SecurePassword

$Uri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.ApiManagement/service/$ApimInstanceName/diagnostics/$ApimLoggerId?api-version=2018-06-01-preview"

Invoke-RestMethod -Method GET -Uri $Uri -Headers @{Authorization = "Bearer $($BearerToken.access_token)"}

#$Uri = PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/diagnostics/{diagnosticId}?api-version=2018-06-01-preview