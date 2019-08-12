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
    [Parameter(Mandatory=$true, ParameterSetName="ContainerSasToken")]
    [string]$ContainerSasToken,
    [Parameter(Mandatory=$true)]
    [string]$ContainerUrl,
    [Parameter(Mandatory=$true)]
    [string]$BackupFileName,
    [Parameter(Mandatory=$true, ParameterSetName="StorageAccountKey")]
    [string]$SecondaryStorageKey,
    [Parameter(Mandatory=$false)]
    [string]$DataMigrationToolLocation = 'C:\Program Files (x86)\AzureCosmosDBDataMigrationTool\dt.exe',
    [Parameter(Mandatory=$false)]
    [bool]$UpdateExisting = $false
)

##TO DO: validate backup file

if ($UpdateExisting) {

    $UpdtExstng = "/t.UpdateExisting "

}

if ($PSCmdlet.ParameterSetName -eq "StorageAccountKey") {

    $UrlParts = $ContainerUrl.Replace('https://', '').Split("/")
    $UrlParts[0] += ":443"
    $ContainerUrlPort = $UrlParts -join "/"

    $FileUri = "blobs://$SecondaryStorageKey@$ContainerUrlPort/$BackupFileName"

}
elseif ($PSCmdlet.ParameterSetName -eq "ContainerSasToken") {

    $FileUri = "$ContainerUrl/$BackupFileName$ContainerSasToken"

}

$parameters = "/s:JsonFile /s.Files:$FileUri /t:DocumentDBBulk /t.ConnectionString:AccountEndpoint=https://$CosmosAccountName.documents.azure.com:443/;AccountKey=$SecondaryCosmosKey;Database=$Database $UpdtExstng/t.Collection:$Database"
Write-Debug "Parameters: $parameters"
$cmd = $DataMigrationToolLocation
$params = $parameters.Split(" ")
& $cmd $params
