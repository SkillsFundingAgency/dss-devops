using System;
using System.Threading.Tasks;
using GeoCodeBulkUpdate.Config;
using GeoCodeBulkUpdate.DI;
using GeoCodeBulkUpdate.GeoCodeAddressService;
using GeoCodeBulkUpdate.GeoCodeSessionService;
using Microsoft.Extensions.DependencyInjection;

namespace GeoCodeBulkUpdate
{
    public class Program
    {
        static async Task Main(string[] args)
        {
            ConfigurationFactory.CreateConfiguration();
            var serviceProvider = DiStartUp.RegisterServices();
            
            var addressGeoCode = serviceProvider.GetService<IBulkGeoCodeAddressService>();
            var sessionGeoCode = serviceProvider.GetService<IBulkGeoCodeSessionService>();

            Console.WriteLine("Bulk GeoCode Address: Enter '1'");
            Console.WriteLine("Bulk GeoCode Session: Enter '2'");

            var input = Console.ReadLine();

            if (!int.TryParse(input, out int userChoice))
            {
                Console.WriteLine("Unable to process input value");
            }
            
            if (userChoice == 1)
                await addressGeoCode.GenerateGeoCodingForAddressAsync();
            else if (userChoice == 2)
                await sessionGeoCode.GenerateGeoCodingForSessionAsync();
            else
                Console.WriteLine("Value not recognised");


            DiStartUp.DisposeServices();

            Console.WriteLine("DisposeServices");

        }
    }
}
