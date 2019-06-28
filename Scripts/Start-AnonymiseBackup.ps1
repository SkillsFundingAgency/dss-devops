[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string[]]$CosmosCollections,
    [Parameter(Mandatory=$false)]
    [string]$DestinationContainer = "anon-backups",
    [Parameter(Mandatory=$true)]
    [string]$PathToModule,
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroup,
    [Parameter(Mandatory=$false)]
    [string]$SourceContainer = "cosmosbackups",
    [Parameter(Mandatory=$true)]
    [string]$StorageAcountName
)

Import-Module $PathToModule

$Keys = Get-AzStorageAccountKey -ResourceGroupName $ResourceGroup -Name $StorageAcountName
$Context = New-AzStorageContext -StorageAccountName $StorageAcountName -StorageAccountKey $Keys[0].Value
$ReadSAS = New-AzStorageContainerSASToken -Permission rl -StartTime $([DateTime]::Now) -ExpiryTime $([DateTime]::Now.AddHours(2)) -Context $context -Name $SourceContainer
$WriteSAS = New-AzStorageContainerSASToken -Permission adw -StartTime $([DateTime]::Now) -ExpiryTime $([DateTime]::Now.AddHours(2)) -Context $context -Name $DestinationContainer

Invoke-AnonymiseBackup -CosmosCollectionNames $CosmosCollections -DestinationContainerName $DestinationContainer -DestinationContainerSASToken $WriteSAS -SourceContainerName $SourceContainer -SourceContainerSASToken $ReadSAS -StorageAccountName $StorageAcountName -Verbose