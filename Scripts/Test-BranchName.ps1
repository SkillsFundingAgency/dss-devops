<#
    .SYNOPSIS
    Checks that a branch name confirms to agreed DSS naming convention and writes variables to Azure DevOps Pipelines to be consumed by later steps

    .EXAMPLE
    Test-BranchName -BranchName $(Build.SourceBranchName) -PullRequestBranchName $(if ("$(Build.SourceBranchName)" -eq "merge") { "$(System.PullRequest.SourceBranch)" } else { "NotAPullRequest" } ) -PipelineType Build -Verbose

    .PARAMETER BranchName
    The name of a branch

    .PARAMETER PullRequestBranchName
    Required if Build definition will be triggered by Pull Requests.  See example for how to implement this.

    .PARAMETER PipelineType
    Either Build or Release

    .PARAMETER FunctionAppBaseName
    The function app name minus the version, eg dss-at-cust-fa rather than dss-at-cust-v2-fa

    .PARAMETER FunctionAppSuffix
    If defined, appends this suffix on the end of the generated function app name.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$BranchName,
    [Parameter(Mandatory=$false)]
    [string]$PullRequestBranchName,
    [ValidateSet("Build", "Release")]
    [Parameter(Mandatory=$true)]
    [string]$PipelineType,
    [Parameter(Mandatory=$false, ParameterSetName="Release")]
    [string]$FunctionAppBaseName,
    [Parameter(Mandatory=$false, ParameterSetName="Release")]
    [string]$FunctionAppSuffix
)

function Write-FunctionAppName {
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$NameParts,
        [Parameter(Mandatory=$true, ParameterSetName="Version1")]
        [switch]$Version1,
        [Parameter(Mandatory=$true, ParameterSetName="Version2+")]
        $RegExMatches,
        [string]$FunctionAppSuffix = ""
    )
 
    $version = "v1"

    if(-not $Version1.IsPresent) { $version = $RegExMatches[1] }

    $appFragments = @(
        $NameParts[0..2]
        $version
        $NameParts[3]
    )

    if($FunctionAppSuffix -ne "") { $appFragments += $FunctionAppSuffix }

    $FunctionAppName = $appFragments -join '-'

    Write-Verbose -Message "Setting FunctionAppName to $FunctionAppName"
    $Output = "##vso[task.setvariable variable=FunctionAppName;isOutput=false]$FunctionAppName"
    $Output
}

# --- RegEx Patterns
$V1MasterBranchRegEx = "^master$"
$V1FeatureBranchRegEx = "^(?:CDS|SDD|NCSLT|AD|DSS-Release)-(?:.*(?:-\d+)|(?:\d+).*)-(v1){1}$"

$V2OrHigherMasterBranchRegEx = "^master-(v[2-9])$"
$V2OrHigherFeatureBranchRegEx = "^(?:CDS|SDD|NCSLT|AD|DSS-Release)-(?:.*(?:-\d+)|(?:\d+).*)-(v(?:[2-9]|\d\d\d*)){1}$"

if ($PSCmdlet.ParameterSetName -eq "Release") {

    $Result = $FunctionAppBaseName | Select-String -Pattern "^[a-z]+-[a-z]+-[a-z]+-fa$"
    if (!$Result) {
    
        throw "Warning: FunctionAppBaseName variable not set correctly, value $FunctionAppBaseName must match regex ^[a-z]+-[a-z]+-[a-z]+-fa$, eg dss-at-cust-fa"
    
    }
    else {
    
        $NameParts = $FunctionAppBaseName -split "-"
    
    }  

}

if ($PipelineType -eq "Build") {

    $IsOutput = "true"

}
elseif ($PipelineType -eq "Release") {

    $IsOutput = "false"

}

if ($BranchName -match $V1MasterBranchRegEx) {

    Write-Verbose -Message "$BranchName is a a version 1 master branch"
    Write-Output "##vso[task.setvariable variable=FunctionAppVersion;isOutput=$IsOutput]Version1"
    Write-Output "##vso[task.setvariable variable=DssApiVersion;isOutput=$IsOutput]$null"
    if ($PSCmdlet.ParameterSetName -eq "Release") {

        $Output = Write-FunctionAppName -NameParts $NameParts -Version1 -FunctionAppSuffix $FunctionAppSuffix
        Write-Output $Output

    }

}
elseif ($BranchName -match $V1FeatureBranchRegEx) {

    Write-Verbose -Message "$BranchName is a version 1 feature branch"
    Write-Output "##vso[task.setvariable variable=FunctionAppVersion;isOutput=$IsOutput]Version1"
    Write-Output "##vso[task.setvariable variable=DssApiVersion;isOutput=$IsOutput]$null"
    if ($PSCmdlet.ParameterSetName -eq "Release") {

        $Output = Write-FunctionAppName -NameParts $NameParts -Version1 -FunctionAppSuffix $FunctionAppSuffix
        Write-Output $Output

    }

}
elseif ($BranchName -match $V2OrHigherMasterBranchRegEx) {
    
    Write-Verbose -Message "$BranchName is a version 2 or higher master branch"
    Write-Output "##vso[task.setvariable variable=FunctionAppVersion;isOutput=$IsOutput]Version2+"
    Write-Output "##vso[task.setvariable variable=DssApiVersion;isOutput=$IsOutput]$($Matches[1])"
    if ($PSCmdlet.ParameterSetName -eq "Release") {

        $Output = Write-FunctionAppName -NameParts $NameParts -RegExMatches $Matches -FunctionAppSuffix $FunctionAppSuffix
        Write-Output $Output

    }

}
elseif ($BranchName -match $V2OrHigherFeatureBranchRegEx) {

    Write-Verbose -Message "$BranchName is a version 2 or higher feature branch"
    Write-Output "##vso[task.setvariable variable=FunctionAppVersion;isOutput=$IsOutput]Version2+"
    Write-Output "##vso[task.setvariable variable=DssApiVersion;isOutput=$IsOutput]$($Matches[1])"
    if ($PSCmdlet.ParameterSetName -eq "Release") {

        $Output = Write-FunctionAppName -NameParts $NameParts -RegExMatches $Matches -FunctionAppSuffix $FunctionAppSuffix
        Write-Output $Output
        
    }

}
elseif ($BranchName -match "merge") {

    Write-Verbose -Message "This build was triggered by a pull request"
    if ($PullRequestBranchName -match $V1MasterBranchRegEx) {

        Write-Output "##vso[task.setvariable variable=FunctionAppVersion;isOutput=$IsOutput]Version1"

    }
    elseif ($PullRequestBranchName -match $V1FeatureBranchRegEx) {

        Write-Output "##vso[task.setvariable variable=FunctionAppVersion;isOutput=$IsOutput]Version1"

    }
    elseif ($PullRequestBranchName -match $V2OrHigherMasterBranchRegEx) {

        Write-Output "##vso[task.setvariable variable=FunctionAppVersion;isOutput=$IsOutput]Version2+"

    }
    elseif ($PullRequestBranchName -match $V2OrHigherFeatureBranchRegEx) {

        Write-Output "##vso[task.setvariable variable=FunctionAppVersion;isOutput=$IsOutput]Version2+"
        
    }

}
else {

    throw "$BranchName doesn't conform to the branch naming rules and will not build"
}

