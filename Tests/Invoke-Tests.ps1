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

Import-Module Pester

[CmdletBinding()]
Param (
    [Parameter(Mandatory = $false)]
    [ValidateSet("All", "Acceptance", "Quality", "Unit")]
    [String] $TestType = "All",
    [Parameter(Mandatory = $false)]
    [String] $CodeCoveragePath
)

$TestConfiguration = [PesterConfiguration]@{
    Run = @{
        Path         = "$PSScriptRoot"
        PassThru     = $True
    }
    TestResult = @{
        OutputFormat = 'NUnitXml'
        OutputPath   = "$PSScriptRoot\TEST-$TestType.xml"
    }
    Script       = "$PSScriptRoot"
}
if ($TestType -ne 'All') {
    $TestConfiguration.Filter.Tag = $TestType
}
if ($CodeCoveragePath) {
    $TestConfiguration.Filter.CodeCoverage = $CodeCoveragePath
    $TestConfiguration.Filter.CodeCoverageOutputFile = "$PSScriptRoot\CODECOVERAGE-$TestType.xml"
}

# Remove previous runs
Remove-Item "$PSScriptRoot\TEST-*.xml"
Remove-Item "$PSScriptRoot\CODECOVERAGE-*.xml"

# Invoke tests
$Result = Invoke-Pester -Configuration @TestConfiguration

# report failures
if ($Result.FailedCount -ne 0) { 
    Write-Error "Pester returned $($result.FailedCount) errors"
}