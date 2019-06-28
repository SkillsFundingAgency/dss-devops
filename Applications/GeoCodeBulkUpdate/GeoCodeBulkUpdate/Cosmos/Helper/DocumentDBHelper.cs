
using System;
using GeoCodeBulkUpdate.Config;
using Microsoft.Azure.Documents.Client;

namespace GeoCodeBulkUpdate.Cosmos.Helper
{
    public static class DocumentDBHelper
    {
        private static Uri _documentCollectionUri;
        private static readonly string _addressDatabaseId = ConfigurationFactory.GetValueFromConfig("AddressDatabaseId");
        private static readonly string _addressCollectionId = ConfigurationFactory.GetValueFromConfig("AddressCollectionId");

        private static readonly string _sessionDatabaseId = ConfigurationFactory.GetValueFromConfig("SessionDatabaseId");
        private static readonly string _sessionCollectionId = ConfigurationFactory.GetValueFromConfig("SessionCollectionId");

        public static Uri CreateAddressDocumentCollectionUri()
        {
            if (_documentCollectionUri != null)
                return _documentCollectionUri;

            _documentCollectionUri = UriFactory.CreateDocumentCollectionUri(_addressDatabaseId, _addressCollectionId);

            return _documentCollectionUri;
        }

        public static Uri CreateAddressDocumentUri(Guid addressId)
        {
            return UriFactory.CreateDocumentUri(_addressDatabaseId, _addressCollectionId, addressId.ToString());
        }


        public static Uri CreateSessionDocumentCollectionUri()
        {
            if (_documentCollectionUri != null)
                return _documentCollectionUri;

            _documentCollectionUri = UriFactory.CreateDocumentCollectionUri(_sessionDatabaseId, _sessionCollectionId);

            return _documentCollectionUri;
        }

        public static Uri CreateSessionDocumentUri(Guid sessionId)
        {
            return UriFactory.CreateDocumentUri(_sessionDatabaseId, _sessionCollectionId, sessionId.ToString());
        }


    }
}
