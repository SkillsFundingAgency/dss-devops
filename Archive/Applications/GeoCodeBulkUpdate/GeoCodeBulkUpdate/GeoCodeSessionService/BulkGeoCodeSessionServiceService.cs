using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using GeoCodeBulkUpdate.AzureMap.Model;
using GeoCodeBulkUpdate.AzureMap.Service;
using GeoCodeBulkUpdate.Cosmos.Provider;
using DFC.JSON.Standard;
using Newtonsoft.Json.Linq;

namespace GeoCodeBulkUpdate.GeoCodeSessionService
{
    public class BulkGeoCodeSessionServiceService : IBulkGeoCodeSessionService
    {

        private readonly IDocumentDBProvider _dbProvider;
        private readonly IJsonHelper _jsonHelper;
        private readonly IAzureMapService _azureMapService;
        private Dictionary<string, Position> _venuePostcodeDictionary;

        public BulkGeoCodeSessionServiceService(IDocumentDBProvider dbProvider, IJsonHelper jsonHelper, IAzureMapService azureMapService)
        {
            _dbProvider = dbProvider ?? throw new ArgumentNullException(nameof(dbProvider));
            _jsonHelper = jsonHelper ?? throw new ArgumentNullException(nameof(jsonHelper));
            _azureMapService = azureMapService ?? throw new ArgumentNullException(nameof(azureMapService));
            _venuePostcodeDictionary = new Dictionary<string, Position>();
        }
        
        public async Task GenerateGeoCodingForSessionAsync()
        {
            Console.WriteLine("Starting Session GeoCoding Bulk Upload");

            Console.WriteLine("Attempting to get GetSessionsWithVenuePostCode");

            var sessions = await _dbProvider.GetSessionsWithVenuePostCodeAsync();

            if (!sessions.Any())
            {
                Console.WriteLine("No Sessions With Venue Postcodes to Update");
                return;
            }

            Console.WriteLine("Sessions with Venue Postcode Count: " + sessions.Count);

            foreach (var session in sessions)
            {
                var sessionObj = JObject.Parse(session.ToString());

                if (sessionObj == null)
                    continue;

                if(sessionObj["Longitude"] != null && sessionObj["Latitude"] != null)
                    continue;
                
                var venuePostCode = sessionObj["VenuePostCode"].ToString();

                if (string.IsNullOrEmpty(venuePostCode))
                    continue;

                Console.WriteLine("Attempting to get GetPositionForPostcode");

                Position position;

                Console.WriteLine("Check to see if dictionary contains Position for Postcode");

                if (_venuePostcodeDictionary.ContainsKey(venuePostCode))
                {
                    position = _venuePostcodeDictionary[venuePostCode];
                }
                else
                {
                    position = await _azureMapService.GetPositionForAddress(venuePostCode);
                    _venuePostcodeDictionary.Add(venuePostCode, position);
                }

                if (sessionObj["Longitude"] == null)
                    _jsonHelper.CreatePropertyOnJObject(sessionObj, "Longitude", position.Lon);
                else
                    _jsonHelper.UpdatePropertyValue(sessionObj["Longitude"], position.Lon);

                if (sessionObj["Latitude"] == null)
                    _jsonHelper.CreatePropertyOnJObject(sessionObj, "Latitude", position.Lat);
                else
                    _jsonHelper.UpdatePropertyValue(sessionObj["Latitude"], position.Lat);

                var sessionId = new Guid(sessionObj["id"].ToString());

                Console.WriteLine("SessionId: " + sessionId);

                Console.WriteLine("Attempting to UpdateSessionAsync");

                var updateResponse = await _dbProvider.UpdateSessionAsync(sessionObj.ToString(), sessionId);

                var responseStatusCode = updateResponse?.StatusCode;

                if (responseStatusCode == HttpStatusCode.OK)
                {
                    Console.WriteLine("Successfully Updated: " + sessionId);
                }
                else
                {
                    Console.WriteLine("Unsuccessful geo code update: " + sessionId);
                }

            }

            Console.WriteLine("Finished Bulk Upload");

        }
    }
}