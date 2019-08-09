using System;
using System.Collections.Generic;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using Microsoft.Azure.Storage;
using Microsoft.Azure.Storage.Auth;
using Microsoft.Azure.Storage.Blob;
using NCS.DSS.AnonymiseBackup.Helpers;
using NCS.DSS.AnonymiseBackup.Models;

namespace NCS.DSS.AnonymiseBackup
{
    [Cmdlet(VerbsLifecycle.Invoke, "AnonymiseBackup")]
    [OutputType(typeof(AnonymisedBackups))]
    public class InvokeAnonymiseBackup : PSCmdlet
    {
        [Parameter(
            Mandatory = false,
            Position = 0)]
        public string[] CosmosCollectionNames { get; set; }
        
        [Parameter(
            Mandatory = true,
            Position = 1)]
        public string DestinationContainerName { get; set; }

        [Parameter(
            Mandatory = true,
            Position = 2)]
        public string DestinationContainerSASToken { get; set; }

        [Parameter(
            Mandatory = true,
            Position = 3)]

        public string SourceContainerName { get; set; }
        [Parameter(
            Mandatory = true,
            Position = 4)]

        public string SourceContainerSASToken { get; set; }

        [Parameter(
            Mandatory = true,
            Position = 5)]
        public string StorageAccountName { get; set; }

        [Parameter(
            Mandatory = false,
            Position = 6)]
        public DateTime? BackupDate { get; set; }

        CloudBlobContainer destinationBlobContainer = null;
        CloudBlobContainer sourceBlobContainer = null;

        // This method gets called once for each cmdlet in the pipeline when the pipeline starts executing
        protected override void BeginProcessing()
        {
            // connect to storage account
            WriteVerbose("Getting credentials ...");
            StorageCredentials destinationCredentials = new StorageCredentials(DestinationContainerSASToken);
            //CloudStorageAccount destinationStorageAccount = new CloudStorageAccount(destinationCredentials, true);
            //CloudBlobClient destinationBlobClient = destinationStorageAccount.CreateCloudBlobClient();
            //CloudBlobClient destinationBlobClient = destinationStorageContainer.ServiceClient();
            //destinationBlobContainer = destinationBlobClient.GetContainerReference(DestinationContainerName);
            Uri destinationContainerUri = new Uri(String.Format("https://{0}.blob.core.windows.net/{1}", StorageAccountName, DestinationContainerName));
            destinationBlobContainer = new CloudBlobContainer(destinationContainerUri, destinationCredentials);

            StorageCredentials sourceCredentials = new StorageCredentials(SourceContainerSASToken);
            //CloudStorageAccount sourceStorageAccount = new CloudStorageAccount(sourceCredentials, true);
            //CloudBlobClient sourceBlobClient = sourceStorageAccount.CreateCloudBlobClient();
            //sourceBlobContainer = sourceBlobClient.GetContainerReference(SourceContainerName);
            Uri sourceContainerUri = new Uri(String.Format("https://{0}.blob.core.windows.net/{1}", StorageAccountName, SourceContainerName));
            sourceBlobContainer = new CloudBlobContainer(sourceContainerUri, sourceCredentials);

        }

        // This method will be called for each input received from the pipeline to this cmdlet; if no input is received, this method is not called
        protected override void ProcessRecord()
        {
            if (!BackupDate.HasValue)
                BackupDate = DateTime.Today;

            // get files
            WriteVerbose("Listing blobs in container.");
            IDictionary<string, string> filesToAnonymise = new Dictionary<string, string>();
            BlobContinuationToken blobContinuationToken = null;
            do
            {
                BlobResultSegment resultSegment;
                try
                {
                    resultSegment = sourceBlobContainer.ListBlobsSegmentedAsync(blobContinuationToken).Result;
                }
                catch (Exception e)
                {
                    Console.WriteLine(e);
                    throw;
                }

                // Get the value of the continuation token returned by the listing call.
                blobContinuationToken = resultSegment.ContinuationToken;
                foreach (IListBlobItem item in resultSegment.Results)
                {
                    var itemName = "";
                    try
                    {
                        itemName = item.Uri.ToString().Split('/')[4];
                    }
                    catch
                    {
                        throw;
                    }

                    var itemDate = "";
                    try
                    {
                        itemDate = itemName.Split('_')[0];
                    }
                    catch
                    {
                        throw;
                    }

                    var itemCollection = "";
                    try
                    {
                        itemCollection = itemName.Split('-')[3];
                    }
                    catch
                    {
                        throw;
                    }

                    if (itemDate == BackupDate.Value.ToString("yyyy-MM-dd"))
                    {
                        if (Array.Exists(CosmosCollectionNames, name => name == itemCollection))
                        {
                            WriteVerbose(String.Format("Adding {0} to files to anonymise", item.Uri));
                            filesToAnonymise.Add(itemName, itemCollection);
                        }
                    }

                }
            } while (blobContinuationToken != null); // Loop while the continuation token is not null.

            // if BackupDate == null then select most recent else parse date from file and select BackupDate
            WriteVerbose(String.Format("Retrieved {0} files to anonymise", filesToAnonymise.Count));

            // loop through files
            foreach (var file in filesToAnonymise)
            {
                WriteVerbose(String.Format("Anonymising file {0} ...", file.Key));

                // get filename from item
                var filename = file.Key;

                //read data for blob
                var backupDataBlob = AzureStorageHelper.ReadBlobDataFromStorageContainerAsync(sourceBlobContainer, filename).Result;

                // if backup data is null go to the next file
                if (string.IsNullOrEmpty(backupDataBlob))
                    continue;

                WriteVerbose("Anonymise Back Up Data");
                var anonymisedBackUpData = AnonymiseResourceHelper.AnonymiseBackUpData(file.Key, file.Value, backupDataBlob);

                //anonymised data is null so continue to the next file.
                if (anonymisedBackUpData == null)
                    continue;

                WriteVerbose("Write Data to a new File in Destination Blob Storage");
                try
                {
                    AzureStorageHelper.WriteDataToStorageContainer(anonymisedBackUpData, filename, destinationBlobContainer);
                }
                catch (Exception e)
                {
                    WriteError(new ErrorRecord(new Exception("Error writing file to container.  SAS token requires adw permissions (add, delete, write)"), e.ToString(), ErrorCategory.WriteError, null));
                }
            }

            WriteVerbose("Processed pipeline input.");
            return;
        }

        // This method will be called once at the end of pipeline execution; if no input is received, this method is not called
        protected override void EndProcessing()
        {
            WriteVerbose("End!");
            return;
        }
    }

}
