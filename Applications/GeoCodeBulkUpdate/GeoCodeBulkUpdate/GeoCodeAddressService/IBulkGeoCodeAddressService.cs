using System.Threading.Tasks;

namespace GeoCodeBulkUpdate.GeoCodeAddressService
{
    public interface IBulkGeoCodeAddressService
    {
        Task GenerateGeoCodingForAddressAsync();
    }
}