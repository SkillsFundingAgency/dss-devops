[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string[]]$CosmosCollections,
    [Parameter(Mandatory=$true)]
    [string]$DestinationContainer = "anon-backups",
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroup,
    [Parameter(Mandatory=$true)]
    [string]$SourceContainer = "cosmosbackups",
    [Parameter(Mandatory=$true)]
    [string]$StorageAcountName
)

$Keys = Get-AzStorageAccountKey -ResourceGroupName $ResourceGroup -Name $StorageAcountName
$Context = New-AzStorageContext -StorageAccountName $StorageAcountName -StorageAccountKey $Keys[0].Value
$ReadSAS = New-AzStorageContainerSASToken -Permission rl -StartTime $([DateTime]::Now) -ExpiryTime $([DateTime]::Now.AddHours(2)) -Context $context -Name $SourceContainer
$WriteSAS = New-AzStorageContainerSASToken -Permission adw -StartTime $([DateTime]::Now) -ExpiryTime $([DateTime]::Now.AddHours(2)) -Context $context -Name anon-$DestinationContainer

Invoke-AnonymiseBackup $CosmosCollections -DestinationContainerName $DestinationContainer -DestinationContainerSASToken $WriteSAS -SourceContainerName $SourceContainer -SourceContainerSASToken $ReadSAS -StorageAccountName $StorageAcountName -Verbose