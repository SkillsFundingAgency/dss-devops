<#

    .SUMMARY
    Exports documents from CosmosDb collections to Azure Storage blob.  Assumes that collections and databases are identically named as in DSS project.

    .NOTES
    Requires https://cosmosdbportalstorage.blob.core.windows.net/datamigrationtool/2018.02.28-1.8.1/dt-1.8.1.zip to be extracted to C:\Program Files (x86)\AzureCosmosDBDataMigrationTool\

#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$CosmosAccountName,
    [Parameter(Mandatory=$false)]
    [array]$Databases = @("actionplans", "actions", "addresses", "adviserdetails", "contacts", "customers", "diversitydetails", "goals", "interactions", "outcomes", "sessions", "subscriptions", "transfers", "webchats"),
    [Parameter(Mandatory=$true)]
    [string]$SecondaryCosmosKey,
    [Parameter(Mandatory=$true)]
    [string]$ContainerUrl,
    [Parameter(Mandatory=$true)]
    [string]$SecondaryStorageKey
)

foreach ($Database in $Databases) {
    
    Write-Verbose -Message "Backing up collection $Database"
    $parameters = "/s:DocumentDB /s.ConnectionString:AccountEndpoint=https://$CosmosAccountName.documents.azure.com:443/;AccountKey=$SecondaryCosmosKey;Database=$Database /s.Collection:$Database /t:JsonFile /t.File:blobs://$SecondaryStorageKey@$($ContainerUrl.Replace('https://', ''))/$([DateTime]::Now.ToString("yyyy-MM-dd_HHmm"))-$Database-backup.json"
    Write-Verbose -Message "Parameters: $parameters"
    $cmd = 'C:\Program Files (x86)\AzureCosmosDBDataMigrationTool\dt.exe'
    $params = $parameters.Split(" ")
    & $cmd $params

}