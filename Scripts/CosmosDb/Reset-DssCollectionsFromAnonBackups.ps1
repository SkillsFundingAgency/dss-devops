[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]    
    [DateTime]$DateToRestoreFrom,
    [Parameter(Mandatory=$true)]
    [ValidateSet("at", "test", "pp")]
    [String]$EnvironmentToRestoreTo,
    [Parameter(Mandatory=$true)]
    [String]$DestinationCosmosKey,
    [Parameter(Mandatory=$true)]
    [String]$PathToDfcDevops,
    [Parameter(Mandatory=$true)]
    [String]$PathToDssDevops,
    [Parameter(Mandatory=$true)]
    [String]$SourceStorageKey,
    [Parameter(Mandatory=$true)]
    [String]$SqlServerFqdn,
    [Parameter(Mandatory=$true)]
    [String]$SqlServerPassword,
    [Parameter(Mandatory=$true)]
    [String]$SqlServerUsername
)

function Truncate-SqlTable {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$ConnectionString,
        [Parameter(Mandatory=$true)]
        [string]$TableName
    )

    $Result = Invoke-Sqlcmd -Query "SELECT COUNT(*) FROM [dbo].[$TableName];" -ConnectionString $ConnectionString
    Write-Verbose "$([DateTime]::Now.ToString("dd-MM-yyyy HH:mm:ss")) $TableName contains $($Result.Column1) records"
    Invoke-Sqlcmd -Query "TRUNCATE TABLE [dbo].[$TableName];" -ConnectionString $ConnectionString
    $Result = Invoke-Sqlcmd -Query "SELECT COUNT(*) FROM [dbo].[$TableName];" -ConnectionString $ConnectionString
    Write-Verbose "$([DateTime]::Now.ToString("dd-MM-yyyy HH:mm:ss")) $TableName truncated, contains $($Result.Column1) records"
}

# Source variables (should always be PRD)
$ContainerName = "anon-backups"
$SourceStorageAccount = "dssprdshdarmstr"
$ContainerUrl = "https://$SourceStorageAccount.blob.core.windows.net/$ContainerName"

# Destination variables (should never be PRD.  Validation set and conditions will enforce this)
$DestinationResourceGroup = "dss-$EnvironmentToRestoreTo-shared-rg"
$DestinationCosmosAccount = "dss-$EnvironmentToRestoreTo-shared-cdb"
$DestinationSqlDatabase = "dss-$EnvironmentToRestoreTo-shared-stag-db"

# Get backup files
$SourceStorageContext = New-AzureStorageContext -StorageAccountName $SourceStorageAccount -StorageAccountKey $SourceStorageKey
$AllBackupFiles = Get-AzureStorageBlob -Container $ContainerName -Context $SourceStorageContext | Sort-Object -Property Name -Descending
Write-Verbose "$([DateTime]::Now.ToString("dd-MM-yyyy HH:mm:ss")) Files found: $($AllBackupFiles.Count)"
$FilesToRestoreFrom = @()
foreach ($Blob in $AllBackupFiles) {

    $FileDate = $Blob.Name.Split("_")[0]
    if($FileDate -eq $DateToRestoreFrom.ToString("yyyy-mm-dd")) {

        Write-Verbose "$([DateTime]::Now.ToString("dd-MM-yyyy HH:mm:ss")) Adding $($Blob.Name) to files to restore from"
        $FilesToRestoreFrom += $Blob

    }
    
}

foreach ($BackupFile in $FilesToRestoreFrom) {

    $DatabaseName = $BackupFile.Split("-")[3]
    $CollectionId = $BackupFile.Split("-")[3]
    $SqlTableIdentifier = $BackupFile.Split("-")[3]
    Write-Verbose "$([DateTime]::Now.ToString("dd-MM-yyyy HH:mm:ss")) Reseting database\collection $DatabaseName\$CollectionId"

    # Delete contents of Cosmos collection
    if ($DestinationCosmosAccount -match "-prd-") {

        throw "Requested deletion of Production collection, terminating script"

    }
    Invoke-Expression -Command "$PathToDfcDevops\PSScripts\Remove-CosmosCollectionContents.ps1 -ResourceGroupName $DestinationResourceGroup -CosmosDbAccountName $DestinationCosmosAccount -Database $DatabaseName -CollectionId $CollectionId"

    # Truncate SQL table and history table
    if ($DestinationSqlDatabase -match "-prd-") {

        throw "Requested truncation of Production SQL tables, terminating script"

    }
    $ConnectionString = "Server=tcp:$SqlServerFqdn,1433;Initial Catalog=$DestinationSqlDatabase;Persist Security Info=False;User ID=$SqlServerUsername;Password=$SqlServerPassword;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
    Truncate-SqlTable -ConnectionString $ConnectionString -TableName "dss-$SqlTableIdentifier"
    Truncate-SqlTable -ConnectionString $ConnectionString -TableName "dss-$SqlTableIdentifier-history"

    # Import contents from backup
    Write-Verbose "$([DateTime]::Now.ToString("dd-MM-yyyy HH:mm:ss")) Restoring collection $CollectionId from file $BackupFile"
    Invoke-Expression -Command "$PathToDssDevops\Scripts\CosmosDb\Restore-CosmosDbContainer.ps1 -CosmosAccountName $DestinationCosmosAccount -Database $DatabaseName -SecondaryCosmosKey $DestinationCosmosKey -ContainerUrl $ContainerUrl -BackupFileName $BackupFile -SecondaryStorageKey $SourceStorageKey"

    Write-Verbose "$([DateTime]::Now.ToString("dd-MM-yyyy HH:mm:ss")) Database\collection $DatabaseName\$CollectionId reset"

}

