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

}

Push-Location -Path $PSScriptRoot