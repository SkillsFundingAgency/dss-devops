<#   
    .SYNOPSIS

    .EXAMPLE

    .NOTES
    https://docs.microsoft.com/en-us/rest/api/apimanagement/diagnostic/createorupdate
#>  
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$SubscriptionId,
    
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$true)]
    [string]$ApimInstanceName,
    
    [Parameter(Mandatory=$true)]
    [string]$ApiName,

    [Parameter(Mandatory=$true)]
    [string]$ApimLoggerId,

    [Parameter(Mandatory=$true)]
    [Guid]$TenantId,

    [Parameter(Mandatory=$true)]
    [Guid]$ApplicationId,
    
    [Parameter(Mandatory=$true)]
    [string]$AppRegistrationKey
)

Import-Module (Resolve-Path -Path $PSScriptRoot\..\Modules\Helpers.psm1).Path

$SecurePassword = ConvertTo-SecureString $AppRegistrationKey -Force -AsPlainText

Write-Verbose "Requesting bearer token"
$BearerToken = Get-AzureApiBearerToken -TenantId $TenantId -ApplicationId $ApplicationId -AppRegistrationKey $SecurePassword
Write-Verbose "Bearer token obtained`n$($BearerToken.access_token)"

$Uri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.ApiManagement/service/$ApimInstanceName/apis/$ApiName/diagnostics/$($ApimLoggerId)?api-version=2018-06-01-preview"
Write-Verbose "Calling Azure REST API method`n$Uri"
Invoke-RestMethod -Method GET -Uri $Uri -Headers @{Authorization = "Bearer $($BearerToken.access_token)"}

#$Uri = PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/diagnostics/{diagnosticId}?api-version=2018-06-01-preview