FROM microsoft/aspnetcore-build:2.0 AS build
WORKDIR /Applications/GeoCodeBulkUpdate
COPY ["/GeoCodeBulkUpdate"]
RUN dotnet restore "GeoCodeBulkUpdate/GeoCodeBulkUpdate.csproj"
COPY . .

FROM build AS publish
RUN dotnet publish "GeoCodeBulkUpdate.csproj" -c Release -o /app
