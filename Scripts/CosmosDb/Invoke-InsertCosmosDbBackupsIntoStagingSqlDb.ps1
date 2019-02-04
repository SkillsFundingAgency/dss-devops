[CmdletBinding()]
param(
    #Required.  Resource group containing the storage account
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,
    [Parameter(Mandatory=$true)]
    #Required.  Storage account name
    [string]$StorageAccountName,
    #Required.  Container name
    [Parameter(Mandatory=$true)]
    [string]$ContainerName,
    #Required.
    [Parameter(Mandatory=$false)]
    [array]$CosmosDatabases = @("actionplans", "actions", "addresses", "adviserdetails", "contacts", "customers", "diversitydetails", "goals", "interactions", "outcomes", "sessions", "subscriptions", "transfers", "webchats"),
    [Parameter(Mandatory=$true)]
    [string]$SqlServer,
    [Parameter(Mandatory=$true)]
    [string]$SqlStagingDatabase,
    [Parameter(Mandatory=$true)]
    [string]$SqlServerAdminAccount,
    [Parameter(Mandatory=$true)]
    [string]$SqlServerAdminPassword
)

Import-Module SqlServer

# Get backup files
$Key = Get-AzureRmStorageAccountKey -ResourceGroupName $($ResourceGroupName.ToLower()) -Name $($StorageAccountName.ToLower())
$Context = New-AzureStorageContext -StorageAccountName $($StorageAccountName.ToLower()) -StorageAccountKey $Key[0].Value
$Blobs = Get-AzureStorageContainer -Context $Context -Name $ContainerName | Get-AzureStorageBlob #| Sort-Object -Property LastModified -Descending

$InvokeSqlCommonParams = @{
    ServerInstance = $SqlServer
    Database = $SqlStagingDatabase
    Username = $SqlServerAdminAccount
    Password = $SqlServerAdminPassword
}

# Create the SQL Data Source
Write-Verbose -Message "Creating the SQL Data Source"
try {

    Invoke-SqlCmd -InputFile $PSScriptRoot\..\..\SqlScripts\CreateBlobStorageSource.sql -ErrorAction Stop -Verbose:$VerbosePreference @InvokeSqlCommonParams
    $Query = "SELECT COUNT(*) AS DataSourcesCount FROM sys.external_data_sources WHERE name = 'BlobStorage'"
    $Result = Invoke-Sqlcmd -Query $Query @InvokeSqlCommonParams
    while ($Result.DataSourcesCount -eq 0) {
        Write-Verbose -Message "Data Source 'BlobStorage' not created, waiting 1 second"
        Start-Sleep -Seconds 1
        $Result = Invoke-Sqlcmd -Query $Query @InvokeSqlCommonParams
    }
    Write-Verbose -Message "Data Source 'BlobStorage' created."

}
catch {

    throw "Failed to create the SQL Data Source`n$_"

}

## Execute the stored procedure for each collection
foreach ($db in $CosmosDatabases) {

    Write-Verbose -Message "Locating backup for $db"
    $Blob = $Blobs | Where-Object {$_.Name.Split("-")[3] -eq $db} | Sort-Object -Property LastModified -Descending | Select-Object -First 1
    Write-Verbose "Located backup file for $db database: $($Blob.Name)"
    $Query = "DECLARE @return_value int; EXEC @return_value = [dbo].[Import_Cosmos_$($db)] @JsonFile = N'$($Blob.Name)', @DataSource = N'BlobStorage'; SELECT 'Return Value' = @return_value"
    Write-Verbose -Message "Executing query:`n$Query"
    $Result = Invoke-Sqlcmd -Query $Query @InvokeSqlCommonParams
    Write-Verbose -Message "Query result:`n$($Result.'Return Value')"

}

# Delete the SQL Data Source
Write-Verbose -Message "Deleting the SQL Data Source"
Invoke-SqlCmd -InputFile $PSScriptRoot\..\..\SqlScripts\DeleteBlobStorgageSource.sql -Verbose:$VerbosePreference @InvokeSqlCommonParams

