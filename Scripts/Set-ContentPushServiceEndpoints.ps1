[CmdletBinding()]
param(
    # An array of URIs representing the ABC Endpoints
    [Parameter(Mandatory=$true)]
    [hashtable]$EndpointUris,
    [Parameter(Mandatory=$true)]
    [string]$ContentPushServiceUri,
    [Parameter(Mandatory=$true)]
    [string]$KeyVault,
    [Parameter(Mandatory=$true)]
    [string]$TenantId,
    [Parameter(Mandatory=$true)]
    [string]$AzureAadAdminUserName,
    [Parameter(Mandatory=$true)]
    [string]$AzureAadAdminPwd
)


if (!(Get-Module AzureAd)) {

    if (!(Get-InstalledModule AzureAd -ErrorAction SilentlyContinue)) {

        Install-Module AzureAd -Scope CurrentUser -Force

    }
    Import-Module AzureAd

}

try {

    if(!($ENV:TF_BUILD)) {

        Connect-AzureAD -TenantId $TenantId
    
    }
    else {
    
        $SecurePassword = $AzureAadAdminPwd | ConvertTo-SecureString -AsPlainText -Force
        $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ($AzureAadAdminUserName, $SecurePassword)
        Connect-AzureAD -Credential $Credential -TenantId $TenantId
    
    }

}
catch {

    throw "ERROR: unable to login to Active Directory tenant $TenantId with user $AzureAadAdminUserName`n$($Error[0])"

}

Write-Verbose -Message "Getting AzureAdApplications"
$AdApplications = Get-AzureAdApplication
Write-Verbose -Message "Got AzureAdApplication, found $($AdApplications.Count) applications"

# Create app registrations for DSS endpoints
$Endpoints = @()
foreach ($EndpointUriKey in $EndpointUris.Keys) {

    $EndpointRegistration = $AdApplications | ForEach-Object { $_ | Where-Object { $_.ReplyUrls -eq $EndpointUris[$EndpointUriKey] }}
    Write-Verbose -Message "$($EndpointRegistration.Count) app registrations with ReplyUrls matching $($EndpointUris[$EndpointUriKey]) found"
    if ($EndpointRegistration.Count -gt 1) {

        throw "ERROR: Multiple app registrations matching $($EndpointUris[$EndpointUriKey]) found.  Delete duplicate app registrations."
        
    }
    
    if(!$EndpointRegistration) {

        Write-Verbose -Message "Found no app registration for $($EndpointUris[$EndpointUriKey]), creating app registration"
        $NewAppRegistrationParams = @{
            DisplayName = "$($EndpointUris[$EndpointUriKey].Split("/")[2].ToLower())-endpoint"
            Homepage = $EndpointUris[$EndpointUriKey]
            ReplyUrls = $EndpointUris[$EndpointUriKey]
            IdentifierUris = "https://$((Get-AzureADTenantDetail)[0].VerifiedDomains[0].Name)/$(New-Guid)"
        }
    
        $AppRegistration = New-AzureADApplication @NewAppRegistrationParams
        New-AzureADServicePrincipal -AccountEnabled $true -AppId $AppRegistration.AppId -DisplayName $AppRegistration.DisplayName -Tags {WindowsAzureActiveDirectoryIntegratedApp}
        $Endpoints += $AppRegistration
    
    }
    else {

        # Check ServicePrincipal registered
        Write-Verbose -Message "App registration for $($EndpointUris[$EndpointUriKey]) already exists"
        $ServicePrincipal = Get-AzureADServicePrincipal -SearchString $EndpointRegistration.DisplayName
        if (!$ServicePrincipal) {

            Write-Verbose "Creating ServicePrincipal for $($EndpointRegistration.DisplayName)"
            New-AzureADServicePrincipal -AccountEnabled $true -AppId $EndpointRegistration.AppId -DisplayName $EndpointRegistration.DisplayName -Tags {WindowsAzureActiveDirectoryIntegratedApp}

        }

        # Check if $Endpoints collection already contains an endpoint with this ReplyUrl
        if ($Endpoints | ForEach-Object { $_ | Where-Object { $_.ReplyUrls -eq $EndpointUris[$EndpointUriKey] }}) {

            Write-Verbose -Message "Endpoint registration for ReplyUrl $($EndpointUris[$EndpointUriKey]) already exists in Endpoints collection"

        }
        else {

            Write-Verbose -Message "Adding endpoint registration for ReplyUrl $($EndpointUris[$EndpointUriKey]) to Endpoints collection"
            $Endpoints += $EndpointRegistration

        }
        

    }

}

