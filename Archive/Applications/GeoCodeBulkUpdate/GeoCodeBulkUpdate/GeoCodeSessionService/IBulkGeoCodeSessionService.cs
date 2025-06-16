using System.Threading.Tasks;

namespace GeoCodeBulkUpdate.GeoCodeSessionService
{
    public interface IBulkGeoCodeSessionService
    {
        Task GenerateGeoCodingForSessionAsync();
    }
}