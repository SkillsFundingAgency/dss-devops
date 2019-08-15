FROM mcr.microsoft.com/powershell:6.2.2-windowsservercore-1809 AS app
SHELL ["powershell", "-Command"]
RUN Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
RUN Install-Module AzureRm -Force
RUN Install-Module SqlServer -Force
RUN Install-Module CosmosDb -Force -MaximumVersion 2.1.15.239 -MinimumVersion 2.1.15.239
ADD https://aka.ms/csdmtool /temp/dt.zip
RUN Expand-Archive -Path C:\\temp\\dt.zip -DestinationPath C:\\temp\\dt-tool
WORKDIR /PSScripts
COPY /PSScripts/Reset-DssCollectionsFromAnonBackups.ps1 .
ADD https://raw.githubusercontent.com/SkillsFundingAgency/dss-devops/NCSD-935-RestoreAnonymisedData-TestDockerfile/Scripts/CosmosDb/Restore-CosmosDbContainer.ps1 /dss-devops/Scripts/CosmosDb/
ADD https://raw.githubusercontent.com/SkillsFundingAgency/dfc-devops/NCSD-1228-FixRemoveCosmosCollScript/PSScripts/Remove-CosmosCollectionContents.ps1 /dfc-devops/PSScripts/
ENV CosmosCollections="diversitydetails, transfers"
ENV DateToRestoreFrom="yyyy/MM/dd HH:mm:ss"
ENV DestinationCosmosKey=""
ENV EnvironmentToRestoreTo=""
ENV PathToDfcDevops="C:\dfc-devops"
ENV PathToDssDevops="C:\dss-devops"
ENV SourceContainerSasToken=""
ENV SqlServerFqdn=""
ENV SqlServerPassword=""
ENV SqlServerUsername=""
#CMD .\Reset-DssCollectionsFromAnonBackups.ps1 -CosmosCollections $env:CosmosCollections -DateToRestoreFrom $env:DateToRestoreFrom -EnvironmentToRestoreTo $env:EnvironmentToRestoreTo -DestinationCosmosKey $env:DestinationCosmosKey -PathToDfcDevops $env:PathToDfcDevops -PathToDssDevops $env:PathToDssDevops -SourceStorageAccount $env:SourceStorageAccount -SourceContainerSasToken $env:SourceContainerSasToken -SqlServerFqdn $env:SqlServerFqdn -SqlServerPassword $env:SqlServerPassword -SqlServerUsername $env:SqlServerUsername -Verbose