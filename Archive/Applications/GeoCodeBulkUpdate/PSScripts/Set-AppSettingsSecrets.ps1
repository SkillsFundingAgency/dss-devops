[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("at", "test", "pp", "prd", "oat")]
    $Environment = "at"
)

$AppSettings = Get-Content -Path $PSScriptRoot\..\..\GeoCodeBulkUpdate\GeoCodeBulkUpdate\appsettings.json

try {
    $mapsKeys = Invoke-AzResourceAction -Action listKeys -ResourceType "Microsoft.Maps/accounts" -ApiVersion "2018-05-01" -ResourceGroupName "dss-$Environment-shared-rg" -ResourceName "dss-$Environment-shared-maps" -Force
    $AzureMapSubscriptionKey = $mapsKeys.secondaryKey
}
catch {
    Write-Host "Unable to retrieve Azure Maps key"
}

try {
    $CdbConnStrs = Invoke-AzResourceAction -Action listConnectionStrings -ResourceType "Microsoft.DocumentDb/databaseAccounts" -ApiVersion "2015-04-08" -ResourceGroupName "dss-$Environment-shared-rg" -ResourceName "dss-$Environment-shared-cdb" -Force
    $CosmosDBConnectionString = $cdbConnStrs.connectionStrings[1].connectionString
}
catch {
    Write-Host "Unable to retrieve CosmosDb connection string"
}


$AppSettings = $AppSettings.Replace("__AzureMapSubscriptionKey__", $AzureMapSubscriptionKey)
$AppSettings = $AppSettings.Replace("__CosmosDBConnectionString__", $CosmosDBConnectionString)

Set-Content -Path $PSScriptRoot\..\..\GeoCodeBulkUpdate\GeoCodeBulkUpdate\appsettings.json -Value $AppSettings