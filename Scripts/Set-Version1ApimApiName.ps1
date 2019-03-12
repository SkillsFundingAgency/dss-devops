[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    $DssApiVersion,
    [Parameter(Mandatory=$true)]
    [string]$ApimApiName
)

# this task exists to support the null versioning identifier required for version 1
# it can be removed when version 1 is depracated

if (!$DssApiVersion) { 

    Write-Verbose "Overriding ApimApiName variable"
    $Version1ApimApiName = $ApimApiName.Replace("-", "")
    Write-Verbose "Setting ApimApiName value to $Version1ApimApiName"
    Write-Output "##vso[task.setvariable variable=ApimApiName]$Version1ApimApiName" 
    Write-Verbose "ApimApiName value set to $ApimApiName"
    
}