<#
.SYNOPSIS
Runner to invoke Acceptance, Quality and / or Unit tests

.DESCRIPTION
Test wrapper that invokes

.PARAMETER TestType
[Optional] The type of test that will be executed. The parameter value can be either All (default), Acceptance, Quality or Unit

.EXAMPLE
Invoke-AcceptanceTests.ps1

.EXAMPLE
Invoke-AcceptanceTests.ps1 -TestType Quality

#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory = $false)]
    [ValidateSet("All", "Acceptance", "Quality", "Unit")]
    [String] $TestType = "All",
    [Parameter(Mandatory = $false)]
    [String] $CodeCoveragePath
)

$pesterModuleV5 = Get-Module -Name Pester -ListAvailable | Where-Object {$_.Version -like '5.*'}
if (!$pesterModuleV5) {
    try {
        Write-Host "Removing Pester v5"
        $pesterModuleV5 = Get-Module -Name Pester -ListAvailable | Where-Object {$_.Version -like '5.*'}
        Remove-Module $pesterModuleV5
    }
    catch {
        Write-Error "Failed to remove the Pester module."
    }
}

$pesterModule = Get-Module -Name Pester -ListAvailable | Where-Object {$_.Version -like '4.*'}
if (!$pesterModule) {
    try {
        Write-Host "Installing Pester"
        Install-Module -Name Pester -Force -SkipPublisherCheck -RequiredVersion "4.10.1"
        Write-Host "Getting Pester version"
        $pesterModule = Get-Module -Name Pester -ListAvailable | Where-Object {$_.Version -like '4.*'}
    }
    catch {
        Write-Error "Failed to install the Pester module."
    }
}

$pesterModule | Import-Module -Force

$TestParameters = @{
    OutputFormat = 'NUnitXml'
    OutputFile   = "$PSScriptRoot\TEST-$TestType.xml"
    Script       = "$PSScriptRoot"
    PassThru     = $True
}
if ($TestType -ne 'All') {
    $TestParameters['Tag'] = $TestType
}
if ($CodeCoveragePath) {
    $TestParameters['CodeCoverage'] = $CodeCoveragePath
    $TestParameters['CodeCoverageOutputFile'] = "$PSScriptRoot\CODECOVERAGE-$TestType.xml"
}

# Remove previous runs
Remove-Item "$PSScriptRoot\TEST-*.xml"
Remove-Item "$PSScriptRoot\CODECOVERAGE-*.xml"

# Invoke tests
$Result = Invoke-Pester @TestParameters

# report failures
if ($Result.FailedCount -ne 0) { 
    Write-Error "Pester returned $($result.FailedCount) errors"
}