<#
    .SUMMARY
    Get and print the accesstocken
#>
function Get-FunctionAppMasterKey{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        $ResourceGroupName,
        [Parameter(Mandatory=$true)]
        $FunctionAppName,
        [Parameter(Mandatory=$true)]
        $FunctionAppDomain 
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
    $MasterKey = $AllKeys[0].masterKey
    $MasterKey
}

Get-FunctionAppMasterkey -ResourceGroupName "dss-at-cust-rg" -FunctionAppName "dss-at-cust-fa" -FunctionAppDomain "azurewebsites.net"

 
