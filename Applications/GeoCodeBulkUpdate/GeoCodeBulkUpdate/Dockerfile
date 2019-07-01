FROM microsoft/aspnetcore-build:2.0 AS build
WORKDIR /GeoCodeBulkUpdate
COPY ["GeoCodeBulkUpdate.csproj", "/GeoCodeBulkUpdate"]
RUN dotnet restore "GeoCodeBulkUpdate/GeoCodeBulkUpdate.csproj"
COPY . .

FROM build AS publish
RUN dotnet publish "GeoCodeBulkUpdate.csproj" -c Release -o /app
