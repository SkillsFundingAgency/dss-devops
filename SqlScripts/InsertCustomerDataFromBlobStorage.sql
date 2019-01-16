DECLARE @Customers nvarchar(max)

SET @Customers = (SELECT * FROM OPENROWSET (BULK '__BackupFileName__', DATA_SOURCE = 'BlobStorage', SINGLE_CLOB) as Customers)

IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL
    DROP TABLE dbo.Customers;

SELECT * INTO Customers FROM (
    SELECT  id, DateOfRegistration, Title, GivenName, FamilyName, DateofBirth,
            Gender, UniqueLearnerNumber, OptInUserResearch, DateOfTermination,
            ReasonForTermination, IntroducedBy, IntroducedByAdditionalInfo,
            LastModifiedDate, LastModifiedTouchpointId
    FROM OpenJson(@Customers) WITH (
        id VARCHAR(5) '$.id',
        DateOfRegistration VARCHAR(30) '$.DateOfRegistration',
        Title VARCHAR(30) '$.Title',
        GivenName VARCHAR(30) '$.Givenname',
        FamilyName VARCHAR(30) '$.FamilyName',
        DateofBirth VARCHAR(30) '$.DateofBirth',
        Gender VARCHAR(30) '$.Gender',
        UniqueLearnerNumber VARCHAR(30) '$.UniqueLearnerNumber',
        OptInUserResearch VARCHAR(10) '$.OptInUserResearch',
        DateOfTermination VARCHAR(30) '$.DateOfTermination',
        ReasonForTermination VARCHAR(30) '$.ReasonForTermination',
        IntroducedBy VARCHAR(30) '$.IntroducedBy',
        IntroducedByAdditionalInfo VARCHAR(10) '$.IntroducedByAdditionalInfo',
        LastModifiedDate VARCHAR(30) '$.LastModifiedDate',
        LastModifiedTouchpointId VARCHAR(30) '$.LastModifiedTouchpointId'
    )
) as CosmosCustomers