[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string[]]$CosmosCollections,
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

    $Result = Invoke-Sqlcmd -Query "SELECT COUNT(*) FROM [dbo].[$TableName];" -ConnectionString $ConnectionString -ErrorAction Stop
    Write-Verbose "$([DateTime]::Now.ToString("dd-MM-yyyy HH:mm:ss")) $TableName contains $($Result.Column1) records"
    Invoke-Sqlcmd -Query "TRUNCATE TABLE [dbo].[$TableName];" -ConnectionString $ConnectionString
    $Result = Invoke-Sqlcmd -Query "SELECT COUNT(*) FROM [dbo].[$TableName];" -ConnectionString $ConnectionString
    Write-Verbose "$([DateTime]::Now.ToString("dd-MM-yyyy HH:mm:ss")) $TableName truncated, contains $($Result.Column1) records"
}

# Truncate SQL table and history table
if ($DestinationSqlDatabase -match "-prd-") {

    throw "Requested truncation of Production SQL tables, terminating script"

}

$ConnectionString = "Server=tcp:$SqlServerFqdn,1433;Initial Catalog=$DestinationSqlDatabase;Persist Security Info=False;User ID=$SqlServerUsername;Password=$SqlServerPassword;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"

foreach ($Collection in $CosmosCollections) {

    Truncate-SqlTable -ConnectionString $ConnectionString -TableName "dss-$Collection"
    Truncate-SqlTable -ConnectionString $ConnectionString -TableName "dss-$Collection-history"

}
