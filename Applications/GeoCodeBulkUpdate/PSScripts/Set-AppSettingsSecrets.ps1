[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("at", "test", "pp", "prd", "oat")]
    $Environment = "at"
)

$AppSettings = Get-Content -Path $PSScriptRoot\..\..\GeoCodeBulkUpdate\GeoCodeBulkUpdate\appsettings.json

$mapsKeys = Invoke-AzResourceAction -Action listKeys -ResourceType "Microsoft.Maps/accounts" -ApiVersion "2018-05-01" -ResourceGroupName "dss-at-shared-rg" -ResourceName "dss-at-shared-maps" -Force
$AzureMapSubscriptionKey = $mapsKeys.secondaryKey

$CdbConnStrs = Invoke-AzResourceAction -Action listConnectionStrings -ResourceType "Microsoft.DocumentDb/databaseAccounts" -ApiVersion "2015-04-08" -ResourceGroupName "dss-$Environment-shared-rg" -ResourceName "dss-$Environment-shared-cdb" -Force
$CosmosDBConnectionString = $cdbConnStrs.connectionStrings[1].connectionString

$AppSettings = $AppSettings.Replace("__AzureMapSubscriptionKey__", $AzureMapSubscriptionKey)
$AppSettings = $AppSettings.Replace("__CosmosDBConnectionString__", $CosmosDBConnectionString)

Set-Content -Path $PSScriptRoot\..\..\GeoCodeBulkUpdate\GeoCodeBulkUpdate\appsettings.json -Value $AppSettings