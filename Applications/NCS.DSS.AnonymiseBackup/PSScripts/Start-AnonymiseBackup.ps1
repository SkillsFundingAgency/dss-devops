[CmdletBinding(SupportsShouldProcess=$true)]
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
    [string]$StorageAcountName,
    [Parameter(Mandatory=$false)]
    [string]$TenantId
)

Write-Verbose "Importing module from $PathToModule"
Import-Module $PathToModule

if ($TenantId) {

    Connect-AzAccount -Identity

}

if ($PSCmdlet.ShouldProcess("$StorageAcountName", "Getting SAS tokens")) {

    try {

        $Keys = Get-AzStorageAccountKey -ResourceGroupName $ResourceGroup -Name $StorageAcountName
        $Context = New-AzStorageContext -StorageAccountName $StorageAcountName -StorageAccountKey $Keys[0].Value
        $ReadSAS = New-AzStorageContainerSASToken -Permission rl -StartTime $([DateTime]::Now) -ExpiryTime $([DateTime]::Now.AddHours(2)) -Context $context -Name $SourceContainer
        $WriteSAS = New-AzStorageContainerSASToken -Permission adw -StartTime $([DateTime]::Now) -ExpiryTime $([DateTime]::Now.AddHours(2)) -Context $context -Name $DestinationContainer

    }
    catch {

        throw "Unable to retrieve storage credentials"

    }

}

if ($CosmosCollections.Count -eq 1) {

    Write-Verbose "Splitting CosmosCollections parameter"
    $CosmosCollections = $CosmosCollections.Replace('"', '').Split(", ")

}

if ($PSCmdlet.ShouldProcess("$CosmosCollections", "Starting Invoke-AnonymiseBackup")) {

    Write-Verbose "$([DateTime]::Now.ToString("yyyy-MM-dd HH:mm:ss")) Starting Invoke-AnonymiseBackup on $CosmosCollections"
    Invoke-AnonymiseBackup -CosmosCollectionNames $CosmosCollections -DestinationContainerName $DestinationContainer -DestinationContainerSASToken $WriteSAS -SourceContainerName $SourceContainer -SourceContainerSASToken $ReadSAS -StorageAccountName $StorageAcountName -Verbose
    Write-Verbose "$([DateTime]::Now.ToString("yyyy-MM-dd HH:mm:ss")) Invoke-AnonymiseBackup completed."

}