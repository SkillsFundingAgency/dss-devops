using System.Collections.Generic;

namespace GeoCodeBulkUpdate.AzureMap.Model
{
    public class SearchAddressModel
    {
        public Summary Summary { get; set; }
        public List<Result> Results { get; set; }
    }
}