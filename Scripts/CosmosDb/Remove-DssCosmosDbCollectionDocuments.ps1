[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$CosmosAccountName,
    [Parameter(Mandatory=$false)]
    [array]$Databases = @("actionplans", "actions", "addresses", "contacts", "customers", "diversitydetails", "goals", "interactions", "outcomes", "sessions", "subscriptions", "transfers", "webchats"),
    [Parameter(Mandatory=$true)]
    [string]$SecondaryCosmosKey
)

$SecureKey = ConvertTo-SecureString -String $SecondaryCosmosKey -AsPlainText -Force

Write-Host "Warning you are about to delete the following collections:`n$($Databases -join "`n")" -ForegroundColor Red
$Continue = Read-Host -Prompt "`nContinue (Y/n)?"

if ($Continue -eq "Y") {

    foreach ($Database in $Databases) {

        $CosmosDbContext = New-CosmosDbContext -Account $CosmosAccountName  -Database $Database -Key $SecureKey
        
        Write-Host "Getting documents from $Database"
        $Docs = Get-CosmosDbDocument -Context $CosmosDbContext -CollectionId $Database
        Write-Host "Retrieved $($docs.Count) documents, deleting documents (number of documents returned may be limited by RU allocation)"
        foreach ($Doc in $Docs) {

            Remove-CosmosDbDocument -Context $CosmosDbContext -CollectionId $Database -Id $Doc.id

        }
        $Docs = Get-CosmosDbDocument -Context $CosmosDbContext -CollectionId $Database
        Write-Host "$($docs.Count) documents remaining (number of documents returned may be limited by RU allocation)"
    
    }

}



