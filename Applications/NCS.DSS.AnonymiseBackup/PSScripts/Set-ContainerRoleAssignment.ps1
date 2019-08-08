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

$DebugPreference = "Continue"

Write-Verbose "Getting AzRoleAssignment in $ResourceGroup for $ManagedIdentityObjectId"
$ExistingAssignment = Get-AzRoleAssignment -ObjectId $ManagedIdentityObjectId -ResourceGroupName $ResourceGroup

if ($ExistingAssignment) {

    if ($ExistingAssignment.Count -gt 1) {

        Write-Verbose "RoleAssignments exist for $($ExistingAssignment[0].DisplayName)"
        $Roles = ""
        $Roles += foreach ($Role in $ExistingAssignment) { $Role.RoleDefinitionName.ToString() }
        Write-Verbose "$($ExistingAssignment[0].DisplayName) has been assigned $($Roles)"

    }
    else {

        Write-Verbose "$($ExistingAssignment.DisplayName) has been assigned $($ExistingAssignment.RoleDefinitionName)"

    }

}
else {

    Write-Verbose "Assigning 'Storage Blob Data Contributor' to $ManagedIdentityObjectId"
    $Result = New-AzRoleAssignment -ObjectId $ManagedIdentityObjectId -ResourceGroupName $ResourceGroup -RoleDefinitionName 'Storage Blob Data Contributor'
    Write-Verbose "New-AzRoleAssignment returned:"
    if ($VerbosePreference -ne "SilentlyContinue") {

        $Result
        
    }

}
