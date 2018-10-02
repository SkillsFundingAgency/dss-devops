[CmdletBinding()]
param(
    [Guid]$ApplicationId,
    [System.Security.SecureString]$AppPassword
)

Import-Module (Resolve-Path -Path $PSScriptRoot\..\Modules\Helpers.psm1).Path

$SecurePassword = ConvertTo-SecureString $AppPassword -Force -AsPlainText

$BearerToken = Get-AzureApiBearerToken -ApplicationId $ApplicationId -AppPassword $SecurePassword