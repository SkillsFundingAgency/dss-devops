[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$ManagedIdentityObjectId,
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroup
)

$ExistingAssignment = Get-AzRoleAssignment -ObjectId $ManagedIdentityObjectId -ResourceGroupName $ResourceGroup

if ($ExistingAssignment) {

    $Roles = ""
    $Roles += For-EachObject ($ExistingAssignment) { $_.RoleDefinitionName.ToString() }
    Write-Verbose "$($ExistingAssignment[0].DisplayName) has been assigned $($Roles)"

}
else {

    Write-Verbose "Assigning 'Storage Blob Data Contributor' to $ManagedIdentityObjectId"
    New-AzRoleAssignment -ObjectId $ManagedIdentityObjectId -ResourceGroupName $ResourceGroup -RoleDefinitionName 'Storage Blob Data Contributor' -Verbose:$VerbosePreference

}

