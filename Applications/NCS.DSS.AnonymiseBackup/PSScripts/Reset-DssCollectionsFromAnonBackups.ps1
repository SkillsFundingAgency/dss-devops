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
    [Parameter(Mandatory=$true)]
    [string[]]$CosmosCollections,
    # The date stamp of the backup files to use for the restore.  The date will be take from the file name not the meta data.  
    # If multiple backups were taken on that date then multiple restores for each collection will take place.
    [Parameter(Mandatory=$true)] 
    [DateTime]$DateToRestoreFrom,
    # The environment to restore to.  Can only be AT, TEST or PP
    [Parameter(Mandatory=$true)]
    [ValidateSet("AT", "TEST", "PP")]
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
    # Storage account where the anonymised backups are stored
    [Parameter(Mandatory=$false)]
    $SourceStorageAccount = "dssprdshdarmstr",
    # Storage account key for the source storage account
    [Parameter(Mandatory=$true, ParameterSetName="StorageAccountKey")]
    [String]$SourceStorageKey,
    # SAS token for anon-backups container in the PRD storage account.  The token will require rl (read and list) permissions.
    [Parameter(Mandatory=$true, ParameterSetName="ContainerSasToken")]
    [String]$SourceContainerSasToken,
    [Parameter(Mandatory=$false)]
    [string]$DataMigrationToolLocation = "C:\temp\dt-tool\drop\dt.exe",
    # SAS token for restore container in the PRD storage account.  The token will require cw (create and write) permission.
    [Parameter(Mandatory=$false, ParameterSetName="ContainerSasToken")]
    [String]$LogContainerSasToken
)

# Source variables (defaults to PRD but can be overriden for testing)
$ContainerName = "anon-backups"
$ContainerUrl = "https://$SourceStorageAccount.blob.core.windows.net/$ContainerName"

# Destination variables (should never be PRD.  Validation set and conditions will enforce this)
$DestinationCosmosAccount = "dss-$($EnvironmentToRestoreTo.ToLower())-shared-cdb"
$DestinationSqlDatabase = "dss-$($EnvironmentToRestoreTo.ToLower())-shared-stag-db"

# Get backup files
if ($PSCmdlet.ParameterSetName -eq "StorageAccountKey") {

    $SourceStorageContext = New-AzureStorageContext -StorageAccountName $SourceStorageAccount -StorageAccountKey $SourceStorageKey

}
elseif ($PSCmdlet.ParameterSetName -eq "ContainerSasToken") {

    $SourceStorageContext = New-AzureStorageContext -StorageAccountName $SourceStorageAccount -SasToken $SourceContainerSasToken

}

# When CosmosCollections is passed in as an environment variable it will be a single comma seperated string
if ($CosmosCollections.Count -eq 1) {

    Write-Verbose "Splitting CosmosCollections parameter"
    $CosmosCollections = $CosmosCollections.Replace('"', '').Split(", ")

}

# Test network connectivity
$DnsCheck = Resolve-DnsName -Name "$SourceStorageAccount.blob.core.windows.net" -ErrorAction SilentlyContinue
$i = 0
while (!$DnsCheck) {

    if ($i -lt 3) {

        Write-Verbose "DNS resolution failed for $SourceStorageAccount.blob.core.windows.net"

    }
    else {

        throw "DNS resolution failed for $SourceStorageAccount.blob.core.windows.net for 3 attempts, terminating script"

    }
    Start-Sleep -Seconds 30
    $DnsCheck = Resolve-DnsName -Name "$SourceStorageAccount.blob.core.windows.net" -ErrorAction SilentlyContinue
    $i++

}
Write-Verbose "DNS resolved for $($DnsCheck[0].Name)"

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

    # Import contents from backup
    Write-Verbose "$([DateTime]::Now.ToString("dd-MM-yyyy HH:mm:ss")) Restoring collection $CollectionId from file $BackupFile"
    try {

        if ($PSCmdlet.ParameterSetName -eq "StorageAccountKey") {

            . $PathToDssDevops\Scripts\CosmosDb\Restore-CosmosDbContainer.ps1 -CosmosAccountName $DestinationCosmosAccount -Database $DatabaseName -SecondaryCosmosKey $DestinationCosmosKey -ContainerUrl $ContainerUrl -BackupFileName $($BackupFile.Name) -SecondaryStorageKey $SourceStorageKey -DataMigrationToolLocation $DataMigrationToolLocation

        }
        elseif ($PSCmdlet.ParameterSetName -eq "ContainerSasToken") {

            . $PathToDssDevops\Scripts\CosmosDb\Restore-CosmosDbContainer.ps1 -CosmosAccountName $DestinationCosmosAccount -Database $DatabaseName -SecondaryCosmosKey $DestinationCosmosKey -ContainerSasToken `"$SourceContainerSasToken`" -ContainerUrl $ContainerUrl -BackupFileName $($BackupFile.Name) -DataMigrationToolLocation $DataMigrationToolLocation

        }


    }
    catch {

        throw "Error restoring database\collection $DatabaseName\$CollectionId `n$_"

    }

    Write-Verbose "$([DateTime]::Now.ToString("dd-MM-yyyy HH:mm:ss")) Database\collection $DatabaseName\$CollectionId reset"

    $OutputFile = Get-Item -Path ".\Reset-DssCollectionsFromAnonBackups.logs" -ErrorAction SilentlyContinue
    if ($OutputFile) {

        # Cannot upload a file that is locked so copy current content to new file
        Write-Verbose "Getting log content"
        $CurrentLogContent = Get-Content -Path $($OutputFile.FullName)
        $LogsToUpLoad = New-Item -Name "Reset-DssCollectionsFromAnonBackups-to-$($EnvironmentToRestoreTo.ToUpper())-$([DateTime]::Now.ToString("dd-MM-yyyy_HHmmss")).logs"
        Set-Content -Path $LogsToUpLoad.FullName -Value $CurrentLogContent

        Write-Verbose "Writing logs to blob storage"
        $LogStorageContext = New-AzureStorageContext -StorageAccountName $SourceStorageAccount -SasToken $LogContainerSasToken
        Set-AzureStorageBlobContent -File $LogsToUpLoad.FullName -Container "restorelogs" -Blob $LogsToUpLoad.Name -Context $LogStorageContext -Force

    }
    else {

        Write-Verbose "No log file found to upload"

    }

}