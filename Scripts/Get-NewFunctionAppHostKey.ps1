[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$ModulePath,
    [Parameter(Mandatory=$true)]
    $ResourceGroupName,
    [Parameter(Mandatory=$true)]
    $FunctionAppName,
    [Parameter(Mandatory=$true)]
    $FunctionAppDomain
)

Import-Module $ModulePath

$NewKey = Set-FunctionAppHostKey -ResourceGroupName $ResourceGroupName -FunctionAppName $FunctionAppName -FunctionAppDomain $FunctionAppDomain -KeyName "default"

Write-Host "##vso[task.setvariable variable=FunctionHostKey]$NewKey"