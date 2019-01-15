<#

    .SUMMARY
    Gets the document count from all the collections contained within the DSS CosmosDb account

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
    [string]$SecondaryCosmosKey
)

$SecureKey = ConvertTo-SecureString -String $SecondaryCosmosKey -AsPlainText -Force

foreach ($Database in $Databases) {

    $CosmosDbContext = New-CosmosDbContext -Account $CosmosAccountName  -Database $Database -Key $SecureKey
    $CollectionSize = Get-CosmosDbCollectionSize -Context $CosmosDbContext -Id $Database
    "$Database : $($CollectionSize.documentsCount)"

}