using System.IO;
using Microsoft.Extensions.Configuration;

namespace GeoCodeBulkUpdate.Config
{
    public static class ConfigurationFactory
    {
        private static IConfiguration Config { get; set; }

        private static IConfigurationBuilder Configure(IConfigurationBuilder config)
        {
            return config
                .SetBasePath(Directory.GetCurrentDirectory())
                .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
                .AddEnvironmentVariables();
        }

        private static IConfiguration BuildConfiguration(IConfigurationBuilder configured)
        {
            return Config = configured.Build();
        }

        public static IConfiguration CreateConfiguration()
        {
            var config = new ConfigurationBuilder();
            var configured = Configure(config);
            return BuildConfiguration(configured);
        }

        public static string GetValueFromConfig(string propName)
        {
            return Config[propName];
        }
    }

}