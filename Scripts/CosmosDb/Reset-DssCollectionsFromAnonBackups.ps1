<#

    .SYNOPSIS
    Deletes contents of DSS Cosmos collections and replaces with data from anonymised production backups

    .DESCRIPTION
    Retrieves a backup files from the anon-backup container in the DSS Production environment
    For each backup file:
        1. Deletes the contents of it's CosmosDb collection
        2. Truncates the associated SQL db tables
        3. Imports the anonymised backup file into the empty Cosmos collection
    The SQL tables will be repopulated by the DSS change feed backend function apps

    .NOTES
    Requires https://cosmosdbportalstorage.blob.core.windows.net/datamigrationtool/2018.02.28-1.8.1/dt-1.8.1.zip to be extracted to C:\Program Files (x86)\AzureCosmosDBDataMigrationTool\

#>
[CmdletBinding()]
param(
    # The date stamp of the backup files to use for the restore.  The date will be take from the file name not the meta data.  
    # If multiple backups were taken on that date then multiple restores for each collection will take place.
    [Parameter(Mandatory=$true)]    
    [DateTime]$DateToRestoreFrom,
    # The environment to restore to.  Can only be AT, TEST or PP (values should be entered as lowercase)
    [Parameter(Mandatory=$true)]
    [ValidateSet("at", "test", "pp")]
    [String]$EnvironmentToRestoreTo,
    # Read/Write CosmosDb key for the AT, TEST or PP CosmosDb account
    [Parameter(Mandatory=$true)]
    [String]$DestinationCosmosKey,
    # Path to your local copy of the dfc-devops repo or the artifact if running from an Azure DevOps agent
    [Parameter(Mandatory=$true)]
    [String]$PathToDfcDevops,
    # Path to your local copy of the dss-devops repo or the artifact if running from an Azure DevOps agent
    [Parameter(Mandatory=$true)]
    [String]$PathToDssDevops,
    # Storage account key for the PRD storage account
    [Parameter(Mandatory=$true)]
    [String]$SourceStorageKey,
    # The FQDN of the AT, TEST or PP SQL server
    [Parameter(Mandatory=$true)]
    [String]$SqlServerFqdn,
    # The password of the AT, TEST or PP SQL user
    [Parameter(Mandatory=$true)]
    [String]$SqlServerPassword,
    # The username of the AT, TEST or PP SQL user
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
Write-Verbose "$([DateTime]::Now.ToString("dd-MM-yyyy HH:mm:ss")) Finding files to restore from $($DateToRestoreFrom.ToString("yyyy-MM-dd")) ..."
foreach ($Blob in $AllBackupFiles) {
    
    $FileDate = $Blob.Name.Split("_")[0]
    if($FileDate -eq $DateToRestoreFrom.ToString("yyyy-MM-dd")) {

        Write-Verbose "$([DateTime]::Now.ToString("dd-MM-yyyy HH:mm:ss")) Adding $($Blob.Name) to files to restore from"
        $FilesToRestoreFrom += $Blob

    }
    
}
Write-Verbose "$([DateTime]::Now.ToString("dd-MM-yyyy HH:mm:ss")) Files found to restore: $($FilesToRestoreFrom.Count)"

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
