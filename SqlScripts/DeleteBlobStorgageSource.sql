IF (SELECT COUNT(*) FROM sys.external_data_sources WHERE name = 'BlobStorage') > 0
	DROP EXTERNAL DATA SOURCE BlobStorage;

IF (SELECT COUNT(*) FROM sys.database_scoped_credentials WHERE name = 'BlobCredential') > 0
	DROP DATABASE SCOPED CREDENTIAL BlobCredential;