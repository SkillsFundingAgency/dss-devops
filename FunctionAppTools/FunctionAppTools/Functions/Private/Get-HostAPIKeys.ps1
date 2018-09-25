<#
    .SUMMARY
    Function to get the Admin keys
#>
function Get-HostAPIKeys{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        $FunctionAppName,
        [Parameter(Mandatory=$true)]
        $FunctionAppDomain,
        [Parameter(Mandatory=$true)]
        $MasterKey
    )

    $ApiUrl = "https://$FunctionAppName.$FunctionAppDomain/admin/host/keys?code=$($MasterKey.masterKey.ToString())"

    $Result = Invoke-WebRequest $ApiUrl -UseBasicParsing

    return $Result
}