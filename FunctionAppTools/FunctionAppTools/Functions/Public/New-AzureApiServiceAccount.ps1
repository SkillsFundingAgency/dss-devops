function New-AzureApiServiceAccount {
    param (
        $SubscriptionName,
        $AppName,
        [System.Security.SecureString]$AppPassword,
        [ValidateSet("Owner", "Reader", "Contributor")]
        $RoleType
    )

    # Intial logon to Azure AD and Global objects creation #
    Connect-AzAccount
    $Subscription = Get-AzSubscription -SubscriptionName $SubscriptionName | Set-AzContext
    Write-Host "Azure TenantId $($Subscription.Tenant.TenantId)" -ForegroundColor Yellow
    Write-Host "Azure AccountID $($Subscription.Account.Id)" -ForegroundColor Yellow
    Write-Host "Azure Subscription Name $($Subscription.Name)" -ForegroundColor Yellow

    # New Azure AD application object, it will provide identity to access Azure Active Directory
    $ADAppHomePage = "http://$AppName"

    # check the existance of the application and create one if it does not exist
    if (!($ADApp = Get-AzADApplication -IdentifierUri $ADAppHomePage -ErrorAction SilentlyContinue)) {
        $ADApp = New-AzADApplication -DisplayName $AppName -HomePage $ADAppHomePage -IdentifierUri $ADAppHomePage -Password $AppPassword
    }
    
    # Now create a Service Principal for App
    if (!($ADAppServicePrincipal = Get-AzADServicePrincipal -DisplayNameBeginsWith $ADApp.DisplayName -ErrorAction SilentlyContinue)) {
        $ADAppServicePrincipal = New-AzADServicePrincipal -ApplicationId $ADApp.ApplicationId
        Write-Host "Service Principal $($ADAppServicePrincipal.DisplayName) created with GUID $($ADAppServicePrincipal.Id) created" -ForegroundColor Yellow
    }

    # Assign that Service Principal a role in the AAD tenant, can be scoped to single Resource Group or entire Subscription
    try{
        # Assign to the entire subscription level #
        Start-Sleep -Seconds 15
        New-AzRoleAssignment -RoleDefinitionName $RoleType -ApplicationId $($ADApp.ApplicationId) -ErrorAction Stop
        Write-Host "Assigned $RoleType role at Service Principal $($ADAppServicePrincipal.DisplayName) on Subscription $SubscriptionName" -ForegroundColor Yellow
    }
    catch{
        Write-Output "Error creating Role Assignment!"
    }
}




