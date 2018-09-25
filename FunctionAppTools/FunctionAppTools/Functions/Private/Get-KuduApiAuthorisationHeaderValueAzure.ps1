<#
    .SUMMARY 
    Function to get bearer token from publishing profile
#>
function Get-KuduApiAuthorisationHeaderValueAzure{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]    
        $ResourceGroupName,
        [Parameter(Mandatory=$true)]
        $FunctionAppName
    )
 
    $PublishingCredentials = Get-PublishingProfileCredentialsAzure -ResourceGroupName $ResourceGroupName -FunctionAppName $FunctionAppName
 
    return ("Basic {0}" -f [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $PublishingCredentials.Properties.PublishingUserName, $PublishingCredentials.Properties.PublishingPassword))))
}