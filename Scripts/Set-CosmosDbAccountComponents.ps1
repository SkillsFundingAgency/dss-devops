<#

.SYNOPSIS
Create databases, collections and stored procedures within a CosmosDb Account

.DESCRIPTION
Create databases, collections and stored procedures within a CosmosDb Account

.PARAMETER ResourceGroupName
The name of the Resource Group for the CosmosDb Account

.PARAMETER CosmosDbAccountName
The name of the CosmosDb Account

.PARAMETER CosmosDbConfigurationString
CosmosDb JSON configuration in string format

.PARAMETER CosmosDbConfigurationFilePath
CosmosDb JSON configuration as a file

.Parameter CosmosDbProjectFolderPath
Root folder to search for Stored Procedure files

.Parameter PartitionKeyFix
Use fix for cosmosdb shard keys as per https://blog.olandese.nl/2017/12/13/create-a-sharded-mongodb-in-azure-cosmos-db/

.EXAMPLE
$CosmosDbParameters = @{
    ResourceGroupName = $ResourceGroupName
    CosmosDbAccountName = $CosmosDbAccountName
    CosmosDbConfigurationFilePath = $ConfigurationFilePath
    CosmosDbProjectFolderPath = $MongoDbProjectFolderPath
}
.\Set-CosmosDbAccountComponents @CosmosDbParameters
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$ResourceGroupName = $ENV:ResourceGroup,
    [Parameter(Mandatory = $true)]
    [string]$CosmosDbAccountName,
    [Parameter(Mandatory = $true, ParameterSetName = "AsString")]
    [string]$CosmosDbConfigurationString,
    [Parameter(Mandatory = $true, ParameterSetName = "AsFilePath")]
    [string]$CosmosDbConfigurationFilePath,
    [Parameter(Mandatory = $false)]
    [string]$CosmosDbProjectFolderPath,
    [Parameter(Mandatory = $false)]
    [switch]$PartitionKeyFix
)

Class CosmosDbStoredProcedure {
    [string]$StoredProcedureName
}

Class CosmosDbCollection {
    [string]$CollectionName
    [string]$PartitionKey = $null
    [int]$OfferThroughput
    [int]$DefaultTimeToLive = 0
    [CosmosDbStoredProcedure[]]$StoredProcedures
}

Class CosmosDbDatabase {
    [string]$DatabaseName
    [CosmosDbCollection[]]$Collections
}

Class CosmosDbSchema {
    [CosmosDbDatabase[]]$Databases
}

if (!(Get-Module CosmosDB | Where-Object { $_.Version.ToString() -eq "2.1.3.528" })) {
    Install-Module CosmosDB -RequiredVersion "2.1.3.528" -Scope CurrentUser -Force
    Import-Module CosmosDB -RequiredVersion "2.1.3.528"
}

Write-Verbose -Message "Searching for existing account"
$AzureRmMajorVersion = (((Get-Module AzureRM -ListAvailable | Sort-Object { $_.Version.Major } -Descending).Version.Major))[0]
Write-Verbose "AzureRm Major Version: $AzureRmMajorVersion"
if ($AzureRmMajorVersion -gt 5) {
    $GetCosmosDbAccountParameters = @{
        Name              = $CosmosDbAccountName
        ResourceGroupName = $ResourceGroupName
        ExpandProperties  = $true
        ResourceType      = "Microsoft.DocumentDB/databaseAccounts"
    }
    $ExistingAccount = Get-AzureRmResource @GetCosmosDbAccountParameters
}
else {
    $GetCosmosDbAccountParameters = @{
        ResourceType      = "Microsoft.DocumentDb/databaseAccounts"
        ResourceGroupName = $ResourceGroupName
        ResourceName      = $CosmosDbAccountName
    }
    $ExistingAccount = Get-AzureRmResource @GetCosmosDbAccountParameters
}

if (!$ExistingAccount -or $ExistingAccount.Properties.provisioningState -ne "Succeeded") {
    Write-Error -Message "CosmosDb Account could not be found, make sure it has been deployed."
    throw "$_"
}

try {
    if ($PSCmdlet.ParameterSetName -eq "AsFilePath") {
        if (!(Test-Path $CosmosDbConfigurationFilePath)) {
            Write-Error -Message "Configuration File Path can not be found"
            throw "$_"
        }
        $CosmosDbConfiguration = [CosmosDbSchema](Get-Content $CosmosDbConfigurationFilePath | ConvertFrom-Json)
    }
    elseif ($PSCmdlet.ParameterSetName -eq "AsString") {
        $CosmosDbConfiguration = [CosmosDbSchema]($CosmosDbConfigurationString | ConvertFrom-Json)
    }
}
catch {
    Write-Error -Message "Config deserialization failed, check JSON is valid"
    throw "$_"
}

$CosmosDbContext = New-CosmosDbContext -Account $CosmosDbAccountName -ResourceGroup $ResourceGroupName -MasterKeyType 'PrimaryMasterKey'

