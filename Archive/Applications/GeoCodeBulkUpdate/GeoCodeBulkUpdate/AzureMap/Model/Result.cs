using System.Collections.Generic;

namespace GeoCodeBulkUpdate.AzureMap.Model
{
    public class Result
    {
        public string Type { get; set; }
        public string Id { get; set; }
        public float Score { get; set; }
        public Address Address { get; set; }
        public Position Position { get; set; }
        public Viewport Viewport { get; set; }
        public List<EntryPoint> EntryPoints { get; set; }
    }
}
