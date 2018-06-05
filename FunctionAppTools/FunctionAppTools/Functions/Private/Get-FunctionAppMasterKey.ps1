
 
#functions definations

function Test-LoggedIn {
    $needLogin = $true
    Try 
    {
        $content = Get-AzureRmContext
        if ($content) 
        {
            $needLogin = ([string]::IsNullOrEmpty($content.Account))
        } 
    } 
    Catch 
    {
        if ($_ -like "*Login-AzureRmAccount to login*") 
        {
            $needLogin = $true
        } 
        else 
        {
            throw
        }
    }

    if ($needLogin)
    {
        Login-AzureRmAccount
    }
}
#function to get publishing profile
 function Get-PublishingProfileCredentialsAzure($resourceGroupName, $functionAppName){   
 
    $resourceType = "Microsoft.Web/sites/config"
    $resourceName = "$functionAppName/publishingcredentials"
 
    $publishingCredentials = Invoke-AzureRmResourceAction -ResourceGroupName $resourceGroupName -ResourceType $resourceType -ResourceName $resourceName -Action list -ApiVersion 2015-08-01 -Force
 
    return $publishingCredentials
}
 
#function to get bearer token from publishing profile
function Get-KuduApiAuthorisationHeaderValueAzure($resourceGroupName, $functionAppName){
 
    $publishingCredentials = Get-PublishingProfileCredentialsAzure $resourceGroupName $functionAppName
 
    return ("Basic {0}" -f [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $publishingCredentials.Properties.PublishingUserName, $publishingCredentials.Properties.PublishingPassword))))
}

#function to get the Master Key using End point and passing bearer tocken in Authorization Header
function Get-MasterAPIKey($kuduApiAuthorisationToken, $functionAppName ){
 
    $apiUrl = "https://$functionAppName.scm.azurewebsites.net/api/functions/admin/masterkey"
    
    $result = Invoke-RestMethod -Uri $apiUrl -Headers @{"Authorization"=$kuduApiAuthorisationToken;"If-Match"="*"} 
     
    return $result
}
 
#function to get the Admin keys
function Get-HostAPIKeys($kuduApiAuthorisationToken, $functionAppName, $masterKey ){
     $masterKey
     $apiUrl2 = "https://$functionAppName.azurewebsites.net/admin/host/keys?code="
     $apiUrl=$apiUrl2 + $masterKey.masterKey.ToString()
     $apiUrl
     $result = Invoke-WebRequest $apiUrl
    return $result
}

#Get and print the accesstocken
function Get-FunctionAppMasterKey{
    param(
        $ResourceGroupName,
        $FunctionAppName 
    )

    #login to account if not running from VSTS
    if (!$env:MSDEPLOY_HTTP_USER_AGENT) {
        Test-LoggedIn
    }

    $accessToken = Get-KuduApiAuthorisationHeaderValueAzure $resourceGroupName $functionAppName
    #$accessToken
    
    #get master key
    $masterKey=Get-MasterAPIKey $accessToken $functionAppName
    
    #get host key
    $allkeys=Get-HostAPIKeys $accessToken $functionAppName $masterkey
    $MasterKey = $allkeys[0].masterKey
    $MasterKey
}

 
