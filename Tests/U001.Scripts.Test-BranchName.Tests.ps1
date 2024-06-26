Push-Location -Path $PSScriptRoot\..\Scripts\
Describe "Test-BranchName unit tests" -Tag "Unit" {

    It "Should should throw an error given an invalid branch name" -TestCases @(
        @{ BranchName = 'master-va'}
        @{ BranchName = 'ABC-123-ThisIsAChange-v2'}
        @{ BranchName = 'CDS-123-ThisIsAChange-va'}
        @{ BranchName = 'CDS-ThisIsAChange-v2'}
    ) {
        param ($BranchName)
        { .\Test-BranchName -BranchName $BranchName -PipelineType Build } | Should -Throw

    }

    It "Should write Version1 given a valid version 1 branch name" -TestCases @(
        @{ BranchName = "master"; PipelineType = "Build"; ExpectedOutputType = "true"; DssApiVersion = "" }
        @{ BranchName = "master"; PipelineType = "Release"; ExpectedOutputType = "false"; DssApiVersion = "" }
        @{ BranchName = "CDS-101-ThisIsAChangeTo-V1"; PipelineType = "Build"; ExpectedOutputType = "true"; DssApiVersion = "" }
        @{ BranchName = "CDS-101-ThisIsAChangeTo-V1"; PipelineType = "Release"; ExpectedOutputType = "false"; DssApiVersion = "" }
        @{ BranchName = "DSS-Release-1-v1"; PipelineType = "Build"; ExpectedOutputType = "true"; DssApiVersion = "" }
        @{ BranchName = "DSS-Release-1-v1"; PipelineType = "Release"; ExpectedOutputType = "false"; DssApiVersion = "" }
        @{ BranchName = "DSS-Release-Sprint-22-v1"; PipelineType = "Build"; ExpectedOutputType = "true"; DssApiVersion = "" }
        @{ BranchName = "DSS-Release-Sprint-22-v1"; PipelineType = "Release"; ExpectedOutputType = "false"; DssApiVersion = "" }
    ) {
        param ($BranchName, $PipelineType, $ExpectedOutputType, $DssApiVersion)

        $Expected = @("##vso[task.setvariable variable=FunctionAppVersion;isOutput=$ExpectedOutputType]Version1",
            "##vso[task.setvariable variable=DssApiVersion;isOutput=$ExpectedOutputType]$DssApiVersion")

        $Output = ..\Scripts\Test-BranchName -BranchName $BranchName -PipelineType $PipelineType
        $Output | Should -be $Expected
    }

    It "Should write Version2+ given a valid version 2 or higher branch name" -TestCases @(
        @{ BranchName = "master-v2"; PipelineType = "Build"; ExpectedOutputType = "true"; DssApiVersion = "v2" }
        @{ BranchName = "master-v2"; PipelineType = "Release"; ExpectedOutputType = "false"; DssApiVersion = "v2" }
        @{ BranchName = "master-v3"; PipelineType = "Build"; ExpectedOutputType = "true"; DssApiVersion = "v3" }
        @{ BranchName = "master-v3"; PipelineType = "Release"; ExpectedOutputType = "false"; DssApiVersion = "v3" }
        @{ BranchName = "CDS-321-ThisIsAChangeToV2-v2"; PipelineType = "Build"; ExpectedOutputType = "true"; DssApiVersion = "v2" }
        @{ BranchName = "CDS-321-ThisIsAChangeToV2-v2"; PipelineType = "Release"; ExpectedOutputType = "false"; DssApiVersion = "v2" }
        @{ BranchName = "CDS-456-ThisIsAChangeToV3-v10"; PipelineType = "Build"; ExpectedOutputType = "true"; DssApiVersion = "v10" }
        @{ BranchName = "CDS-456-ThisIsAChangeToV3-v10"; PipelineType = "Release"; ExpectedOutputType = "false"; DssApiVersion = "v10" }
        @{ BranchName = "CDS-456-ThisIsAChangeToV3-v10"; PipelineType = "Release"; ExpectedOutputType = "false"; DssApiVersion = "v10" }
        @{ BranchName = "DSS-Release-1-v3"; PipelineType = "Release"; ExpectedOutputType = "false"; DssApiVersion = "v3" }
        @{ BranchName = "DSS-Release-1-v3"; PipelineType = "Build"; ExpectedOutputType = "true"; DssApiVersion = "v3" }
        @{ BranchName = "DSS-Release-Sprint-22-v3"; PipelineType = "Build"; ExpectedOutputType = "true"; DssApiVersion = "v3" }
        @{ BranchName = "DSS-Release-Sprint-22-v3"; PipelineType = "Release"; ExpectedOutputType = "false"; DssApiVersion = "v3" }
    ) {
        param ($BranchName, $PipelineType, $ExpectedOutputType, $DssApiVersion)

        $Expected = @("##vso[task.setvariable variable=FunctionAppVersion;isOutput=$ExpectedOutputType]Version2+",
        "##vso[task.setvariable variable=DssApiVersion;isOutput=$ExpectedOutputType]$DssApiVersion")

        $Output = ..\Scripts\Test-BranchName -BranchName $BranchName -PipelineType $PipelineType
        $Output | Should -be $Expected
    }

    It "Should write FunctionAppVersion and FunctionAppName given a valid FunctionAppBaseName" -TestCases @(
        @{ BranchName = "master"; PipelineType = "Release"; FunctionAppBaseName = "dss-at-foo-fa"; DssApiVersion = ""; FunctionAppVersion = "Version1"; FunctionAppName = "dss-at-foo-v1-fa"; FunctionAppSuffix = "" }
        @{ BranchName = "master-v2"; PipelineType = "Release"; FunctionAppBaseName = "dss-at-foo-fa"; DssApiVersion = "v2"; FunctionAppVersion = "Version2+"; FunctionAppName = "dss-at-foo-v2-fa"; FunctionAppSuffix = "" }
        @{ BranchName = "CDS-101-ThisIsAChangeTo-V1"; PipelineType = "Release"; FunctionAppBaseName = "dss-at-foo-fa"; DssApiVersion = ""; FunctionAppVersion = "Version1"; FunctionAppName = "dss-at-foo-v1-fa"; FunctionAppSuffix = "" }
        @{ BranchName = "CDS-456-ThisIsAChangeToV3-v3"; PipelineType = "Release"; FunctionAppBaseName = "dss-at-foo-fa"; DssApiVersion = "v3"; FunctionAppVersion = "Version2+"; FunctionAppName = "dss-at-foo-v3-fa"; FunctionAppSuffix = "" }
    
        @{ BranchName = "master"; PipelineType = "Release"; FunctionAppBaseName = "dss-at-foo-fa"; DssApiVersion = ""; FunctionAppVersion = "Version1"; FunctionAppName = "dss-at-foo-v1-fa-ver2"; FunctionAppSuffix = "ver2"}
        @{ BranchName = "master-v2"; PipelineType = "Release"; FunctionAppBaseName = "dss-at-foo-fa"; DssApiVersion = "v2"; FunctionAppVersion = "Version2+"; FunctionAppName = "dss-at-foo-v2-fa-ver2"; FunctionAppSuffix = "ver2" }
        @{ BranchName = "CDS-101-ThisIsAChangeTo-V1"; PipelineType = "Release"; FunctionAppBaseName = "dss-at-foo-fa"; DssApiVersion = ""; FunctionAppVersion = "Version1"; FunctionAppName = "dss-at-foo-v1-fa-ver2"; FunctionAppSuffix = "ver2" }
        @{ BranchName = "CDS-456-ThisIsAChangeToV3-v3"; PipelineType = "Release"; FunctionAppBaseName = "dss-at-foo-fa"; DssApiVersion = "v3"; FunctionAppVersion = "Version2+"; FunctionAppName = "dss-at-foo-v3-fa-ver2"; FunctionAppSuffix = "ver2" }
    ) {
        param ($BranchName, $PipelineType, $DssApiVersion, $FunctionAppVersion, $FunctionAppName, $FunctionAppSuffix)

        $Expected = @("##vso[task.setvariable variable=FunctionAppVersion;isOutput=false]$FunctionAppVersion",
            "##vso[task.setvariable variable=DssApiVersion;isOutput=false]$DssApiVersion",
            "##vso[task.setvariable variable=FunctionAppName;isOutput=false]$FunctionAppName")

            $Output = ..\Scripts\Test-BranchName -BranchName $BranchName -PipelineType $PipelineType -FunctionAppBaseName "dss-at-foo-fa" -FunctionAppSuffix $FunctionAppSuffix
            $Output | Should -be $Expected
            Write-Output $Output
    }

    it "Should write FunctionAppVersion based on the PullRequestBranchName param if BranchName is merge" -TestCases @(
        @{ BranchName = "merge"; PipelineType = "Build"; PullRequestBranchName = "master"; ExpectedOutputType = "true"; FunctionAppVersion = "Version1" }
        @{ BranchName = "merge"; PipelineType = "Build"; PullRequestBranchName = "master-v2"; ExpectedOutputType = "true"; FunctionAppVersion = "Version2+" }
        @{ BranchName = "merge"; PipelineType = "Build"; PullRequestBranchName = "CDS-101-ThisIsAChangeTo-V1"; ExpectedOutputType = "true"; FunctionAppVersion = "Version1" }
        @{ BranchName = "merge"; PipelineType = "Build"; PullRequestBranchName = "CDS-456-ThisIsAChangeToV3-v3"; ExpectedOutputType = "true"; FunctionAppVersion = "Version2+" }
    ) {
        param ($BranchName, $PipelineType, $PullRequestBranchName, $ExpectedOutputType, $FunctionAppVersion)

        $Expected = "##vso[task.setvariable variable=FunctionAppVersion;isOutput=$ExpectedOutputType]$($FunctionAppVersion)"

        $Output = ..\Scripts\Test-BranchName -BranchName $BranchName -PipelineType $PipelineType -PullRequestBranchName $PullRequestBranchName
        $Output | Should -be $Expected
    }

}

Push-Location -Path $PSScriptRoot