foreach ($Database in $CosmosDbConfiguration.Databases) {
    # --- Create Database
    try {
        $ExistingDatabase = $null
        $ExistingDatabase = Get-CosmosDbDatabase -Context $CosmosDbContext -Id $Database.DatabaseName
    }
    catch {
        Write-Verbose -Message "Unable to retrieve database: $($Database.DatabaseName)"
    }

    if (!$ExistingDatabase) {
        Write-Verbose -Message "Creating Database: $($Database.DatabaseName)"
        $null = New-CosmosDbDatabase -Context $CosmosDbContext -Id $Database.DatabaseName
    }
    else {
        Write-Verbose -Message "Database: $($Database.DatabaseName) already exists"
    }

    foreach ($Collection in $Database.Collections) {
        # --- Create or Update Collection
        try {
            $ExistingCollection = $null
            $GetCosmosDbDatabaseParameters = @{
                Context  = $CosmosDbContext
                Database = $Database.DatabaseName
                Id       = $Collection.CollectionName
            }
            $ExistingCollection = Get-CosmosDbCollection @GetCosmosDbDatabaseParameters
        }
        catch {
            Write-Verbose "Unable to retrieve collection: $($Collection.CollectionName)"
        }

        if (!$ExistingCollection) {
            Write-Verbose -Message "Creating Collection: $($Collection.CollectionName) in $($Database.DatabaseName)"
            $NewCosmosDbCollectionParameters = @{
                Context         = $CosmosDbContext
                Database        = $Database.DatabaseName
                Id              = $Collection.CollectionName
                OfferThroughput = $Collection.OfferThroughput
                DefaultTimeToLive = $Collection.DefaultTimeToLive
            }
            if ($Collection.DefaultTimeToLive -eq 0 -or $null -eq $Collection.DefaultTimeToLive) {
                $NewCosmosDbCollectionParameters = @{
                    Context         = $CosmosDbContext
                    Database        = $Database.DatabaseName
                    Id              = $Collection.CollectionName
                    OfferThroughput = $Collection.OfferThroughput
                }
            }
            if ($Collection.PartitionKey) {
                if ($PartitionKeyFix.IsPresent) {
                    $NewCosmosDbCollectionParameters.Add('PartitionKey', "'`$v'/$($Collection.PartitionKey)/'`$v'")
                }
                else {
                    $NewCosmosDbCollectionParameters.Add('PartitionKey', $Collection.PartitionKey)
                }
            }
            $null = New-CosmosDbCollection @NewCosmosDbCollectionParameters
        }
        else {
            Write-Verbose -Message "Collection: $($Collection.CollectionName) already exists, retrieving offer"
            try {
                $CollectionOffer = $null
                $CollectionOffer = Get-CosmosDbOffer -Context $CosmosDbContext -Query ('SELECT * FROM root WHERE (root["resource"] = "{0}")' -f $($ExistingCollection._self))
            }
            catch {
                throw "Unable to retrieve offer for $($Collection.CollectionName)`n$_"
            }

            Write-Verbose -Message "Setting OfferThroughput on Offer: $($CollectionOffer.id) for Resource: $($CollectionOffer.resource) to $($Collection.OfferThroughput)"
            $SetCosmosDbOfferParameters = @{
                Context = $CosmosDbContext
                InputObject = $CollectionOffer
                OfferThroughput = $Collection.OfferThroughput
            }
            $Result = Set-CosmosDbOffer @SetCosmosDbOfferParameters
            Write-Verbose -Message "OfferThroughput set to $($Result.content.offerThroughput)  on Offer: $($Result.id) for Resource: $($Result.resource)"
        }

        foreach ($StoredProcedure in $Collection.StoredProcedures) {
            # --- Create Stored Procedure
            try {
                $ExistingStoredProcedure = $null
                $GetCosmosDbStoredProcParameters = @{
                    Context      = $CosmosDbContext
                    Database     = $Database.DatabaseName
                    CollectionId = $Collection.CollectionName
                    Id           = $StoredProcedure.StoredProcedureName
                }
                $ExistingStoredProcedure = Get-CosmosDbStoredProcedure @GetCosmosDbStoredProcParameters
            }
            catch {
                Write-Error -Message "Error retrieving stored procedure: $($StoredProcedure.StoredProcedureName)"
            }

            $FindStoredProcFileParameters = @{
                Path    = (Resolve-Path $CosmosDbProjectFolderPath)
                Filter  = "$($StoredProcedure.StoredProcedureName)*"
                Recurse = $true
                File    = $true
            }

            $StoredProcedureFile = Get-ChildItem @FindStoredProcFileParameters | ForEach-Object { $_.FullName }
            if (!$StoredProcedureFile) {
                Write-Error -Message "Stored Procedure name $($StoredProcedure.StoredProcedureName) could not be found in $(Resolve-Path $CosmosDbProjectFolderPath)"
                throw "$_"
            }

            if ($StoredProcedureFile.GetType().Name -ne "String") {
                Write-Error -Message "Multiple Stored Procedures with name $($StoredProcedure.StoredProcedureName) found in $(Resolve-Path $CosmosDbProjectFolderPath)"
                throw "$_"
            }

            if (!$ExistingStoredProcedure) {
                Write-Verbose -Message "Creating Stored Procedure: $($StoredProcedure.StoredProcedureName) in $($Collection.CollectionName) in $($Database.DatabaseName)"
                $NewCosmosDbStoredProcParameters = @{
                    Context             = $CosmosDbContext
                    Database            = $Database.DatabaseName
                    CollectionId        = $Collection.CollectionName
                    Id                  = $StoredProcedure.StoredProcedureName
                    StoredProcedureBody = (Get-Content $StoredProcedureFile -Raw)
                }
                $null = New-CosmosDbStoredProcedure @NewCosmosDbStoredProcParameters
            }
            elseif ($ExistingStoredProcedure.body -ne (Get-Content $StoredProcedureFile -Raw)) {
                Write-Verbose -Message "Updating Stored Procedure: $($StoredProcedure.StoredProcedureName) in $($Collection.CollectionName) in $($Database.DatabaseName)"
                $SetCosmosDbStoredProcParameters = @{
                    Context             = $CosmosDbContext
                    Database            = $Database.DatabaseName
                    CollectionId        = $Collection.CollectionName
                    Id                  = $StoredProcedure.StoredProcedureName
                    StoredProcedureBody = (Get-Content $StoredProcedureFile -Raw)
                }
                $null = Set-CosmosDbStoredProcedure @SetCosmosDbStoredProcParameters
            }
        }
    }
}
