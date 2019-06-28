using System.Threading.Tasks;
using GeoCodeBulkUpdate.AzureMap.Model;

namespace GeoCodeBulkUpdate.AzureMap.Service
{
    public interface IAzureMapService
    {
        Task<Position> GetPositionForAddress(string address);
    }
}