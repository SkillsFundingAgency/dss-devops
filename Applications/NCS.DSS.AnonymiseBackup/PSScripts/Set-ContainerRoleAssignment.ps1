<#
 .SYNOPSIS
 Adds the 'Storage Blob Data Contributor' Role Assignment to an App Registration

 .DESCRIPTION
 Adds the 'Storage Blob Data Contributor' Role Assignment to an App Registration

 .EXAMPLE
 .\Set-ContainerRoleAssignment.ps1 -ManagedIdentityObjectId 960c2fa2-d8d4-4168-a854-417d3d9e2e40 -ResourceGroup dss-foo-shared-rg -Verbose

 .NOTES
 Service Principl needs to be assigned to the 'User Access Administrator' role on the ResourceGroup (or parent Subscription)
 ServicePrincipal requires Delegated API Permission: Azure Active Directory Graph Directory.Read.All
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$ManagedIdentityObjectId,
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroup
)

$RoleDefinitionName = 'Storage Blob Data Contributor'

Write-Verbose "Getting AzRoleAssignment in $ResourceGroup for $ManagedIdentityObjectId"
$ExistingAssignment = Get-AzRoleAssignment -ObjectId $ManagedIdentityObjectId -ResourceGroupName $ResourceGroup -RoleDefinitionName $RoleDefinitionName

if ($ExistingAssignment) {

    Write-Verbose "$($ExistingAssignment.DisplayName) is assigned $($ExistingAssignment.RoleDefinitionName)"

}
else {

    Write-Verbose "Assigning 'Storage Blob Data Contributor' to $ManagedIdentityObjectId"
    $Result = New-AzRoleAssignment -ObjectId $ManagedIdentityObjectId -ResourceGroupName $ResourceGroup -RoleDefinitionName $RoleDefinitionName
    Write-Verbose "New-AzRoleAssignment returned:"
    if ($VerbosePreference -ne "SilentlyContinue") {

        $Result
        
    }

}
