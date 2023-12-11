[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$StorageAccountName,
    [Parameter(Mandatory=$true)]
    [string]$StorageAccountKey
)

$Context = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey
New-AzStorageContainerSASToken -Name "collections" -Permission lcw -StartTime $([DateTime]::Now.ToString()) -ExpiryTime $([DateTime]::Now.AddDays(365).ToString()) -Context $Context -FullUri -Verbose
