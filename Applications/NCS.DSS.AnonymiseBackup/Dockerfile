FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
WORKDIR /src
COPY NCS.DSS.AnonymiseBackup.csproj .
RUN dotnet restore NCS.DSS.AnonymiseBackup.csproj
COPY . .
RUN dotnet publish NCS.DSS.AnonymiseBackup.csproj -c Release --framework netstandard2.0 -o /app/NCS.DSS.AnonymiseBackup

FROM mcr.microsoft.com/powershell:ubuntu-18.04 AS app
SHELL ["pwsh", "-Command"]
RUN Install-Module Az -Force
ENV CosmosCollections="none"
ENV ResourceGroup="dss-foo-shared-rg"
ENV StorageAcountName="dssfooshdarmstr"
ENV TenantId=""
WORKDIR /app
COPY --from=build /app .
COPY PSScripts .
CMD ./Start-AnonymiseBackup.ps1 -CosmosCollections $env:CosmosCollections -PathToModule /app/NCS.DSS.AnonymiseBackup -ResourceGroup $env:ResourceGroup -StorageAcountName $env:StorageAcountName -TenantId $env:TenantId -Verbose