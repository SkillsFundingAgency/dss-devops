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
        @{ BranchName = "master"; PipelineType = "Build"; ExpectedOutputType = "true" }
        @{ BranchName = "master"; PipelineType = "Release"; ExpectedOutputType = "false" }
        @{ BranchName = "CDS-101-ThisIsAChangeToV1"; PipelineType = "Build"; ExpectedOutputType = "true" }
        @{ BranchName = "CDS-101-ThisIsAChangeToV1"; PipelineType = "Release"; ExpectedOutputType = "false" }
    ) {
        param ($BranchName, $PipelineType, $ExpectedOutputType)

        $Expected = "##vso[task.setvariable variable=FunctionAppVersion;isOutput=$ExpectedOutputType]Version1"

        $Output = .\Test-BranchName -BranchName $BranchName -PipelineType $PipelineType
        $Output | Should be $Expected
    }

    It "Should write Version2+ given a valid version 2 or higher branch name" -TestCases @(
        @{ BranchName = "master-v2"; PipelineType = "Build"; ExpectedOutputType = "true" }
        @{ BranchName = "master-v2"; PipelineType = "Release"; ExpectedOutputType = "false" }
        @{ BranchName = "master-v3"; PipelineType = "Build"; ExpectedOutputType = "true" }
        @{ BranchName = "master-v3"; PipelineType = "Release"; ExpectedOutputType = "false" }
        @{ BranchName = "CDS-321-ThisIsAChangeToV2-v2"; PipelineType = "Build"; ExpectedOutputType = "true" }
        @{ BranchName = "CDS-321-ThisIsAChangeToV2-v2"; PipelineType = "Release"; ExpectedOutputType = "false" }
        @{ BranchName = "CDS-456-ThisIsAChangeToV3-v3"; PipelineType = "Build"; ExpectedOutputType = "true" }
        @{ BranchName = "CDS-456-ThisIsAChangeToV3-v3"; PipelineType = "Release"; ExpectedOutputType = "false" }
    ) {
        param ($BranchName, $PipelineType, $ExpectedOutputType)

        $Expected = "##vso[task.setvariable variable=FunctionAppVersion;isOutput=$ExpectedOutputType]Version2+"

        $Output = .\Test-BranchName -BranchName $BranchName -PipelineType $PipelineType
        $Output | Should be $Expected
    }

    It "Should write FunctionAppVersion and FunctionAppName given a valid FunctionAppBaseName" -TestCases @(
        @{ BranchName = "master"; PipelineType = "Build"; FunctionAppBaseName = "dss-at-foo-fa"; ExpectedOutputType = "true"; ApiVersion = "v1"; FunctionAppVersion = "Version1" }
        @{ BranchName = "master-v2"; PipelineType = "Release"; FunctionAppBaseName = "dss-at-foo-fa"; ExpectedOutputType = "false"; ApiVersion = "v2"; FunctionAppVersion = "Version2+" }
        @{ BranchName = "CDS-101-ThisIsAChangeToV1"; PipelineType = "Build"; FunctionAppBaseName = "dss-at-foo-fa"; ExpectedOutputType = "true"; ApiVersion = "v1"; FunctionAppVersion = "Version1" }
        @{ BranchName = "CDS-456-ThisIsAChangeToV3-v3"; PipelineType = "Release"; FunctionAppBaseName = "dss-at-foo-fa"; ExpectedOutputType = "false"; ApiVersion = "v3"; FunctionAppVersion = "Version2+" }
    ) {
        param ($BranchName, $PipelineType, $ExpectedOutputType, $ApiVersion, $FunctionAppVersion)

        $FunctionAppName = "dss-at-foo-$ApiVersion-fa"
        $Expected = @("##vso[task.setvariable variable=FunctionAppVersion;isOutput=$ExpectedOutputType]$($FunctionAppVersion)",
            "##vso[task.setvariable variable=FunctionAppName;isOutput=$ExpectedOutputType]$FunctionAppName")

        $Output = .\Test-BranchName -BranchName $BranchName -PipelineType $PipelineType -FunctionAppBaseName "dss-at-foo-fa"
        $Output | Should be $Expected
    }

}

Push-Location -Path $PSScriptRoot