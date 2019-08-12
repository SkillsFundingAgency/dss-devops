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
    [string[]]$CosmosCollections,
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
    [Parameter(Mandatory=$true, ParameterSetName="StorageAccountKey")]
    [String]$SourceStorageKey,
    # SAS token for anon-backups container in the PRD storage account.  The token will require rl (read and list) permissions.
    [Parameter(Mandatory=$true, ParameterSetName="ContainerSasToken")]
    [String]$SourceContainerSasToken,
    # The FQDN of the AT, TEST or PP SQL server
    [Parameter(Mandatory=$true)]
    [String]$SqlServerFqdn,
    # The password of the AT, TEST or PP SQL user
    [Parameter(Mandatory=$true)]
    [String]$SqlServerPassword,
    # The username of the AT, TEST or PP SQL user.  The user will require the db_datareader role and the ALTER permission
    [Parameter(Mandatory=$true)]
    [String]$SqlServerUsername
)

Import-Module SqlServer

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
if ($PSCmdlet.ParameterSetName -eq "StorageAccountKey") {

    $SourceStorageContext = New-AzureStorageContext -StorageAccountName $SourceStorageAccount -StorageAccountKey $SourceStorageKey

}
elseif ($PSCmdlet.ParameterSetName -eq "ContainerSasToken") {

    $SourceStorageContext = New-AzureStorageContext -StorageAccountName $SourceStorageAccount -SasToken $SourceContainerSasToken

}
$AllBackupFiles = Get-AzureStorageBlob -Container $ContainerName -Context $SourceStorageContext | Sort-Object -Property Name -Descending
Write-Verbose "$([DateTime]::Now.ToString("dd-MM-yyyy HH:mm:ss")) Files found: $($AllBackupFiles.Count)"
$FilesToRestoreFrom = @()
foreach ($Blob in $AllBackupFiles) {

    $FileDate = $Blob.Name.Split("_")[0]
    $CollectionName = $Blob.Name.Split("-")[3]
    if($FileDate -eq $DateToRestoreFrom.ToString("yyyy-MM-dd")) {

        if($CosmosCollections.Contains($CollectionName)) {

            Write-Verbose "$([DateTime]::Now.ToString("dd-MM-yyyy HH:mm:ss")) Adding $($Blob.Name) to files to restore from"
            $FilesToRestoreFrom += $Blob

        }
        
    }
    
}

foreach ($BackupFile in $FilesToRestoreFrom) {

    $DatabaseName = $BackupFile.Name.Split("-")[3]
    $CollectionId = $BackupFile.Name.Split("-")[3]
    $SqlTableIdentifier = $BackupFile.Name.Split("-")[3]
    Write-Verbose "$([DateTime]::Now.ToString("dd-MM-yyyy HH:mm:ss")) Reseting database\collection $DatabaseName\$CollectionId"

    # Delete contents of Cosmos collection
    if ($DestinationCosmosAccount -match "-prd-") {

        throw "Requested deletion of Production collection, terminating script"

    }

    try {
        
        $SecureDestinationCosmosKey = $DestinationCosmosKey | ConvertTo-SecureString -AsPlainText -Force
        . $PathToDfcDevops\PSScripts\Remove-CosmosCollectionContents.ps1 -CosmosDbAccountName $DestinationCosmosAccount -CosmosDbReadWriteKey $SecureDestinationCosmosKey -Database $DatabaseName -CollectionId $CollectionId

    }
    catch {

        throw "Error resetting database\collection $DatabaseName\$CollectionId `n$_"

    }


    # Truncate SQL table and history table
    if ($DestinationSqlDatabase -match "-prd-") {

        throw "Requested truncation of Production SQL tables, terminating script"

    }
    $ConnectionString = "Server=tcp:$SqlServerFqdn,1433;Initial Catalog=$DestinationSqlDatabase;Persist Security Info=False;User ID=$SqlServerUsername;Password=$SqlServerPassword;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
    Truncate-SqlTable -ConnectionString $ConnectionString -TableName "dss-$SqlTableIdentifier"
    Truncate-SqlTable -ConnectionString $ConnectionString -TableName "dss-$SqlTableIdentifier-history"

    # Import contents from backup
    Write-Verbose "$([DateTime]::Now.ToString("dd-MM-yyyy HH:mm:ss")) Restoring collection $CollectionId from file $BackupFile"
    try {

        if ($PSCmdlet.ParameterSetName -eq "StorageAccountKey") {

            Invoke-Expression -Command "$PathToDssDevops\Scripts\CosmosDb\Restore-CosmosDbContainer.ps1 -CosmosAccountName $DestinationCosmosAccount -Database $DatabaseName -SecondaryCosmosKey $DestinationCosmosKey -ContainerUrl $ContainerUrl -BackupFileName $($BackupFile.Name) -SecondaryStorageKey $SourceStorageKey"

        }
        elseif ($PSCmdlet.ParameterSetName -eq "ContainerSasToken") {

            Invoke-Expression -Command "$PathToDssDevops\Scripts\CosmosDb\Restore-CosmosDbContainer.ps1 -CosmosAccountName $DestinationCosmosAccount -Database $DatabaseName -SecondaryCosmosKey $DestinationCosmosKey -ContainerSasToken `"$SourceContainerSasToken`" -ContainerUrl $ContainerUrl -BackupFileName $($BackupFile.Name)"

        }


    }
    catch {

        throw "Error restoring database\collection $DatabaseName\$CollectionId `n$_"

    }

    Write-Verbose "$([DateTime]::Now.ToString("dd-MM-yyyy HH:mm:ss")) Database\collection $DatabaseName\$CollectionId reset"

}