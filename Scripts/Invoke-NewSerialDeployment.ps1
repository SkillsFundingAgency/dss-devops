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

if ($PrimaryArtefactBranchName -match "^refs/heads/master*") {

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

}
else {

    Write-Host "$PrimaryArtefactBranchName is not a valid master branch reference.  PrimaryArtefactBranchName must start /refs/heads/master.  Version suffixes are allowed, eg /refs/heads/master-v2"
    
}