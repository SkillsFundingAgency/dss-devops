[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [AllowNull()]
    [AllowEmptyString()]
    [string]$DssApiVersion,
    [Parameter(Mandatory=$true)]
    [string]$ApimApiName
)

# this task exists to support the null versioning identifier required for version 1
# it can be removed when version 1 is depracated

if (!$DssApiVersion) { 

    Write-Verbose "Overriding ApimApiFullName variable"
    $Version1ApimApiName = $ApimApiName.Replace("-", "")
    Write-Verbose "Setting ApimApiFullName value to $Version1ApimApiName"
    Write-Output "##vso[task.setvariable variable=ApimApiFullName]$Version1ApimApiName" 
    Write-Verbose "ApimApiFullName value set to $ApimApiName"
    
}