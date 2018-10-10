<#
    .SUMMARY
    Reset a function app host key
    .DESCRIPTION
    Resets and returns a function app host key
    .OUTPUT
    Returns the new key value
    .NOTES
    https://github.com/Azure/azure-functions-host/wiki/Key-management-API

#>
function Set-FunctionAppHostKey {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        $ResourceGroupName,
        [Parameter(Mandatory=$true)]
        $FunctionAppName,
        [Parameter(Mandatory=$true)]
        $FunctionAppDomain,
        [Parameter(Mandatory=$true)]
        $KeyName,
        [Parameter(Mandatory=$false)]
        $KeyValue
    )

    # Login to account if not running from VSTS
    if (!$env:MSDEPLOY_HTTP_USER_AGENT) {
        Test-LoggedIn
    }

    Write-Verbose "Resetting key value for host key $KeyName"

    Write-Verbose "Retrieving access token"
    $AccessToken = Get-KuduApiAuthorisationHeaderValueAzure -ResourceGroupName $ResourceGroupName -FunctionAppName $FunctionAppName

    Write-Verbose "Retrieving master key"
    $MasterKey = Get-MasterAPIKey -KuduApiAuthorisationToken $AccessToken -FunctionAppName $FunctionAppName -FunctionAppDomain $FunctionAppDomain

    $Uri = "https://$FunctionAppName.$FunctionAppDomain/admin/host/keys/$($KeyName)?code=$($MasterKey.masterKey.ToString())"
    Write-Verbose "Invoking REST method: $Uri"

    if (!$KeyValue) {

        $Result = Invoke-RestMethod -Method POST -Uri $Uri -UseBasicParsing

    } 
    else {

        $Body = @{
            "name" = $KeyName
            "value" = $KeyValue
        }
        $Result = Invoke-RestMethod -Method POST -Uri $Uri -UseBasicParsing -Body $Body

    }

    $Result.value

}