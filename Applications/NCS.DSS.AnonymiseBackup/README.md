# Testing

## Publish and import module

Open a PowerShell Core window at the root of this solution (\dss-devops\Applications\NCS.DSS.AnonymiseBackup/) and run the following cmds

dotnet publish -o ./bin/Publish
Import-Module "./bin/Publish/NCS.DSS.AnonymiseBackup.dll"

## Create Container SAS tokens
Login-AzAccount
Select-AzSubscription -Subscription SFA-CDH-Dev/Test
$Keys = Get-AzStorageAccountKey -ResourceGroupName "dss-at-shared-rg" -Name dssatshdarmstr
$Context = New-AzStorageContext -StorageAccountName dssatshdarmstr -StorageAccountKey $Keys[0].Value
$ReadSAS = New-AzStorageContainerSASToken -Permission rl -StartTime $([DateTime]::Now) -ExpiryTime $([DateTime]::Now.AddHours(2)) -Context $context -Name cosmosbackups
$WriteSAS = New-AzStorageContainerSASToken -Permission adw -StartTime $([DateTime]::Now) -ExpiryTime $([DateTime]::Now.AddHours(2)) -Context $context -Name anon-backups

## Debug

Attach the debugger to the PowerShell process before running this cmd

Invoke-AnonymiseBackup "adviserdetails" -DestinationContainerName "anon-backups" -DestinationContainerSASToken $WriteSAS -SourceContainerName "cosmosbackups" -SourceContainerSASToken $ReadSAS -StorageAccountName "dssatshdarmstr" -Verbose