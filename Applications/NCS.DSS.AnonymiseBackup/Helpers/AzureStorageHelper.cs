using System;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Azure.Storage.Blob;

namespace NCS.DSS.AnonymiseBackup.Helpers
{
    public static class AzureStorageHelper
    {

        public static void WriteDataToStorageContainer(string data, string fileName, CloudBlobContainer destinationBlobContainer)
        {
            if (string.IsNullOrEmpty(fileName))
                throw new ArgumentNullException("fileName");

            var anonFileName = fileName.Replace("backup", "anonymisedbackup");

            var blob = destinationBlobContainer.GetBlockBlobReference(anonFileName);

            if (blob == null)
                throw new NullReferenceException("blob");

            blob.DeleteIfExists();

            var options = new BlobRequestOptions()
            {
                ServerTimeout = TimeSpan.FromMinutes(10)
            };

            using (var stream = new MemoryStream(Encoding.Default.GetBytes(data), true))
            {
                blob.UploadFromStream(stream, null, options);
            }

        }

        public static async Task<string> ReadBlobDataFromStorageContainerAsync(CloudBlobContainer sourceBlobContainer, string fileName)
        {
            if (string.IsNullOrEmpty(fileName))
                throw new ArgumentNullException("fileName");

            var blob = sourceBlobContainer.GetBlockBlobReference(fileName);

            if (blob == null)
                throw new NullReferenceException("blob");

            string blobData;
            using (var memoryStream = new MemoryStream())
            {
                await blob.DownloadToStreamAsync(memoryStream);
                blobData = Encoding.UTF8.GetString(memoryStream.ToArray());
            }

            return blobData;
        }
    }
}
