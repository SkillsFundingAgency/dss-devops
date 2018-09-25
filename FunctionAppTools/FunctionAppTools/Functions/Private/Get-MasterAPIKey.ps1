<#
    .SUMMARY 
    Function to get the Master Key using End point and passing bearer tocken in Authorization Header
#>
function Get-MasterAPIKey{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]    
        $KuduApiAuthorisationToken,
        [Parameter(Mandatory=$true)]
        $FunctionAppName,
        [Parameter(Mandatory=$true)]
        $FunctionAppDomain
    )
 
    $ApiUrl = "https://$FunctionAppName.scm.$FunctionAppDomain/api/functions/admin/masterkey"
    
    $Result = Invoke-RestMethod -Uri $ApiUrl -Headers @{"Authorization"=$KuduApiAuthorisationToken;"If-Match"="*"} -UseBasicParsing
     
    return $Result
}