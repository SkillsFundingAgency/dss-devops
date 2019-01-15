<#

    .SUMMARY
    Restores a backup file created using Backup-CosmosDbAccount to a CosmosDb collection.  Assumes that collections and databases are identically named as in DSS project.

    .NOTES
    Requires https://cosmosdbportalstorage.blob.core.windows.net/datamigrationtool/2018.02.28-1.8.1/dt-1.8.1.zip to be extracted to C:\Program Files (x86)\AzureCosmosDBDataMigrationTool\

#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$CosmosAccountName,
    [Parameter(Mandatory=$true)]
    [string]$Database,
    [Parameter(Mandatory=$true)]
    [string]$SecondaryCosmosKey,
    [Parameter(Mandatory=$true)]
    [string]$ContainerUrl,
    [Parameter(Mandatory=$true)]
    [string]$BackupFileName,
    [Parameter(Mandatory=$true)]
    [string]$SecondaryStorageKey,
    [Parameter(Mandatory=$false)]
    [bool]$UpdateExisting = $false
)

##TO DO: validate backup file

if ($UpdateExisting) {

    $UpdtExstng = "/t.UpdateExisting "

}

$UrlParts = $ContainerUrl.Replace('https://', '').Split("/")
$UrlParts[0] += ":443"
$ContainerUrlPort = $UrlParts -join "/"

$parameters = "/s:JsonFile /s.Files:blobs://$SecondaryStorageKey@$ContainerUrlPort/$BackupFileName /t:DocumentDBBulk /t.ConnectionString:AccountEndpoint=https://$CosmosAccountName.documents.azure.com:443/;AccountKey=$SecondaryCosmosKey;Database=$Database $UpdtExstng/t.Collection:$Database"
Write-Verbose "Parameters: $parameters"
$cmd = 'C:\Program Files (x86)\AzureCosmosDBDataMigrationTool\dt.exe'
$params = $parameters.Split(" ")
& $cmd $params