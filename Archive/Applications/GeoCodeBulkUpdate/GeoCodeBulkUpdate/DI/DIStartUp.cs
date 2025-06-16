using System;
using GeoCodeBulkUpdate.AzureMap.Service;
using GeoCodeBulkUpdate.Cosmos.Provider;
using GeoCodeBulkUpdate.GeoCodeAddressService;
using GeoCodeBulkUpdate.GeoCodeSessionService;
using DFC.JSON.Standard;
using Microsoft.Extensions.DependencyInjection;

namespace GeoCodeBulkUpdate.DI
{
    public static class DiStartUp
    {
        public static ServiceProvider ServiceProvider { get; set; }
        public static ServiceProvider RegisterServices()
        {
            var collection = new ServiceCollection();
            collection.AddScoped<IBulkGeoCodeAddressService, BulkGeoCodeAddressServiceService>();
            collection.AddScoped<IBulkGeoCodeSessionService, BulkGeoCodeSessionServiceService>();
            collection.AddScoped<IDocumentDBProvider, DocumentDBProvider>();
            collection.AddScoped<IJsonHelper, JsonHelper>();
            collection.AddScoped<IAzureMapService, AzureMapService>();

            ServiceProvider = collection.BuildServiceProvider();

            return ServiceProvider;
        }

        public static void DisposeServices()
        {
            (ServiceProvider as IDisposable)?.Dispose();
        }

    }
}
