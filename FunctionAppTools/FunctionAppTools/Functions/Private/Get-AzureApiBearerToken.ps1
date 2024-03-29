﻿function Get-AzureApiBearerToken {
  [CmdletBinding()]
  param (
    $SubscriptionName,
    $ApplicationId,
    [System.Security.SecureString]$AppPassword
  )

  Write-Host "Logging preference: $VerbosePreference"

  $Subscription = Get-AzSubscription -SubscriptionName $SubscriptionName
  
  Write-Verbose -Message "SubscriptionId: $($Subscription.Id)"
  Write-Verbose "Logged on account: $($Subscription.ExtendedProperties.Account)"

  try {

    $ADDomainName = $Subscription.ExtendedProperties.Account.Split('@')[1]
    Write-Verbose -Message $ADDomainName
    $ADAppUserName = "$ApplicationId@$ADDomainName"
    Write-Verbose -Message $ADAppUserName
    $ADAppCredential = New-Object -TypeName pscredential -ArgumentList $ADAppUserName, $AppPassword
    Write-Host "AAD Credendial created...." -ForegroundColor Yellow 

  }
  catch {

    throw "Error creating AAD Credential.`n$($Error[0])"

  }

  Connect-AzAccount -Credential $ADAppCredential -ServicePrincipal -TenantId $Subscription.TenantId -Subscription $SubscriptionName
  
  $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($AppPassword)
  $UnsecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

  $Body = @{
    'resource'= "https://management.core.windows.net/"
    'client_id' = $ApplicationId
    'grant_type' = 'client_credentials'
    'client_secret' = $UnsecurePassword
  }
  Write-Verbose $Body

  $TokenEndpoint = {https://login.windows.net/{0}/oauth2/token} -f $Subscription.TenantId
  Write-Verbose $TokenEndpoint

  $Params = @{
      ContentType = 'application/x-www-form-urlencoded'
      Headers = @{'accept'='application/json'}
      Body = $Body
      Method = 'Post'
      URI = $TokenEndpoint
      UseBasicParsing = $true
  }
  Write-Verbose $Params

  $Token = Invoke-RestMethod @Params
  # Show the raw token and expiration date converted in readable format: #
  $Token | Select-Object *, @{L='Expires';E={[timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($_.expires_on))}} | Format-List *
}

