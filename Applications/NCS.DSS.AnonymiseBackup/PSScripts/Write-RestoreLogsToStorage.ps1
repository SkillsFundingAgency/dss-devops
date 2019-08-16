[CmdletBinding()]
param(
    # Name of the container to retrieve the logs from
    [Parameter(Mandatory=$true)]    
    [String]$ContainerGroupName,
    # Resource group that where the container resource exists
    [Parameter(Mandatory=$true)]
    [String]$ContainerResourceGroup,
    # The environment to restore to.  Can only be AT, TEST or PP
    [Parameter(Mandatory=$true)]
    [ValidateSet("AT", "TEST", "PP")]
    [String]$Environment,
    # The storage account to save the log file to
    [Parameter(Mandatory=$true)]
    [String]$StorageAccountName,
    # Resource group that where the storage account exists
    [Parameter(Mandatory=$true)]
    [String]$StorageResourceGroupName
)

$Logs = Get-AzContainerInstanceLog -ContainerGroupName $ContainerGroupName -ResourceGroupName $ContainerResourceGroup

$LogFileName = "dss-$($EnvironmentToRestoreTo.ToLower())-restore-aci-logs-$([DateTime]::Now.ToString("yyyy-MM-dd_HHmmss")).log"
$LogFile = New-Item -Name $LogFileName -ItemType File
Set-Content -Path $LogFile.FullName -Value $Logs

$Key = Get-AzureRmStorageAccountKey -ResourceGroupName $($StorageResourceGroupName.ToLower()) -Name $($StorageAccountName.ToLower())
$Context = New-AzureStorageContext -StorageAccountName $($StorageAccountName.ToLower()) -StorageAccountKey $Key[0].Value
Set-AzureStorageBlobContent -File $LogFile.FullName -Container "restorelogs" -Blog $LogFile.Name -Context $Context