# Create permissions object
$RequiredResourceAccessList = @()
foreach ($Endpoint in $Endpoints) {

    Write-Verbose -Message "Creating ResourceAccess object for $($Endpoint.DisplayName)"
    $RequiredResourceAccess = New-Object -TypeName "Microsoft.Open.AzureAD.Model.RequiredResourceAccess"
    $RequiredResourceAccess.ResourceAppId = $Endpoint.AppId
    $ResourceAccessId = ($Endpoint.Oauth2Permissions | Where-Object { $_.Value -eq "user_impersonation" }).Id
    $RequiredResourceAccess.ResourceAccess = New-Object -TypeName "Microsoft.Open.AzureAD.Model.ResourceAccess" -ArgumentList $ResourceAccessId, "Scope"
    $RequiredResourceAccessList += $RequiredResourceAccess

}

$ContentPushRegistration =  $AdApplications | ForEach-Object { $_ | Where-Object { $_.ReplyUrls -eq $ContentPushServiceUri }}
if (!$ContentPushRegistration) {

    Write-Verbose -Message "Found no app registration for $ContentPushServiceUri, creating app registration"
    # Register new app with permissions
    $NewAppRegistrationParams = @{
        DisplayName = $ContentPushServiceUri.Split("/")[2].ToLower()
        Homepage = $ContentPushServiceUri
        RequiredResourceAccess = $RequiredResourceAccessList
        ReplyUrls = $ContentPushServiceUri
        IdentifierUris = "https://$((Get-AzureADTenantDetail)[0].VerifiedDomains[0].Name)/$(New-Guid)"
    }
    $ContentPushRegistration = New-AzureADApplication @NewAppRegistrationParams
    New-AzureADServicePrincipal -AccountEnabled $true -AppId $ContentPushRegistration.AppId -DisplayName $ContentPushRegistration.DisplayName -Tags {WindowsAzureActiveDirectoryIntegratedApp}

}
elseif ($ContentPushRegistration.Count -eq 1) {

    Write-Verbose -Message "Found 1 app registration for $ContentPushServiceUri, updating app registration"
    # Set permissions on existing app
    $SetAppRegistrationParams = @{
        ObjectId = $ContentPushRegistration.ObjectId
        RequiredResourceAccess = $RequiredResourceAccessList
    }
    Set-AzureADApplication @SetAppRegistrationParams

    # Check ServicePrincipal registered
    $ServicePrincipal = Get-AzureADServicePrincipal -SearchString $ContentPushRegistration.DisplayName
    if (!$ServicePrincipal) {

        Write-Verbose "Creating ServicePrincipal for $($ContentPushRegistration.DisplayName)"
        New-AzureADServicePrincipal -AccountEnabled $true -AppId $ContentPushRegistration.AppId -DisplayName $ContentPushRegistration.DisplayName -Tags {WindowsAzureActiveDirectoryIntegratedApp}

    }


}
else {

    throw "ERROR: Found more than 1 app registration for $ContentPushServiceUri, exiting"

}

# Create PasswordCredential (API Access Key) and store in KeyVault
$KeyVaultSecretName = "$(($ContentPushRegistration.DisplayName).Replace(".", "-"))-api-key"
$KeyVaultSecret = Get-AzureKeyVaultSecret -VaultName $KeyVault -Name $KeyVaultSecretName -ErrorAction SilentlyContinue
if (!$KeyVaultSecret) {

    if ($ContentPushRegistration.PasswordCredential.Count -ne 0) {
        $ExistingSecret = $ContentPushRegistration.PasswordCredential | ForEach-Object { [System.Text.Encoding]::ASCII.GetString($_.CustomKeyIdentifier) -eq "ContentPushKey"}
    }
    
    if (!$ExistingSecret) {

        Write-Verbose -Message "Creating credential"
        $CredentialObject = New-AzureADApplicationPasswordCredential -ObjectId $ContentPushRegistration.ObjectId -EndDate [DateTime]::new(2299, 12, 31, 0, 0, 0) -CustomKeyIdentifier "ContentPushKey"
        Write-Verbose -Message "Adding credential $KeyVaultSecretName to KeyVault $KeyVault"
        $SecureSecret = $CredentialObject.Value | ConvertTo-SecureString -AsPlainText -Force
        Set-AzureKeyVaultSecret -VaultName $KeyVault -Name $KeyVaultSecretName -SecretValue $SecureSecret

    }

}

# Set VSTS variables
Write-Host "##vso[task.setvariable variable=Authentication_PushServiceClientId]$($ContentPushRegistration.AppId)"
foreach ($EndpointUriKey in $EndpointUris.Keys) {

    $AppIdUri = ($Endpoints | ForEach-Object { $_ | Where-Object { $_.ReplyUrls.Contains($EndpointUris[$EndpointUriKey]) -eq $true } }).IdentifierUris[0]
    Write-Host "##vso[task.setvariable variable=$($EndpointUriKey)_AppIdUri]$AppIdUri" 
    
}