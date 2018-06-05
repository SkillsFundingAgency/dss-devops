#Rollback
<#
$AppName = 'registed-ad-application'
$ADApp = Get-AzureRmADApplication -DisplayNameStartWith $AppName
if(!($ADApp | Get-Member -Name Count)){
    $ADAppServicePrincipal = Get-AzureRmADServicePrincipal -SearchString $ADApp.DisplayName
    Remove-AzureRmADServicePrincipal -ObjectId $ADAppServicePrincipal.Id
    $ADApp | Remove-AzureRmADApplication
}
#>