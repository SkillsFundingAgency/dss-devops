[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$EnvironmentName,
    [Parameter(Mandatory=$true)]
    [string]$ReleaseFolderPath,
    [Parameter(Mandatory=$true)]
    [string]$ThisRelease,
    [Parameter(Mandatory=$true)]
    [string]$PrimaryArtefactBranchName,
    [Parameter(Mandatory=$true)]
    [string]$Instance,
    [Parameter(Mandatory=$true)]
    [string]$PatToken,
    [Parameter(Mandatory=$true)]
    [string]$ProjectName,
    [Parameter(Mandatory=$true)]
    [string]$ModulePath
)

Import-Module $ModulePath

$NewSerialDeploymentParams = @{
    EnvironmentName = "$EnvironmentName"
    ReleaseFolderPath = "$ReleaseFolderPath"
    ThisRelease = "$ThisRelease"
    PrimaryArtefactBranchName = "$PrimaryArtefactBranchName"
    Instance = "$Instance"
    PatToken = "$PatToken"
    ProjectName = "$ProjectName"
}

New-SerialDeployment @NewSerialDeploymentParams