using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.Azure.Documents;
using Microsoft.Azure.Documents.Client;

namespace GeoCodeBulkUpdate.Cosmos.Provider
{
    public interface IDocumentDBProvider
    {

        Task<List<dynamic>> GetAddressWithPostCodeAsync();
        Task<ResourceResponse<Document>> UpdateAddressAsync(string addressJson, Guid addressId);
        Task<List<dynamic>> GetSessionsWithVenuePostCodeAsync();
        Task<ResourceResponse<Document>> UpdateSessionAsync(string sessionJson, Guid sessionId);
    }
}