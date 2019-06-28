using System;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using GeoCodeBulkUpdate.AzureMap.Model;
using GeoCodeBulkUpdate.AzureMap.Service;
using GeoCodeBulkUpdate.Cosmos.Provider;
using DFC.JSON.Standard;
using Newtonsoft.Json.Linq;

namespace GeoCodeBulkUpdate.GeoCodeAddressService
{
    public class BulkGeoCodeAddressServiceService : IBulkGeoCodeAddressService
    {
        private readonly IDocumentDBProvider _dbProvider;
        private readonly IJsonHelper _jsonHelper;
        private readonly IAzureMapService _azureMapService;

        public BulkGeoCodeAddressServiceService(IDocumentDBProvider dbProvider, IJsonHelper jsonHelper, IAzureMapService azureMapService)
        {
            _dbProvider = dbProvider ?? throw new ArgumentNullException(nameof(dbProvider));
            _jsonHelper = jsonHelper ?? throw new ArgumentNullException(nameof(jsonHelper));
            _azureMapService = azureMapService ?? throw new ArgumentNullException(nameof(azureMapService));
        }

        public async Task GenerateGeoCodingForAddressAsync()
        {
            Console.WriteLine("Starting Address GeoCoding Bulk Upload");
            
            Console.WriteLine("Attempting to get GetAddressWithPostCodeAsync");

            var addresses = await _dbProvider.GetAddressWithPostCodeAsync();

            if (!addresses.Any())
            {
                Console.WriteLine("No Addresses With Postcodes to Update");
                return;
            }

            Console.WriteLine("Addresses with Postcode Count: " + addresses.Count);

            foreach (var address in addresses)
            {
                var addressObj = JObject.Parse(address.ToString());

                if (addressObj == null)
                    continue;

                var postCode = addressObj["PostCode"].ToString();

                if (string.IsNullOrEmpty(postCode))
                    continue;

                Console.WriteLine("Attempting to get GetPositionForPostcode");

                Position position = await _azureMapService.GetPositionForAddress(postCode);

                if (addressObj["Longitude"] == null)
                    _jsonHelper.UpdatePropertyValue(addressObj["Longitude"], position.Lon);

                if (addressObj["Latitude"] == null)
                    _jsonHelper.UpdatePropertyValue(addressObj["Latitude"], position.Lat);

                var addressId = new Guid(addressObj["id"].ToString());

                Console.WriteLine("AddressId: " + addressId);

                Console.WriteLine("Attempting to UpdateAddressAsync");

                var updateResponse = await _dbProvider.UpdateAddressAsync(addressObj.ToString(), addressId);

                var responseStatusCode = updateResponse?.StatusCode;

                if (responseStatusCode == HttpStatusCode.OK)
                {
                    Console.WriteLine("Successfully Updated: " + addressId);
                }
                else
                {
                    Console.WriteLine("Unsuccessful geo code update: " + addressId);
                }
                
            }

            Console.WriteLine("Finished Bulk Upload");

        }
    }
}
