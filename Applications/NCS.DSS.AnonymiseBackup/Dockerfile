FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
WORKDIR /src
COPY [ "NCS.DSS.AnonymiseBackup.csproj", "src/" ]
RUN dotnet restore "src/NCS.DSS.AnonymiseBackup.csproj"
COPY . .
RUN dotnet publish "src/NCS.DSS.AnonymiseBackup.csproj" -c Release -o /app/NCS.DSS.AnonymiseBackup

FROM mcr.microsoft.com/powershell:ubuntu-18.04 AS app
WORKDIR /app
COPY --from=build /app .
COPY PSScripts .