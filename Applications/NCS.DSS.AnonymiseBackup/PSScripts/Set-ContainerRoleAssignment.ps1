[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$ManagedIdentityObjectId,
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroup
)

Write-Verbose "Getting AzRoleAssignment in $ResourceGroup for $ManagedIdentityObjectId"
$ExistingAssignment = Get-AzRoleAssignment -ObjectId $ManagedIdentityObjectId -ResourceGroupName $ResourceGroup

if ($ExistingAssignment) {

    Write-Verbose "RoleAssignments exist for $($ExistingAssignment[0].DisplayName)"
    $Roles = ""
    $Roles += For-EachObject ($ExistingAssignment) { $_.RoleDefinitionName.ToString() }
    Write-Verbose "$($ExistingAssignment[0].DisplayName) has been assigned $($Roles)"

}
else {

    Write-Verbose "Assigning 'Storage Blob Data Contributor' to $ManagedIdentityObjectId"
    $Result = New-AzRoleAssignment -ObjectId $ManagedIdentityObjectId -ResourceGroupName $ResourceGroup -RoleDefinitionName 'Storage Blob Data Contributor'
    Write-Verbose "New-AzRoleAssignment returned:"
    if ($VerbosePreference) {

        $Result
        
    }

}

