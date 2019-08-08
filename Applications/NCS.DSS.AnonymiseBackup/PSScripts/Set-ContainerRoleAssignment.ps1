<#

 .NOTES
 ServicePrincipal requires Delegated API Permission: Microsoft.Graph Group.ReadWrite.All
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
