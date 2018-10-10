<#
    .SUMMARY
    Get and print the access token
#>
function Get-FunctionAppHostKey{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        $ResourceGroupName,
        [Parameter(Mandatory=$true)]
        $FunctionAppName,
        [Parameter(Mandatory=$true)]
        $FunctionAppDomain,
        [Parameter(Mandatory=$false)]
        $KeyName = "default"
    )

    # Login to account if not running from VSTS
    if (!$env:MSDEPLOY_HTTP_USER_AGENT) {
        Test-LoggedIn
    }

    $AccessToken = Get-KuduApiAuthorisationHeaderValueAzure -ResourceGroupName $ResourceGroupName -FunctionAppName $FunctionAppName
    
    # Get master key
    $MasterKey = Get-MasterAPIKey -KuduApiAuthorisationToken $AccessToken -FunctionAppName $FunctionAppName -FunctionAppDomain $FunctionAppDomain
    
    # Get host key
    $AllKeys = Get-HostAPIKeys -FunctionAppName $FunctionAppName -FunctionAppDomain $FunctionAppDomain -MasterKey $Masterkey
    $Key = ($AllKeys | Where-Object { $_.name -eq $KeyName }).value
    $Key
}

 
