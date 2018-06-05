function Enable-Swagger {
    param(
        $FunctionAppName
    )
    ##TO DO: get $Token
    $Uri = "https://$FunctionAppName.scm.azurewebsites.net/api/functions/config"
    $Body = '{"swagger": {"enabled": true}}'
    Invoke-RestMethod -Method PUT -Headers @{'authorization'="Bearer $($Token.access_token)"} -Uri $Uri -Body $Body -ContentType application/json
}
