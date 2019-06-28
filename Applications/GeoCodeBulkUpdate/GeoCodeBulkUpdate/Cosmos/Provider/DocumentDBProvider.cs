using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Azure.Documents;
using Microsoft.Azure.Documents.Client;
using Microsoft.Azure.Documents.Linq;
using GeoCodeBulkUpdate.Cosmos.Client;
using GeoCodeBulkUpdate.Cosmos.Helper;
using GeoCodeBulkUpdate.Models;
using Newtonsoft.Json.Linq;

namespace GeoCodeBulkUpdate.Cosmos.Provider
{
    public class DocumentDBProvider : IDocumentDBProvider
    {
        public async Task<List<dynamic>> GetAddressWithPostCodeAsync()
        {
            var collectionUri = DocumentDBHelper.CreateAddressDocumentCollectionUri();

            var client = DocumentDBClient.CreateDocumentClient();

            var addressesWithVenuePostcodesQuery = client
                ?.CreateDocumentQuery<Address>(collectionUri, new FeedOptions { MaxItemCount = 1000 })
                .Where(x => x.PostCode != null && x.Latitude == null && x.Longitude == null)
                .AsDocumentQuery();

            if (addressesWithVenuePostcodesQuery == null)
                return null;

            var addresses = new List<dynamic>();

            while (addressesWithVenuePostcodesQuery.HasMoreResults)
            {
                var response = await addressesWithVenuePostcodesQuery.ExecuteNextAsync();
                addresses.AddRange(response);
            }

            return addresses.Any() ? addresses : null;

        }

        public async Task<ResourceResponse<Document>> UpdateAddressAsync(string addressJson, Guid addressId)
        {
            if (string.IsNullOrEmpty(addressJson))
                return null;

            var documentUri = DocumentDBHelper.CreateAddressDocumentUri(addressId);

            var client = DocumentDBClient.CreateDocumentClient();

            if (client == null)
                return null;

            var addressDocumentJObject = JObject.Parse(addressJson);

            var response = await client.ReplaceDocumentAsync(documentUri, addressDocumentJObject);

            return response;
        }

        public async Task<List<dynamic>> GetSessionsWithVenuePostCodeAsync()
        {
            var collectionUri = DocumentDBHelper.CreateSessionDocumentCollectionUri();

            var client = DocumentDBClient.CreateDocumentClient();

            var sessionsWithVenuePostcodesQuery = client
                ?.CreateDocumentQuery<Session>(collectionUri, new FeedOptions {MaxItemCount = 1000})
                .Where(x => x.VenuePostCode != null)
                .AsDocumentQuery();

            if (sessionsWithVenuePostcodesQuery == null)
                return null;

            var sessions = new List<dynamic>();

            while (sessionsWithVenuePostcodesQuery.HasMoreResults)
            {
                var response = await sessionsWithVenuePostcodesQuery.ExecuteNextAsync();
                sessions.AddRange(response);
            }

            return sessions.Any() ? sessions : null;

        }

        public async Task<ResourceResponse<Document>> UpdateSessionAsync(string sessionJson, Guid sessionId)
        {
            if (string.IsNullOrEmpty(sessionJson))
                return null;

            var documentUri = DocumentDBHelper.CreateSessionDocumentUri(sessionId);

            var client = DocumentDBClient.CreateDocumentClient();

            if (client == null)
                return null;

            var sessionDocumentJObject = JObject.Parse(sessionJson);

            var response = await client.ReplaceDocumentAsync(documentUri, sessionDocumentJObject);

            return response;
        }
    }
}