# Testing

## Publish and import module

Open a PowerShell Core window at the root of this solution (\dss-devops\Applications\NCS.DSS.AnonymiseBackup/) and run the following cmds

dotnet publish -o ./bin/Publish
Import-Module "./bin/Publish/NCS.DSS.AnonymiseBackup.dll"

## Login to the tenant
Login-AzAccount
Select-AzSubscription -Subscription SFA-CDH-Dev/Test
Remove-Module NCS.DSS.AnonymiseBackup

## Debug

Attach the debugger to the PowerShell process before running this cmd

..\..\Scripts\Start-AnonymiseBackup.ps1 -CosmosCollections "outcomes" -PathToModule "./bin/Publish/NCS.DSS.AnonymiseBackup.dll" -ResourceGroup "dss-at-shared-rg" -StorageAcountName "dssatshdarmstr"