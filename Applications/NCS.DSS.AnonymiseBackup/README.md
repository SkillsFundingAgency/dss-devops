## Testing

Add the storage account secondary SAS token to your environment settings as dssatshdarmstrkey

Open a PowerShell window at the root of this spike (/V3 Sprint 3/NCS.DSS.AnonymiseBackup/) and run the following cmds

dotnet publish -o ./bin/Publish
Import-Module "./bin/Publish/NCS.DSS.AnonymiseBackup.dll"

Attach the debugger to the PowerShell process before running this cmd

Invoke-AnonymiseBackup -CosmosCollectionNames "actionplans", "actions" -DestinationContainerName "blah" -DestinationContainerSASToken "blahblahblah" -SourceContainerName "cosmosbackups" -SourceContainerSASToken $env:dssatshdarmstrkey -StorageAccountName dssatshdarmstr