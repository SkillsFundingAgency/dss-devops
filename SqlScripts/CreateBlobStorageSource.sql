IF (SELECT COUNT(*) FROM sys.external_data_sources WHERE name = 'BlobStorage') > 0
	DROP EXTERNAL DATA SOURCE BlobStorage;

IF (SELECT COUNT(*) FROM sys.database_scoped_credentials WHERE name = 'BlobCredential') > 0
	DROP DATABASE SCOPED CREDENTIAL BlobCredential;

-- NOTE: Remove leading ? from SAS token
CREATE DATABASE SCOPED CREDENTIAL BlobCredential 
WITH IDENTITY = 'SHARED ACCESS SIGNATURE', 
SECRET = '__CosmosBackupContainerSasToken__';

CREATE EXTERNAL DATA SOURCE BlobStorage WITH (
    TYPE = BLOB_STORAGE, 
    LOCATION = 'https://__BackupStorageContainerUrl__/cosmosbackups',
    CREDENTIAL = BlobCredential
);