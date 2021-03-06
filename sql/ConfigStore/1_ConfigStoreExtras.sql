/****** Object:  UserDefinedTableType [dbo].[CertificateRoleTableType]    Script Date: 5/12/2020 8:09:19 PM ******/
CREATE TYPE [dbo].[CertificateRoleTableType] AS TABLE(
	[CertificateId] [uniqueidentifier] NULL,
	[Role] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TenantInfoType]    Script Date: 5/12/2020 8:09:19 PM ******/
CREATE TYPE [dbo].[TenantInfoType] AS TABLE(
	[TenantId] [uniqueidentifier] NOT NULL,
	[HasOfficeE3] [bit] NULL,
	[HasOfficeE5] [bit] NULL,
	[TotalAvailableUnits] [bigint] NULL,
	[TrailAvailableUnits] [bigint] NULL,
	[TenantSubscriptionFlags] [bigint] NULL
)
GO
/****** Object:  UserDefinedFunction [dbo].[fn_DefaultBigIntIfNull]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_DefaultBigIntIfNull]
(
    @intValue bigint,
    @defaultValue bigint
)
RETURNS bigint AS
BEGIN
    RETURN
        CASE
            WHEN @intValue IS NULL
            THEN @defaultValue
            ELSE @intValue
        END
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_DefaultBitIfNull]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_DefaultBitIfNull]
(
    @bitValue bit,
    @defaultValue bit
)
RETURNS bit AS
BEGIN
    RETURN
        CASE
            WHEN @bitValue IS NULL
            THEN @defaultValue
            ELSE @bitValue
        END
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_DefaultDateTimeIfNull]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_DefaultDateTimeIfNull]
(
    @dateTime datetime
)
RETURNS datetime AS
BEGIN
    RETURN
        CASE
            WHEN @dateTime IS NULL
            THEN CONVERT(datetime, '1753-01-01 00:00:00')
            ELSE @dateTime
        END
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_DefaultInt32IfNull]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_DefaultInt32IfNull]
(
    @intValue int,
    @defaultValue int
)
RETURNS int AS
BEGIN
    RETURN
        CASE
            WHEN @intValue IS NULL
            THEN @defaultValue
            ELSE @intValue
        END
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_diagramobjects]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE FUNCTION [dbo].[fn_diagramobjects]() 
	RETURNS int
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		declare @id_upgraddiagrams		int
		declare @id_sysdiagrams			int
		declare @id_helpdiagrams		int
		declare @id_helpdiagramdefinition	int
		declare @id_creatediagram	int
		declare @id_renamediagram	int
		declare @id_alterdiagram 	int 
		declare @id_dropdiagram		int
		declare @InstalledObjects	int

		select @InstalledObjects = 0

		select 	@id_upgraddiagrams = object_id(N'dbo.sp_upgraddiagrams'),
			@id_sysdiagrams = object_id(N'dbo.sysdiagrams'),
			@id_helpdiagrams = object_id(N'dbo.sp_helpdiagrams'),
			@id_helpdiagramdefinition = object_id(N'dbo.sp_helpdiagramdefinition'),
			@id_creatediagram = object_id(N'dbo.sp_creatediagram'),
			@id_renamediagram = object_id(N'dbo.sp_renamediagram'),
			@id_alterdiagram = object_id(N'dbo.sp_alterdiagram'), 
			@id_dropdiagram = object_id(N'dbo.sp_dropdiagram')

		if @id_upgraddiagrams is not null
			select @InstalledObjects = @InstalledObjects + 1
		if @id_sysdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 2
		if @id_helpdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 4
		if @id_helpdiagramdefinition is not null
			select @InstalledObjects = @InstalledObjects + 8
		if @id_creatediagram is not null
			select @InstalledObjects = @InstalledObjects + 16
		if @id_renamediagram is not null
			select @InstalledObjects = @InstalledObjects + 32
		if @id_alterdiagram  is not null
			select @InstalledObjects = @InstalledObjects + 64
		if @id_dropdiagram is not null
			select @InstalledObjects = @InstalledObjects + 128
		
		return @InstalledObjects 
	END
	
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetDataGroupForTenantProvisioning]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_GetDataGroupForTenantProvisioning]
(
    @DataGroupState int,
    @DataGroupStatus int,
    @DataGroupType int,
    @Region nvarchar(64)
)
RETURNS uniqueidentifier AS
BEGIN
    RETURN
      (
        SELECT TOP 1 Id
        FROM dbo.DataGroup DG
        WHERE State = @DataGroupState AND
          Status = @DataGroupStatus AND
          Type = @DataGroupType AND
          Geo = @Region
        ORDER BY (SELECT COUNT(DISTINCT Id) FROM dbo.Tenant WHERE DataGroup = DG.Id) ASC)
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_IsGuidNotEmpty]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_IsGuidNotEmpty]
(
    @guid uniqueIdentifier
)
RETURNS bit AS
BEGIN
    RETURN
        CASE
            WHEN @guid IS NULL OR @guid = CONVERT(uniqueidentifier, '00000000-0000-0000-0000-000000000000')
            THEN 0
            ELSE 1
        END
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_IsServiceBusPaired]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_IsServiceBusPaired]
(
    @Id uniqueidentifier
)
RETURNS bit
AS
BEGIN
    DECLARE @paired bit = CONVERT(bit, 0)

    IF @Id IS NULL
    RETURN @paired

    IF EXISTS
    (
        SELECT TOP 1 1
        FROM [dbo].[ServiceBus] SB
        CROSS APPLY TVF_ServiceBus_Id(SB.PairServiceBus) PSB
        WHERE SB.Id = @Id
    )
    OR EXISTS
    (
        SELECT TOP 1 1
        FROM [dbo].[ServiceBus] SB
        WHERE SB.PairServiceBus = @Id
    )
    SELECT @paired = CONVERT(bit, 1)

    RETURN @paired
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetCurrentIP]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetCurrentIP] ()
RETURNS varchar(255)
AS
BEGIN
    DECLARE @IP_Address varchar(255);

    SELECT @IP_Address = client_net_address
    FROM sys.dm_exec_connections
    WHERE Session_id = @@SPID;

    Return @IP_Address;
END
GO
/****** Object:  UserDefinedFunction [dbo].[TVF_DispatcherEndPoint_Tenant_DataGroup]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TVF_DispatcherEndPoint_Tenant_DataGroup]
(
    @TenantId uniqueIdentifier
)
RETURNS TABLE AS RETURN
    SELECT DE.*
    FROM dbo.DispatcherEndpoint DE
    INNER JOIN Tenant t 
		ON DE.DataGroup = T.DataGroup
    WHERE T.Id = @TenantId
    
	 UNION ALL

	SELECT DE.*
    FROM dbo.DispatcherEndpoint DE
    INNER JOIN TenantMigration tm 
		ON DE.DataGroup = TM.DataGroup AND TM.ReadStatus != 42
    WHERE TM.TenantId = @TenantId
GO
/****** Object:  UserDefinedFunction [dbo].[TVF_EventHubs_Tenant_DataGroup]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TVF_EventHubs_Tenant_DataGroup]
(
    @TenantId uniqueIdentifier
)
RETURNS TABLE AS RETURN
    SELECT EH.*
    FROM dbo.EventHub EH 
    INNER JOIN Tenant t 
		ON EH.DataGroup = T.DataGroup
    WHERE T.Id = @TenantId

	 UNION ALL

	SELECT EH.*
    FROM dbo.EventHub EH 
    INNER JOIN TenantMigration TM 
		ON EH.DataGroup = TM.DataGroup AND TM.ReadStatus != 42
    WHERE TM.TenantId = @TenantId
GO
/****** Object:  UserDefinedFunction [dbo].[TVF_ServiceBus_Id]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TVF_ServiceBus_Id]
(
    @id uniqueIdentifier
)
RETURNS TABLE AS RETURN
    SELECT
        *
    FROM
        ServiceBus
    WHERE
        Id = @id
GO
/****** Object:  UserDefinedFunction [dbo].[TVF_SiblingsMetadataStorage_DataGroup]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TVF_SiblingsMetadataStorage_DataGroup]
(
    @DataGroupId uniqueIdentifier
)
RETURNS TABLE AS RETURN
    SELECT
        ST1.*
    FROM
        MetadataStorage AS ST1
    JOIN MetadataStorage AS ST2
        ON ST1.SiblingOf = ST2.Id
    WHERE
        ST1.DataGroup = @DataGroupId AND
        ST2.DataGroup = @DataGroupId
GO
/****** Object:  UserDefinedFunction [dbo].[TVF_SiblingsMetadataStorage_DataGroupType]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TVF_SiblingsMetadataStorage_DataGroupType]
(
    @DataGroupType int
)
RETURNS TABLE AS RETURN
    SELECT
        DG.Id AS DataGroupId,
        ST1.*
    FROM
        MetadataStorage AS ST1
    JOIN MetadataStorage AS ST2
        ON ST1.SiblingOf = ST2.Id
    JOIN DataGroup AS DG
        ON ST1.DataGroup = DG.Id
    WHERE
        ST2.DataGroup = DG.Id AND
        (DG.Type = @DataGroupType OR @DataGroupType IS NULL)
GO
/****** Object:  UserDefinedFunction [dbo].[TVF_SiblingsMetadataStorage_Tenant_DataGroup]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TVF_SiblingsMetadataStorage_Tenant_DataGroup]
(
    @TenantId uniqueIdentifier
)
RETURNS TABLE AS RETURN
    SELECT
        ST1.DataGroup as DataGroupId,
        ST1.*
    FROM
        MetadataStorage AS ST1
    JOIN Tenant T
        ON T.DataGroup = ST1.DataGroup
    JOIN MetadataStorage AS ST2
        ON ST1.SiblingOf = ST2.Id AND T.DataGroup = ST2.DataGroup
    WHERE
        T.Id = @TenantId

    UNION ALL
    
    SELECT
        ST1.DataGroup as DataGroupId,
        ST1.*
    FROM
        MetadataStorage AS ST1
    JOIN TenantMigration TM
        ON TM.DataGroup = ST1.DataGroup AND TM.ReadStatus != 42
    JOIN MetadataStorage AS ST2
        ON ST1.SiblingOf = ST2.Id AND TM.DataGroup = ST2.DataGroup
    WHERE
        TM.TenantId = @TenantId
GO
/****** Object:  UserDefinedFunction [dbo].[TVF_SiblingsStorage_DataGroup]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TVF_SiblingsStorage_DataGroup]
(
    @DataGroupId uniqueIdentifier
)
RETURNS TABLE AS RETURN
    SELECT
        ST1.*
    FROM
        Storage AS ST1
    JOIN Storage AS ST2
        ON ST1.SiblingOf = ST2.Id
    WHERE
        ST1.DataGroup = @DataGroupId AND
        ST2.DataGroup = @DataGroupId
GO
/****** Object:  UserDefinedFunction [dbo].[TVF_SiblingsStorage_DataGroupType]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TVF_SiblingsStorage_DataGroupType]
(
    @DataGroupType int
)
RETURNS TABLE AS RETURN
    SELECT
        DG.Id AS DataGroupId,
        ST1.*
    FROM
        Storage AS ST1
    JOIN Storage AS ST2
        ON ST1.SiblingOf = ST2.Id
    JOIN DataGroup AS DG
        ON ST1.DataGroup = DG.Id
    WHERE
        ST2.DataGroup = DG.Id AND
        (DG.Type = @DataGroupType OR @DataGroupType IS NULL)
GO
/****** Object:  UserDefinedFunction [dbo].[TVF_SiblingsStorage_Tenant_DataGroup]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TVF_SiblingsStorage_Tenant_DataGroup]
(
    @TenantId uniqueIdentifier
)
RETURNS TABLE AS RETURN
    SELECT
        ST1.DataGroup as DataGroupId,
        ST1.*
    FROM
        Storage AS ST1
    JOIN Tenant T
        ON T.DataGroup = ST1.DataGroup
    JOIN Storage AS ST2
        ON ST1.SiblingOf = ST2.Id AND T.DataGroup = ST2.DataGroup
    WHERE
        T.Id = @TenantId
        
    UNION ALL
    
    SELECT
        ST1.DataGroup as DataGroupId,
        ST1.*
    FROM
        Storage AS ST1
    JOIN TenantMigration TM
        ON TM.DataGroup = ST1.DataGroup AND TM.ReadStatus != 42
    JOIN Storage AS ST2
        ON ST1.SiblingOf = ST2.Id AND TM.DataGroup = ST2.DataGroup
    WHERE
        TM.TenantId = @TenantId
GO
/****** Object:  StoredProcedure [dbo].[proc_AcquireLock]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_AcquireLock]
(
    @Lock nvarchar(256),
    @Owner nvarchar(64),
    @Expiry datetime
)
AS
    SET NOCOUNT ON

    IF (@Lock IS NULL OR LEN(@Lock) = 0) OR
       (@Owner IS NULL OR LEN(@Owner) = 0) OR
       (@Expiry IS NULL)
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_AcquireLock')
        RETURN -1
    END

    DECLARE @Acquired bit = CONVERT(bit, 0)
    DECLARE @NewOwner nvarchar(64) = NULL
    DECLARE @Succeeded bit = CONVERT(bit, 1)

    BEGIN TRAN
        DECLARE @preExpiry datetime = NULL
        DECLARE @preOwner nvarchar(64) = NULL

        SELECT @preExpiry = Expiry, @preOwner = Owner
        FROM dbo.Lock
        WHERE Name = @Lock

        IF (@preExpiry IS NOT NULL)
        BEGIN
            IF ((@preExpiry < GETUTCDATE()) OR (@preOwner = @Owner))
            BEGIN
                UPDATE dbo.Lock
                SET Owner = @Owner, LockTime = GETUTCDATE(), Expiry = @Expiry
                WHERE Name = @Lock
                IF @@ROWCOUNT <> 1
                BEGIN
                    SELECT @Succeeded = CONVERT(bit, 0)
                    GOTO CLEANUP
                END
                SELECT @Acquired = CONVERT(bit, 1), @newOwner = @Owner
            END
            ELSE
            SELECT @Expiry = @preExpiry, @NewOwner = @preOwner
        END
        ELSE
        BEGIN
            INSERT INTO dbo.Lock
            (Name, Owner, LockTime, Expiry)
            VALUES
            (@Lock, @Owner, GETUTCDATE(), @Expiry)

            IF @@ROWCOUNT <> 1
            BEGIN
                SELECT @Succeeded = CONVERT(bit, 0),
                    @NewOwner = Owner,
                    @Expiry = Expiry
                FROM dbo.Lock
                GOTO CLEANUP
            END

            SELECT @Acquired = CONVERT(bit, 1), @NewOwner = @Owner
        END

CLEANUP:
    IF @Succeeded = CONVERT(bit, 1)
    COMMIT TRAN
    ELSE
    ROLLBACK TRAN

    SELECT
        @Acquired AS Acquired,
        @NewOwner AS Owner,
        @Expiry AS Expiry
GO
/****** Object:  StoredProcedure [dbo].[proc_AddCache]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_AddCache]
(
    @CacheId uniqueIdentifier,
    @Name nvarchar(64),
    @DataGroupId uniqueidentifier,
    @Status int,
    @Geo nvarchar(32),
    @HostName nvarchar(256),
    @AccessKey nvarchar(512),
    @Ssl bit
)
AS
    IF @CacheId IS NULL OR
       @Name IS NULL OR LEN(LTRIM(RTRIM(@Name))) = 0 OR
       @DataGroupId IS NULL OR
       @Status IS NULL OR
       @Geo IS NULL OR LEN(LTRIM(RTRIM(@Geo))) = 0 OR
       @HostName IS NULL OR LEN(LTRIM(RTRIM(@HostName))) = 0 OR
       @AccessKey IS NULL OR LEN(LTRIM(RTRIM(@AccessKey))) = 0 OR
       @Ssl IS NULL
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_AddCache')
        RETURN -1
    END

    DECLARE @CacheExists bit = CONVERT(bit, 0)
    DECLARE @Succeeded bit = CONVERT(bit, 0)

    BEGIN TRANSACTION
        SELECT
            @CacheExists = CONVERT(bit, 1)
        FROM dbo.Cache WITH(UPDLOCK, HOLDLOCK)
        WHERE Id = @CacheId

        IF @CacheExists = CONVERT(bit, 1) OR
           (NOT EXISTS (SELECT TOP 1 1 FROM dbo.DataGroup WHERE Id = @DataGroupId))
        BEGIN
            GOTO CLEANUP 
        END

        INSERT INTO Cache
        (
            Id,
            Name,
            DataGroup,
            Status,
            Geo,
            HostName,
            AccessKey,
            Ssl
        )
        VALUES 
        (
            @CacheId,
            @Name,
            @DataGroupId,
            @Status,
            @Geo,
            @HostName,
            @AccessKey,
            @Ssl
        )

        IF @@ROWCOUNT = 1 
        BEGIN
            SELECT @Succeeded = CONVERT(bit, 1)
        END

CLEANUP:
    IF @Succeeded = CONVERT(bit, 0)
    BEGIN
        RAISERROR(
            N'Failed to add the cache.',
            18,
            -1) WITH NOWAIT
        ROLLBACK TRANSACTION
    END
    ELSE
    BEGIN
        COMMIT TRANSACTION
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_AddCertificate]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_AddCertificate]
(
    @Id uniqueidentifier,
    @Subject nvarchar(256),
    @Thumbprint nvarchar(40),
    @ExpireTime datetime,
    @Content varbinary(8000),
    @Password nvarchar(512)
)
AS
    SET NOCOUNT ON

    IF @Id IS NULL OR
       @Subject IS NULL OR
       @Thumbprint IS NULL OR
       @ExpireTime IS NULL
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_AddCertificate')
        RETURN -1
    END

    INSERT INTO Certificate
    (
        Id,
        Subject,
        Thumbprint,
        ExpireTime,
        Content,
        Password
    )
    VALUES
    (
        @Id,
        @Subject,
        @Thumbprint,
        @ExpireTime,
        @Content,
        @Password
    )

    SELECT
        Id,
        Subject,
        Thumbprint,
        ExpireTime,
        Content,
        Password
    FROM [dbo].[Certificate] 
    WHERE Id = @Id
GO
/****** Object:  StoredProcedure [dbo].[proc_AddDataGroup]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_AddDataGroup]
(
    @DataGroupId uniqueIdentifier,
    @Name nvarchar(64),
    @Status int,
    @Geo nvarchar(32),
    @Type int = NULL
)
AS
    IF @DataGroupId IS NULL OR
       @Name IS NULL OR LEN(LTRIM(RTRIM(@Name))) = 0 OR
       @Status IS NULL OR
       @Geo IS NULL OR LEN(LTRIM(RTRIM(@Geo))) = 0
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_AddDataGroup')
        RETURN -1
    END

    DECLARE @DataGroupExists bit = CONVERT(bit, 0)
    DECLARE @Succeeded bit = CONVERT(bit, 0)

    BEGIN TRANSACTION
        SELECT
            @DataGroupExists = CONVERT(bit, 1)
        FROM dbo.DataGroup WITH(UPDLOCK, HOLDLOCK)
        WHERE Id = @DataGroupId

        IF @DataGroupExists = CONVERT(bit, 1)
        BEGIN
            GOTO CLEANUP 
        END

        INSERT INTO DataGroup
        (
            Id,
            Name,
            Status,
            Geo,
            Type
        )
        VALUES 
        (
            @DataGroupId,
            @Name,
            @Status,
            @Geo,
            @Type
        )

        IF @@ROWCOUNT = 1 
        BEGIN
            SELECT @Succeeded = CONVERT(bit, 1)
        END

CLEANUP:
    IF @Succeeded = CONVERT(bit, 0)
    BEGIN
        RAISERROR(
            N'Failed to add the datagroup.',
            18,
            -1) WITH NOWAIT
        ROLLBACK TRANSACTION
    END
    ELSE
    BEGIN
        COMMIT TRANSACTION
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_AddDataSubscription]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[proc_AddDataSubscription]
(
    @Id uniqueidentifier,
    @Name nvarchar(32),
    @Status int,
    @TenantId uniqueidentifier,
    @MajorCategory nvarchar(64),
    @MinorCategory nvarchar(64)
)
AS
    SET NOCOUNT ON

    IF @Id IS NULL OR
       @Name IS NULL OR
       @Status IS NULL OR
       @TenantId IS NULL OR
       @MajorCategory IS NULL
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_AddDataSubscription')
        RETURN -1
    END

    DECLARE @existingSubscriptionId uniqueidentifier = ( SELECT TOP 1 Id FROM [dbo].[Subscription] WHERE Tenant = @TenantId AND Name = @Name )
    IF @existingSubscriptionId IS NOT NULL
    BEGIN
        DECLARE @strTenantId nvarchar(36) = CONVERT(nvarchar(36), @TenantId)
        DECLARE @strExistingSubscriptionId nvarchar(36) = CONVERT(nvarchar(36), @existingSubscriptionId)
        RAISERROR(
            N'Subscription %s of tenant %s already exists with Id %s.',
            18,
            -1,
            @Name,
            @strTenantId,
            @strExistingSubscriptionId) WITH NOWAIT
        RETURN -1
    END

	DECLARE @currTime datetime = GETUTCDATE()

    INSERT INTO Subscription
    (
        Id,
        Name,
        Status,
        Tenant,
        MajorCategory,
        MinorCategory,
		CreationTime,
		UpdateTime
    )
    VALUES
    (
        @Id,
        @Name,
        @Status,
        @TenantId,
        @MajorCategory,
        CASE WHEN @MinorCategory IS NULL THEN N'' ELSE @MinorCategory END,
		@currTime,
		@currTime
    )

    SELECT
        Id,
        Name,
        Status,
        Tenant,
        MajorCategory,
        MinorCategory
    FROM [dbo].[Subscription]
    WHERE Id = @Id
GO
/****** Object:  StoredProcedure [dbo].[proc_AddIngestDataSource]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_AddIngestDataSource]
(
    @Id uniqueidentifier,
    @Name nvarchar(32),
    @DataGroup uniqueidentifier,
    @Geo nvarchar(32),
    @Status int,
    @Type int,
    @QueryType int,
    @CertificateThumbprint nvarchar(40),
    @CertificateStoreName nvarchar(30),
    @CertificateStoreLocation nvarchar(20),
    @QueryUrl nvarchar(200),
    @QueryTables nvarchar(1024),
    @QueryFilters nvarchar(MAX),
    @WaterMarkContainer nvarchar(200),
    @MaxQueryRetries int,
    @MaxQueryWaitTimeInSec int,
    @SleepBetweenRetriesInSec int
)
AS
BEGIN
    SET NOCOUNT ON
    IF (@Name IS NULL OR  LEN(LTRIM(RTRIM(@Name))) = 0) OR
       (@Geo IS NULL OR  LEN(LTRIM(RTRIM(@Geo))) = 0) OR
       (@CertificateThumbprint IS NULL OR LEN(LTRIM(RTRIM(@CertificateThumbprint))) != 40) OR
       (@CertificateStoreName IS NULL OR LEN(LTRIM(RTRIM(@CertificateStoreName))) = 0) OR
       (@CertificateStoreLocation IS NULL OR LEN(LTRIM(RTRIM(@CertificateStoreLocation))) = 0) OR
       (@QueryUrl IS NULL OR LEN(LTRIM(RTRIM(@QueryUrl))) = 0) OR
       (@QueryTables IS NULL OR LEN(LTRIM(RTRIM(@QueryTables))) = 0) OR
       (@WaterMarkContainer IS NULL OR LEN(LTRIM(RTRIM(@WaterMarkContainer))) = 0) OR
       (NOT EXISTS (SELECT TOP 1 1 FROM [DataGroup] WHERE [Id] = @DataGroup))
    BEGIN
        RAISERROR (15600, -1, -1, '[proc_AddIngestDataSource]')
        RETURN -1
    END

    DECLARE @strDataSourceId nvarchar(36) = CONVERT(nvarchar(36), @Id)
    IF EXISTS (SELECT TOP 1 1 FROM IngestDataSource WHERE Id = @Id)
    BEGIN
        RAISERROR(
            N'Ingestion data source %s already exists.',
            18,
            -1,
            @strDataSourceId) WITH NOWAIT
        RETURN -1
    END

    DECLARE @CurrentTime DateTime = GETUTCDATE()
    DECLARE @Succeeded bit = CONVERT(bit, 0)

    BEGIN TRAN
        INSERT INTO [IngestDataSource]
        (
            [Id]
            ,[Name]
            ,[DataGroup]
            ,[Geo]
            ,[Status]
            ,[Type]
            ,[QueryType]
            ,[CertificateThumbprint]
            ,[CertificateStoreName]
            ,[CertificateStoreLocation]
            ,[QueryUrl]
            ,[QueryTables]
            ,[QueryFilters]
            ,[WaterMarkContainer]
            ,[MaxQueryRetries]
            ,[MaxQueryWaitTimeInSec]
            ,[SleepBetweenRetriesInSec]
            ,[CreationTime]
            ,[UpdateTime]
        )
        VALUES
        (
            @Id
            ,@Name
            ,@DataGroup
            ,@Geo
            ,@Status
            ,@Type
            ,@QueryType
            ,@CertificateThumbprint
            ,@CertificateStoreName
            ,@CertificateStoreLocation
            ,@QueryUrl
            ,@QueryTables
            ,@QueryFilters
            ,@WaterMarkContainer
            ,@MaxQueryRetries
            ,@MaxQueryWaitTimeInSec
            ,@SleepBetweenRetriesInSec
            ,@CurrentTime
            ,@CurrentTime
        )

    IF @@ROWCOUNT <> 1
        BEGIN
            SELECT @Succeeded = CONVERT(bit, 0)
            GOTO CLEANUP
        END

        SELECT @Succeeded = CONVERT(bit, 1)

  CLEANUP:
    IF @Succeeded = CONVERT(bit, 1)
    BEGIN
        COMMIT TRAN
    END
    ELSE
    BEGIN
        ROLLBACK TRAN
        RAISERROR(
            58126,
            11,
            1,
            N'Failed to add the ingestion data source. Please try again later.') WITH NOWAIT
        RETURN -1
    END
  END
GO
/****** Object:  StoredProcedure [dbo].[proc_AddOrUpdateTenantInfo]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  StoredProcedure [dbo].[proc_AddOrUpdateTenantInfo]    Script Date: 10/11/2019 2:41:49 PM ******/
--------------------------------------------------------------------------------
   -- create procedure proc_AddOrUpdateTenantInfo
--------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[proc_AddOrUpdateTenantInfo] (@TenantInfos TenantInfoType READONLY)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @outCountsVar TABLE (
		MergeAction VARCHAR(20)
		,InsertedID INT
		,DeletedID INT
		)

	MERGE TenantInfo AS TF
	USING @TenantInfos AS TFT
		ON TF.TenantId = TFT.TenantId
	WHEN MATCHED
		THEN
			UPDATE
			SET TF.[HasOfficeE3] = TFT.[HasOfficeE3]
				,TF.[HasOfficeE5] = TFT.[HasOfficeE5]
				,TF.[TotalAvailableUnits] = TFT.[TotalAvailableUnits]
				,TF.[TrailAvailableUnits] = TFT.[TrailAvailableUnits]
				,TF.[TenantSubscriptionFlags] = TFT.[TenantSubscriptionFlags]
				,TF.[LastUpdateDate] = GETDATE()
	WHEN NOT MATCHED BY TARGET
		THEN
			INSERT (
				[TenantId]
				,[HasOfficeE3]
				,[HasOfficeE5]
				,[TotalAvailableUnits]
				,[TrailAvailableUnits]
				,[TenantSubscriptionFlags]
				)
			VALUES (
				TFT.[TenantId]
				,TFT.[HasOfficeE3]
				,TFT.[HasOfficeE5]
				,TFT.[TotalAvailableUnits]
				,TFT.[TrailAvailableUnits]
				,TFT.[TenantSubscriptionFlags]
				);
END
GO
/****** Object:  StoredProcedure [dbo].[proc_AddService]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_AddService]
(
    @Id uniqueidentifier,
    @Name nvarchar(128),
    @TypeName nvarchar(256),
    @State int
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@Id) = 0 OR
        @Name IS NULL OR LEN(LTRIM(RTRIM(@Name))) = 0 OR
        @TypeName IS NULL OR LEN(LTRIM(RTRIM(@TypeName))) = 0 OR
        @State IS NULL
    BEGIN
        RAISERROR(15600, -1, -1, 'proc_AddService')
        RETURN -1
    END

    DECLARE @existingServiceId uniqueidentifier = (SELECT TOP 1 Id FROM dbo.Service WHERE Name = @Name)
    IF @existingServiceId IS NOT NULL
    BEGIN
        DECLARE @strServiceId nvarchar(36) = CONVERT(nvarchar(36), @existingServiceId)
        RAISERROR(
            N'Service with name %s already exists with ID %s.',
            18,
            -1,
            @Name,
            @strServiceId) WITH NOWAIT
        RETURN -1
    END

    SELECT TOP 1 @existingServiceId = Id FROM dbo.Service WHERE TypeName = @TypeName
    IF @existingServiceId IS NOT NULL
    BEGIN
        SELECT @strServiceId = CONVERT(nvarchar(36), @existingServiceId)
        RAISERROR(
            N'Service with type name %s already exists with ID %s.',
            18,
            -1,
            @TypeName,
            @strServiceId) WITH NOWAIT
        RETURN -1
    END

    DECLARE @utcNow datetime = GETUTCDATE()
    INSERT INTO dbo.Service
    (Id, Name, TypeName, State, CreationTime, UpdateTime)
    VALUES
    (@Id, @Name, @TypeName, @State, @utcNow, @utcNow)

    IF @@ROWCOUNT <> 1
    BEGIN
        RAISERROR(
            58126,
            18,
            -1,
            N'Failed to add the service. Please try again later.') WITH NOWAIT
        RETURN -1
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_AddServiceBus]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_AddServiceBus]
(
    @ServiceBusId uniqueIdentifier,
    @Name nvarchar(256),
    @DataGroupId uniqueidentifier,
    @Status int,
    @PairServiceBusId uniqueIdentifier = NULL,
    @Geo nvarchar(32),
    @Namespace nvarchar(256),
    @ManagementSharedAccessKeyName nvarchar(64),
    @ManagementSharedAccessKey nvarchar(512)
)
AS
    IF @ServiceBusId IS NULL OR
       @Name IS NULL OR LEN(LTRIM(RTRIM(@Name))) = 0 OR
       @DataGroupId IS NULL OR
       @Status IS NULL OR
       @Geo IS NULL OR LEN(LTRIM(RTRIM(@Geo))) = 0 OR
       @Namespace IS NULL OR LEN(LTRIM(RTRIM(@Namespace))) = 0 OR
       @ManagementSharedAccessKeyName IS NULL OR LEN(LTRIM(RTRIM(@ManagementSharedAccessKeyName))) = 0 OR
       @ManagementSharedAccessKey IS NULL OR LEN(LTRIM(RTRIM(@ManagementSharedAccessKey))) = 0
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_AddServiceBus')
        RETURN -1
    END

    DECLARE @ServiceBusExists bit = CONVERT(bit, 0)
    DECLARE @Succeeded bit = CONVERT(bit, 0)

    BEGIN TRANSACTION
        SELECT
            @ServiceBusExists = CONVERT(bit, 1)
        FROM dbo.ServiceBus WITH(UPDLOCK, HOLDLOCK)
        WHERE Id = @ServiceBusId

        IF @ServiceBusExists = CONVERT(bit, 1) OR
           (NOT EXISTS (SELECT TOP 1 1 FROM dbo.DataGroup WHERE Id = @DataGroupId)) OR
           (@PairServiceBusId IS NOT NULL AND (NOT EXISTS (SELECT TOP 1 1 FROM dbo.ServiceBus WHERE Id = @PairServiceBusId)))
        BEGIN
            GOTO CLEANUP 
        END

        INSERT INTO ServiceBus
        (
            Id,
            Name,
            DataGroup,
            Status,
            PairServiceBus,
            Geo,
            Namespace,
            ManagementSharedAccessKeyName,
            ManagementSharedAccessKey
        )
        VALUES 
        (
            @ServiceBusId,
            @Name,
            @DataGroupId,
            @Status,
            @PairServiceBusId,
            @Geo,
            @Namespace,
            @ManagementSharedAccessKeyName,
            @ManagementSharedAccessKey
        )

        IF @@ROWCOUNT = 1 
        BEGIN
            SELECT @Succeeded = CONVERT(bit, 1)
        END

CLEANUP:
    IF @Succeeded = CONVERT(bit, 0)
    BEGIN
        RAISERROR(
            N'Failed to add the servicebus.',
            18,
            -1) WITH NOWAIT
        ROLLBACK TRANSACTION
    END
    ELSE
    BEGIN
        COMMIT TRANSACTION
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_AddServiceCertificate]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_AddServiceCertificate]
(
    @ServiceInstanceId uniqueidentifier,
    @CertificateId uniqueidentifier
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@ServiceInstanceId) = 0 OR
       dbo.fn_IsGuidNotEmpty(@CertificateId) = 0
    BEGIN
        RAISERROR(15600, -1, -1, 'proc_AddServiceCertificate')
        RETURN -1
    END

    DECLARE @strServiceInstanceId nvarchar(36) = CONVERT(nvarchar(36), @ServiceInstanceId)
    DECLARE @strCertificateId nvarchar(36) = CONVERT(nvarchar(36), @CertificateId)

    IF EXISTS (SELECT TOP 1 1 FROM dbo.ServiceCert WHERE ServiceInstance = @ServiceInstanceId AND Certificate = @CertificateId)
    BEGIN
        RAISERROR(
            N'Certificate %s for service instance %s already exists.',
            18,
            -1,
            @strCertificateId,
            @strServiceInstanceId) WITH NOWAIT
        RETURN -1
    END

    IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.ServiceInstance WHERE Id = @ServiceInstanceId)
    BEGIN
        RAISERROR(
            N'Service instance with ID %s does not exists.',
            18,
            -1,
            @strServiceInstanceId) WITH NOWAIT
        RETURN -1
    END

    IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.Certificate WHERE Id = @CertificateId)
    BEGIN
        RAISERROR(
            N'Certificate with ID %s does not exists.',
            18,
            -1,
            @strCertificateId) WITH NOWAIT
        RETURN -1
    END

    INSERT INTO dbo.ServiceCert
    (ServiceInstance, Certificate)
    VALUES
    (@ServiceInstanceId, @CertificateId)

    IF @@ROWCOUNT <> 1
    BEGIN
        RAISERROR(
            58126,
            11,
            1,
            N'Failed to add certiciate for service instance. Please try again later.') WITH NOWAIT
        RETURN -1
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_AddServiceInstance]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_AddServiceInstance]
(
    @ServiceId uniqueidentifier,
    @Id uniqueidentifier,
    @Name nvarchar(128),
    @State int,
    @ServiceDeleteState int
)
AS
    SET NOCOUNT ON

    IF (dbo.fn_IsGuidNotEmpty(@ServiceId) = 0) OR
        @Name IS NULL OR LEN(LTRIM(RTRIM(@Name))) = 0 OR
        @State IS NULL OR
        @ServiceDeleteState IS NULL
    BEGIN
        RAISERROR(15600, -1, -1, 'proc_AddServiceInstance')
        RETURN -1
    END

    DECLARE @serviceState int = ( SELECT TOP 1 State FROM dbo.Service WHERE Id = @ServiceId AND @State <> @ServiceDeleteState )
    IF @serviceState IS NULL
    BEGIN
        RAISERROR(
            N'Service does not exist.',
            18,
            -1) WITH NOWAIT
        RETURN -1
    END
    ELSE IF @serviceState = @ServiceDeleteState
    BEGIN
        RAISERROR(
            N'Service has already been deleted.',
            18,
            -1) WITH NOWAIT
        RETURN -1
    END

    DECLARE @existingServiceInstanceId uniqueidentifier = (SELECT TOP 1 Id FROM dbo.ServiceInstance WHERE Name = @Name)
    IF @existingServiceInstanceId IS NOT NULL
    BEGIN
        DECLARE @strExistingServiceInstanceId nvarchar(36) = CONVERT(nvarchar(36), @existingServiceInstanceId)
        RAISERROR(
            N'Service instance with name %s already exists with ID %s.',
            18,
            -1,
            @Name,
            @strExistingServiceInstanceId) WITH NOWAIT
        RETURN -1
    END

    DECLARE @utcNow datetime = GETUTCDATE()
    INSERT INTO dbo.ServiceInstance
    (Id, Service, Name, State, CreationTime, UpdateTime)
    VALUES
    (@Id, @ServiceId, @Name, @State, @utcNow, @utcNow)

    IF @@ROWCOUNT <> 1
    BEGIN
        RAISERROR(
            58126,
            11,
            1,
            N'Failed to add the service. Please try again later.') WITH NOWAIT
        RETURN -1
    END

    EXEC dbo.proc_GetServiceInstance @ServiceId = @ServiceId, @Id = @Id
GO
/****** Object:  StoredProcedure [dbo].[proc_AddStorage]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_AddStorage]
(
    @StorageId uniqueIdentifier,
    @Name nvarchar(256),
    @DataGroupId uniqueidentifier,
    @Status int,
    @Geo nvarchar(32),
    @AccountName nvarchar(64),
    @AccessKey nvarchar(512),
    @ServiceUriSuffix nvarchar(128) = NULL
)
AS
    IF @StorageId IS NULL OR
       @Name IS NULL OR LEN(LTRIM(RTRIM(@Name))) = 0 OR
       @DataGroupId IS NULL OR
       @Status IS NULL OR
       @Geo IS NULL OR LEN(LTRIM(RTRIM(@Geo))) = 0 OR
       @AccountName IS NULL OR LEN(LTRIM(RTRIM(@AccountName))) = 0 OR
       @AccessKey IS NULL OR LEN(LTRIM(RTRIM(@AccessKey))) = 0 OR
       (@ServiceUriSuffix IS NOT NULL AND LEN(LTRIM(RTRIM(@ServiceUriSuffix))) = 0)
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_AddStorage')
        RETURN -1
    END

    DECLARE @StorageExists bit = CONVERT(bit, 0)
    DECLARE @Succeeded bit = CONVERT(bit, 0)

    BEGIN TRANSACTION
        SELECT
            @StorageExists = CONVERT(bit, 1)
        FROM dbo.Storage WITH(UPDLOCK, HOLDLOCK)
        WHERE Id = @StorageId

        IF @StorageExists = CONVERT(bit, 1) OR
           (NOT EXISTS (SELECT TOP 1 1 FROM dbo.DataGroup WHERE Id = @DataGroupId))
        BEGIN
            GOTO CLEANUP 
        END

        INSERT INTO Storage
        (
            Id,
            Name,
            DataGroup,
            Status,
            Geo,
            AccountName,
            AccessKey,
            ServiceUriSuffix
        )
        VALUES 
        (
            @StorageId,
            @Name,
            @DataGroupId,
            @Status,
            @Geo,
            @AccountName,
            @AccessKey,
            @ServiceUriSuffix
        )

        IF @@ROWCOUNT = 1 
        BEGIN
            SELECT @Succeeded = CONVERT(bit, 1)
        END

CLEANUP:
    IF @Succeeded = CONVERT(bit, 0)
    BEGIN
        RAISERROR(
            N'Failed to add the storage.',
            18,
            -1) WITH NOWAIT
        ROLLBACK TRANSACTION
    END
    ELSE
    BEGIN
        COMMIT TRANSACTION
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_AddTenant]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------------------------
   -- proc_AddTenant add TopicName
--------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[proc_AddTenant]
(
    @TenantId uniqueidentifier,
    @Name nvarchar(64),
    @AuditingEnabled bit,
    @DataGroupId uniqueidentifier,
    @CertificateRole CertificateRoleTableType READONLY,
    @State int = NULL,
    @DeletedState int = 5,
    @Type int = NULL,
    @TopicName nvarchar(100) = NULL
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@TenantId) = 0 OR
       @Name IS NULL OR LEN(LTRIM(RTRIM(@Name))) = 0 OR
       dbo.fn_IsGuidNotEmpty(@DataGroupId) = 0 OR
       @AuditingEnabled IS NULL
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_AddTenant')
        RETURN -1
    END

    DECLARE @tenantExists bit = CONVERT(bit, 0)
    DECLARE @existingTenantState int = 0
    DECLARE @tenantCertCount int = 0
    DECLARE @Succeeded bit = CONVERT(bit, 0)

    IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.DataGroup WHERE Id = @DataGroupId)
    BEGIN
        RAISERROR(
            N'Data group does not exist.',
            18,
            -1) WITH NOWAIT
        RETURN -1
    END

    SELECT
        @tenantExists = CONVERT(bit, 1),
        @existingTenantState = State
    FROM dbo.Tenant WITH(UPDLOCK, HOLDLOCK)
    WHERE Id = @TenantId

    IF @tenantExists = CONVERT(bit, 1)
    BEGIN
        IF @existingTenantState = @DeletedState
        DELETE FROM dbo.Tenant WHERE Id = @TenantId
        ELSE
        BEGIN
            RAISERROR(
                'Tenant already exists.',
                18,
                1) WITH NOWAIT
            RETURN -1
        END

    END

    BEGIN TRAN
        SELECT
            @tenantCertCount = COUNT(*)
        FROM
            @CertificateRole

        DECLARE @utcNow datetime = GETUTCDATE()
        INSERT INTO Tenant
        (
            Id,
            Name,
            AuditingEnabled,
            DataGroup,
            State,
            CreationTime,
            UpdateTime,
            Type,
            TopicName
        )
        VALUES
        (
            @TenantId,
            @Name,
            @AuditingEnabled,
            @DataGroupId,
            @State,
            @utcNow,
            @utcNow,
            @Type,
            @TopicName
        )

        IF @@ROWCOUNT <> 1 
        BEGIN
            SELECT @Succeeded = CONVERT(bit, 0)
            GOTO CLEANUP
        END

        INSERT INTO TenantCert
        (
            Tenant,
            Certificate,
            Role
        )
        SELECT
            @TenantId, 
            CR.CertificateId, 
            CR.Role
        FROM 
            @CertificateRole CR

        IF @@ROWCOUNT = @tenantCertCount 
        BEGIN
            SELECT @Succeeded = CONVERT(bit, 1)
        END
CLEANUP:
    IF @Succeeded = CONVERT(bit, 1)
    BEGIN
        COMMIT TRAN
    END
    ELSE
    BEGIN
        ROLLBACK TRAN
        RAISERROR(
            58126,
            11,
            1,
            N'Failed to add the tenant. Please try again later.') WITH NOWAIT
        RETURN -1
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_AddTenantCert]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[proc_AddTenantCert]
(
    @Tenant uniqueidentifier,
    @Certificate uniqueidentifier,
    @Role int
)
AS
    SET NOCOUNT ON

    IF @Tenant IS NULL OR
       @Certificate IS NULL OR
       @Role IS NULL
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_AddTenantCert')
        RETURN -1
    END

    DECLARE @tenantCertExists bit = CONVERT(bit, 0)

    SELECT 
            @tenantCertExists = CONVERT(bit, 1)
    FROM [dbo].[TenantCert] 
    WHERE Tenant = @Tenant AND Certificate = @Certificate

    IF @tenantCertExists = CONVERT(bit, 1)
    BEGIN
         RAISERROR(
            N'The certificate has already ben assocaited with the tenant.',
            18,
            -1) WITH NOWAIT
        RETURN -1
    END

    INSERT INTO TenantCert
    (
        Tenant,
        Certificate,
        Role
    )
    VALUES
    (
        @Tenant,
        @Certificate,
        @Role
    )

    IF @@ROWCOUNT <> 1
    BEGIN
        RAISERROR(
            N'Failed to insert the tenantCert.',
            18,
            -1) WITH NOWAIT
    END

    SELECT
        Tenant,
        Certificate,
        Role
    FROM [dbo].[TenantCert]
    WHERE Tenant = @Tenant AND Certificate = @Certificate
GO
/****** Object:  StoredProcedure [dbo].[proc_ClearTenantReceiverPolicy]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_ClearTenantReceiverPolicy]
(
    @TenantId uniqueidentifier,
    @Primary bit
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@TenantId) = 0
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_ClearTenantReceiverPolicy')
        RETURN -1
    END

    IF @Primary = CONVERT(bit, 1)
    UPDATE dbo.Tenant 
    SET
        ReceiverPolicy = NULL,
        ReceiverAccessKey = NULL,
        UpdateTime = GETUTCDATE()
    WHERE Id = @TenantId
    ELSE IF @Primary = CONVERT(bit, 0)
    UPDATE dbo.Tenant 
    SET
        SecondaryReceiverPolicy = NULL,
        SecondaryReceiverAccessKey = NULL,
        UpdateTime = GETUTCDATE()
    WHERE Id = @TenantId
    ELSE
    UPDATE dbo.Tenant 
    SET
        ReceiverPolicy = NULL,
        ReceiverAccessKey = NULL,
        SecondaryReceiverPolicy = NULL,
        SecondaryReceiverAccessKey = NULL,
        UpdateTime = GETUTCDATE()
    WHERE Id = @TenantId

    IF @@ROWCOUNT = 0
        RAISERROR(
            N'Failed to clear tenant receiver policies. The tenant does not exist.',
            18,
            -1) WITH NOWAIT
GO
/****** Object:  StoredProcedure [dbo].[proc_DeleteCertificate]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_DeleteCertificate]
(
    @Id uniqueidentifier
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@Id) = 0
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_DeleteCertificate')
        RETURN -1
    END

    DECLARE @refCount int = (SELECT COUNT(*) FROM dbo.ServiceCert WHERE Certificate = @Id)
    IF @refCount > 0
    BEGIN
        RAISERROR('There are still service instances associated with this certificate.', 18, 1)
        RETURN -1
    END

    SELECT @refCount = COUNT(*) FROM dbo.TenantCert WHERE Certificate = @Id
    IF @refCount > 0
    BEGIN
        RAISERROR('There are still tenants associated with this certificate.', 18, 1)
        RETURN -1
    END

    DELETE 
        FROM dbo.Certificate
    WHERE Id = @Id
GO
/****** Object:  StoredProcedure [dbo].[proc_DeleteDataSubscription]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[proc_DeleteDataSubscription]
(
    @Id uniqueidentifier
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@Id) = 0
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_DeleteDataSubscription')
        RETURN -1
    END

    DECLARE @subscriptionExists bit = CONVERT(bit, 0)
    DECLARE @tenantId uniqueidentifier

    SELECT 
        @subscriptionExists = CONVERT(bit, 1),
        @tenantId = Tenant
    FROM Subscription
    WHERE Id = @Id

    IF @subscriptionExists = CONVERT(bit, 0)
    BEGIN
       RAISERROR(
            N'The subscription does not exist.',
            18,
            -1) WITH NOWAIT
    END
    ELSE
    BEGIN
        DELETE
            FROM [dbo].[Subscription]
        WHERE Id = @Id
        SELECT @tenantId
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_DeleteServiceCertificate]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_DeleteServiceCertificate]
(
    @ServiceInstanceId uniqueidentifier,
    @CertificateId uniqueidentifier
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@ServiceInstanceId) = 0 OR
       dbo.fn_IsGuidNotEmpty(@CertificateId) = 0
    BEGIN
        RAISERROR(15600, -1, -1, 'proc_DeleteServiceCertificate')
        RETURN -1
    END

    DECLARE @strServiceInstanceId nvarchar(36) = CONVERT(nvarchar(36), @ServiceInstanceId)
    DECLARE @strCertificateId nvarchar(36) = CONVERT(nvarchar(36), @CertificateId)

    IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.ServiceCert WHERE ServiceInstance = @ServiceInstanceId AND Certificate = @CertificateId)
    BEGIN
        RAISERROR(
            N'Certificate %s for service instance %s does not exists.',
            18,
            -1,
            @strCertificateId,
            @strServiceInstanceId) WITH NOWAIT
        RETURN -1
    END

    DELETE SC
    FROM ServiceCert SC
    WHERE ServiceInstance = @ServiceInstanceId AND Certificate = @CertificateId

    IF @@ROWCOUNT <> 1
    BEGIN
        RAISERROR(
            58126,
            11,
            1,
            N'Failed to delete certiciate for service instance. Please try again later.') WITH NOWAIT
        RETURN -1
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_DeleteTenantCert]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_DeleteTenantCert]
(
    @Tenant uniqueidentifier,
    @Certificate uniqueidentifier
)
AS
    SET NOCOUNT ON

    IF @Tenant IS NULL OR
       @Certificate IS NULL
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_DeleteTenantCert')
        RETURN -1
    END

    DECLARE @tenantCertExists bit = CONVERT(bit, 0)

    SELECT 
            @tenantCertExists = CONVERT(bit, 1)
    FROM [dbo].[TenantCert] 
    WHERE Tenant = @Tenant AND Certificate = @Certificate

    IF @tenantCertExists = CONVERT(bit, 0)
    BEGIN
         RAISERROR(
            N'The tenant and certificate pair do not exist in the table TenantCert.',
            18,
            -1) WITH NOWAIT
        RETURN -1
    END

    DELETE 
        FROM TenantCert 
    WHERE Tenant = @Tenant AND Certificate = @Certificate
GO
/****** Object:  StoredProcedure [dbo].[proc_GetActiveTenantsByLastModifiedTime]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[proc_GetActiveTenantsByLastModifiedTime]
(
    @Count int,
    @LastModifiedTime  datetime = NULL
)
AS
    SET NOCOUNT ON

    IF @LastModifiedTime IS NULL
    SELECT @LastModifiedTime = -53690

    IF @Count IS NULL OR @Count < 1
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_GetActiveTenantsByLastModifiedTime')
        RETURN -1
    END

    SELECT TOP (@Count)
        T.Id AS Id,
        T.DataGroup AS DataGroup,
        dbo.fn_DefaultDateTimeIfNull(T.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(T.UpdateTime) AS UpdateTime
    FROM dbo.Tenant T
    WHERE
        T.State = 2 AND
		T.UpdateTime >= @LastModifiedTime
    ORDER BY T.UpdateTime ASC
GO
/****** Object:  StoredProcedure [dbo].[proc_GetAllAuditPolicyData]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetAllAuditPolicyData]
AS
    SET NOCOUNT ON

    SELECT Id
    FROM AuditPolicy
GO
/****** Object:  StoredProcedure [dbo].[proc_GetAllEventHubs]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[proc_GetAllEventHubs]
AS
    SELECT *
    FROM dbo.EventHub
    ORDER BY Id ASC
GO
/****** Object:  StoredProcedure [dbo].[proc_GetAuditPolicyData]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetAuditPolicyData]
(
    @Id uniqueidentifier
)
AS
    SET NOCOUNT ON

    IF @Id IS NULL
        RETURN -1

    SELECT
        PolicyName,
        AADLicense, 
        Type,
        Priority
    FROM AuditPolicy
    WHERE Id = @Id
GO
/****** Object:  StoredProcedure [dbo].[proc_GetCertificate]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetCertificate]
(
    @Id uniqueidentifier,
    @Subject nvarchar(256) = NULL,
    @Thumbprint nvarchar(40) = NULL
)
AS
    SET NOCOUNT ON

    IF @Id IS NULL OR
      (dbo.fn_IsGuidNotEmpty(@Id) = 0 AND
       @Subject IS NULL AND
       @Thumbprint IS NULL)
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_GetCertificate')
        RETURN -1
    END

    IF dbo.fn_IsGuidNotEmpty(@Id) = 1
    BEGIN
        SELECT
            Id,
            Subject,
            Thumbprint,
            ExpireTime,
            Content,
            Password
        FROM [dbo].[Certificate]
        WHERE Id = @Id
    END
    ELSE IF @Subject IS NOT NULL
    BEGIN
        SELECT
            Id,
            Subject,
            Thumbprint,
            ExpireTime,
            Content,
            Password
        FROM [dbo].[Certificate]
        WHERE Subject = @Subject
    END
    ELSE IF @Thumbprint IS NOT NULL
    BEGIN
        SELECT
            Id,
            Subject,
            Thumbprint,
            ExpireTime,
            Content,
            Password
        FROM [dbo].[Certificate]
        WHERE Thumbprint = @Thumbprint
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_GetConfigValue]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-------------------------------- Procedure -------------------------------------

CREATE PROCEDURE [dbo].[proc_GetConfigValue]
(
    @NameSpace nvarchar(32),
    @Name nvarchar(64)
)
AS
    SET NOCOUNT ON

    IF @NameSpace IS NULL OR LEN(LTRIM(RTRIM(@Namespace))) = 0 OR
        @Name IS NULL OR LEN(LTRIM(RTRIM(@Name))) = 0
    BEGIN
        RAISERROR(15600, -1, -1, 'proc_GetConfigValue')
        RETURN -1
    END

    SELECT
        Id,
        NameSpace,
        Name,
        Value
    FROM ConfigValues
    WHERE NameSpace = @NameSpace AND
        Name = @Name
GO
/****** Object:  StoredProcedure [dbo].[proc_GetDataGroup]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------------------------
-- proc_GetDataGroup
--------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[proc_GetDataGroup]
(
    @Id uniqueidentifier
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@Id) = 0
    BEGIN
        RAISERROR(15600, -1, -1, 'proc_GetDataGroup')
        RETURN -1
    END

    SELECT TOP 1 
        S.*
    FROM(
    SELECT
        @Id AS Id,
        DG.Name AS Name,
        DG.Status AS Status,
        DG.Geo AS Geo,
        SB.Status AS PrimaryServiceBusStatus,
        SB.Namespace AS PrimaryServiceBusNameSpace,
        SB.ManagementSharedAccessKeyName AS PrimaryManagementSharedAccessKeyName,
        SB.ManagementSharedAccessKey AS PrimaryManagementSharedAccessKey,
        PSB.Status AS SecondaryServiceBusStatus,
        PSB.Namespace AS SecondaryServiceBusNameSpace,
        PSB.ManagementSharedAccessKeyName AS SecondaryManagementSharedAccessKeyName,
        PSB.ManagementSharedAccessKey AS SecondaryManagementSharedAccessKey,
        ST.Status AS StorageStatus,
        ST.AccountName AS StorageAccountName,
        ST.AccessKey AS StorageAccountKey,
        CH.HostName AS CacheHostName,
        CH.Status AS CacheStatus,
        CH.Ssl AS CacheUseSSL,
        CH.AccessKey AS CacheAccessKey,
        DG.Type AS Type,
        dbo.fn_DefaultInt32IfNull(DG.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(DG.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(DG.UpdateTime) AS UpdateTime,
        dbo.fn_DefaultBitIfNull(DG.AlertEnabled, CONVERT(bit, 0)) AS AlertEnabled,
        ST.ServiceUriSuffix AS StorageServiceUriSuffix
    FROM DataGroup DG
    LEFT OUTER JOIN ServiceBus SB
        ON SB.DataGroup = DG.Id
    CROSS APPLY TVF_ServiceBus_Id(SB.PairServiceBus) PSB
    LEFT OUTER JOIN Storage ST
        ON ST.DataGroup = DG.Id
    LEFT OUTER JOIN Cache CH
        ON CH.DataGroup = DG.Id
    WHERE DG.Id = @Id AND
        dbo.fn_IsServiceBusPaired(SB.Id) = CONVERT(bit, 1) AND
        ST.SiblingOf IS NULL

    UNION ALL

    SELECT
        @Id AS Id,
        DG.Name AS Name,
        DG.Status AS Status,
        DG.Geo AS Geo,
        SB.Status AS PrimaryServiceBusStatus,
        SB.Namespace AS PrimaryServiceBusNameSpace,
        SB.ManagementSharedAccessKeyName AS PrimaryManagementSharedAccessKeyName,
        SB.ManagementSharedAccessKey AS PrimaryManagementSharedAccessKey,
        NULL AS SecondaryServiceBusStatus,
        NULL AS SecondaryServiceBusNameSpace,
        NULL AS SecondaryManagementSharedAccessKeyName,
        NULL AS SecondaryManagementSharedAccessKey,
        ST.Status AS StorageStatus,
        ST.AccountName AS StorageAccountName,
        ST.AccessKey AS StorageAccountKey,
        CH.HostName AS CacheHostName,
        CH.Status AS CacheStatus,
        CH.Ssl AS CacheUseSSL,
        CH.AccessKey AS CacheAccessKey,
        DG.Type AS Type,
        dbo.fn_DefaultInt32IfNull(DG.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(DG.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(DG.UpdateTime) AS UpdateTime,
        dbo.fn_DefaultBitIfNull(DG.AlertEnabled, CONVERT(bit, 0)) AS AlertEnabled,
        ST.ServiceUriSuffix AS StorageServiceUriSuffix
    FROM DataGroup DG
    LEFT OUTER JOIN ServiceBus SB
        ON SB.DataGroup = DG.Id
    LEFT OUTER JOIN Storage ST
        ON ST.DataGroup = DG.Id
    LEFT OUTER JOIN Cache CH
        ON CH.DataGroup = DG.Id
    WHERE DG.Id = @Id AND
        dbo.fn_IsServiceBusPaired(SB.Id) = CONVERT(bit, 0) AND
        ST.SiblingOf IS NULL
    ) S
    OPTION(RECOMPILE, OPTIMIZE FOR UNKNOWN)

    IF @@ROWCOUNT > 0
    SELECT
        Id,
        Name,
        Status,
        AccountName,
        AccessKey,
        ServiceUriSuffix,
        SiblingOf
    FROM TVF_SiblingsStorage_DataGroup(@Id)
GO
/****** Object:  StoredProcedure [dbo].[proc_GetDataGroups]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------------------------
-- proc_GetDataGroups
--------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[proc_GetDataGroups]
(
    @Type int
)
AS
    SET NOCOUNT ON

    SELECT
        S.*
    FROM(
    SELECT
        DG.Id AS Id,
        DG.Name AS Name,
        DG.Status AS Status,
        DG.Geo AS Geo,
        SB.Status AS PrimaryServiceBusStatus,
        SB.Namespace AS PrimaryServiceBusNameSpace,
        SB.ManagementSharedAccessKeyName AS PrimaryManagementSharedAccessKeyName,
        SB.ManagementSharedAccessKey AS PrimaryManagementSharedAccessKey,
        PSB.Status AS SecondaryServiceBusStatus,
        PSB.Namespace AS SecondaryServiceBusNameSpace,
        PSB.ManagementSharedAccessKeyName AS SecondaryManagementSharedAccessKeyName,
        PSB.ManagementSharedAccessKey AS SecondaryManagementSharedAccessKey,
        ST.Status AS StorageStatus,
        ST.AccountName AS StorageAccountName,
        ST.AccessKey AS StorageAccountKey,
        CH.HostName AS CacheHostName,
        CH.Status AS CacheStatus,
        CH.Ssl AS CacheUseSSL,
        CH.AccessKey AS CacheAccessKey,
        DG.Type AS Type,
        dbo.fn_DefaultInt32IfNull(DG.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(DG.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(DG.UpdateTime) AS UpdateTime,
        dbo.fn_DefaultBitIfNull(DG.AlertEnabled, CONVERT(bit, 0)) AS AlertEnabled,
        ST.ServiceUriSuffix AS StorageServiceUriSuffix
    FROM DataGroup DG
    LEFT OUTER JOIN ServiceBus SB
        ON SB.DataGroup = DG.Id
    CROSS APPLY TVF_ServiceBus_Id(SB.PairServiceBus) PSB
    LEFT OUTER JOIN Storage ST
        ON ST.DataGroup = DG.Id
    LEFT OUTER JOIN Cache CH
        ON CH.DataGroup = DG.Id
    WHERE dbo.fn_IsServiceBusPaired(SB.Id) = CONVERT(bit, 1) AND
        (@Type IS NULL OR @Type = DG.Type) AND
        ST.SiblingOf IS NULL

    UNION ALL

    SELECT
        DG.Id AS Id,
        DG.Name AS Name,
        DG.Status AS Status,
        DG.Geo AS Geo,
        SB.Status AS PrimaryServiceBusStatus,
        SB.Namespace AS PrimaryServiceBusNameSpace,
        SB.ManagementSharedAccessKeyName AS PrimaryManagementSharedAccessKeyName,
        SB.ManagementSharedAccessKey AS PrimaryManagementSharedAccessKey,
        NULL AS SecondaryServiceBusStatus,
        NULL AS SecondaryServiceBusNameSpace,
        NULL AS SecondaryManagementSharedAccessKeyName,
        NULL AS SecondaryManagementSharedAccessKey,
        ST.Status AS StorageStatus,
        ST.AccountName AS StorageAccountName,
        ST.AccessKey AS StorageAccountKey,
        CH.HostName AS CacheHostName,
        CH.Status AS CacheStatus,
        CH.Ssl AS CacheUseSSL,
        CH.AccessKey AS CacheAccessKey,
        DG.Type AS Type,
        dbo.fn_DefaultInt32IfNull(DG.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(DG.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(DG.UpdateTime) AS UpdateTime,
        dbo.fn_DefaultBitIfNull(DG.AlertEnabled, CONVERT(bit, 0)) AS AlertEnabled,
        ST.ServiceUriSuffix AS StorageServiceUriSuffix
    FROM DataGroup DG
    LEFT OUTER JOIN ServiceBus SB
        ON SB.DataGroup = DG.Id
    LEFT OUTER JOIN Storage ST
        ON ST.DataGroup = DG.Id
    LEFT OUTER JOIN Cache CH
        ON CH.DataGroup = DG.Id
    WHERE dbo.fn_IsServiceBusPaired(SB.Id) = CONVERT(bit, 0) AND
        (@Type IS NULL OR @Type = DG.Type) AND
        ST.SiblingOf IS NULL
    ) S
    OPTION(RECOMPILE, OPTIMIZE FOR UNKNOWN)

    IF @@ROWCOUNT > 0
    SELECT
        DataGroupId,
        Id,
        Name,
        Status,
        AccountName,
        AccessKey,
        ServiceUriSuffix
    FROM TVF_SiblingsStorage_DataGroupType(@Type)
GO
/****** Object:  StoredProcedure [dbo].[proc_GetDataGroupsForTenant]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetDataGroupsForTenant]
(
    @Id uniqueidentifier
    
)
AS
DECLARE
    @DataGroupId uniqueidentifier
BEGIN
    SET NOCOUNT ON

    DECLARE dataGroup_cursor CURSOR FOR
        SELECT
            T.DataGroup AS Id
        FROM Tenant T
        WHERE (@Id = T.Id)

        UNION ALL

        SELECT
            TM.DataGroup AS Id
        FROM TenantMigration TM
        WHERE @Id = TM.TenantId AND TM.ReadStatus != 42

    OPEN dataGroup_cursor
    
    FETCH NEXT FROM dataGroup_cursor
        INTO @DataGroupId
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dbo.proc_GetDataGroupV2 @Id = @DataGroupId;
        
        FETCH NEXT FROM dataGroup_cursor
            INTO @DataGroupId
    END
    
    CLOSE dataGroup_cursor
    DEALLOCATE dataGroup_cursor
END
GO
/****** Object:  StoredProcedure [dbo].[proc_GetDataGroupsForTenantV2]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetDataGroupsForTenantV2]
(
    @Id uniqueidentifier
)
AS
    SET NOCOUNT ON

    SELECT
        S.*
    FROM(
    SELECT
        DG.Id AS Id,
        DG.Name AS Name,
        DG.Status AS Status,
        DG.Geo AS Geo,
        SB.Status AS PrimaryServiceBusStatus,
        SB.Namespace AS PrimaryServiceBusNameSpace,
        SB.ManagementSharedAccessKeyName AS PrimaryManagementSharedAccessKeyName,
        SB.ManagementSharedAccessKey AS PrimaryManagementSharedAccessKey,
        PSB.Status AS SecondaryServiceBusStatus,
        PSB.Namespace AS SecondaryServiceBusNameSpace,
        PSB.ManagementSharedAccessKeyName AS SecondaryManagementSharedAccessKeyName,
        PSB.ManagementSharedAccessKey AS SecondaryManagementSharedAccessKey,
        ST.Status AS StorageStatus,
        ST.AccountName AS StorageAccountName,
        ST.AccessKey AS StorageAccountKey,
        CH.HostName AS CacheHostName,
        CH.Status AS CacheStatus,
        CH.Ssl AS CacheUseSSL,
        CH.AccessKey AS CacheAccessKey,
        DG.Type AS Type,
        dbo.fn_DefaultInt32IfNull(DG.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(DG.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(DG.UpdateTime) AS UpdateTime,
        dbo.fn_DefaultBitIfNull(DG.AlertEnabled, CONVERT(bit, 0)) AS AlertEnabled,
        ST.ServiceUriSuffix AS StorageServiceUriSuffix,
        MST.Status AS MetadataStorageStatus,
        MST.AccountName AS MetadataStorageAccountName,
        MST.AccessKey AS MetadataStorageAccountKey,
        MST.ServiceUriSuffix AS MetadataStorageServiceUriSuffix
    FROM DataGroup DG
    INNER JOIN Tenant T
        ON T.DataGroup = DG.Id
    LEFT OUTER JOIN ServiceBus SB
        ON SB.DataGroup = DG.Id
    CROSS APPLY TVF_ServiceBus_Id(SB.PairServiceBus) PSB
    LEFT OUTER JOIN Storage ST
        ON ST.DataGroup = DG.Id
    LEFT OUTER JOIN MetadataStorage MST
        ON MST.DataGroup = DG.Id
    LEFT OUTER JOIN Cache CH
        ON CH.DataGroup = DG.Id
    WHERE (@Id = T.Id) AND
        dbo.fn_IsServiceBusPaired(SB.Id) = CONVERT(bit, 1) AND
        ST.SiblingOf IS NULL AND
        MST.SiblingOf IS NULL

    UNION ALL

    SELECT
        DG.Id AS Id,
        DG.Name AS Name,
        DG.Status AS Status,
        DG.Geo AS Geo,
        SB.Status AS PrimaryServiceBusStatus,
        SB.Namespace AS PrimaryServiceBusNameSpace,
        SB.ManagementSharedAccessKeyName AS PrimaryManagementSharedAccessKeyName,
        SB.ManagementSharedAccessKey AS PrimaryManagementSharedAccessKey,
        NULL AS SecondaryServiceBusStatus,
        NULL AS SecondaryServiceBusNameSpace,
        NULL AS SecondaryManagementSharedAccessKeyName,
        NULL AS SecondaryManagementSharedAccessKey,
        ST.Status AS StorageStatus,
        ST.AccountName AS StorageAccountName,
        ST.AccessKey AS StorageAccountKey,
        CH.HostName AS CacheHostName,
        CH.Status AS CacheStatus,
        CH.Ssl AS CacheUseSSL,
        CH.AccessKey AS CacheAccessKey,
        DG.Type AS Type,
        dbo.fn_DefaultInt32IfNull(DG.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(DG.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(DG.UpdateTime) AS UpdateTime,
        dbo.fn_DefaultBitIfNull(DG.AlertEnabled, CONVERT(bit, 0)) AS AlertEnabled,
        ST.ServiceUriSuffix AS StorageServiceUriSuffix,
        MST.Status AS MetadataStorageStatus,
        MST.AccountName AS MetadataStorageAccountName,
        MST.AccessKey AS MetadataStorageAccountKey,
        MST.ServiceUriSuffix AS MetadataStorageServiceUriSuffix
    FROM DataGroup DG
    INNER JOIN Tenant T
        ON T.DataGroup = DG.Id
    LEFT OUTER JOIN ServiceBus SB
        ON SB.DataGroup = DG.Id
    LEFT OUTER JOIN Storage ST
        ON ST.DataGroup = DG.Id
    LEFT OUTER JOIN MetadataStorage MST
        ON MST.DataGroup = DG.Id
    LEFT OUTER JOIN Cache CH
        ON CH.DataGroup = DG.Id
    WHERE (@Id = T.Id) AND
        dbo.fn_IsServiceBusPaired(SB.Id) = CONVERT(bit, 0) AND
        ST.SiblingOf IS NULL AND
        MST.SiblingOf IS NULL
        
    UNION ALL
    
    SELECT
        DG.Id AS Id,
        DG.Name AS Name,
        DG.Status AS Status,
        DG.Geo AS Geo,
        SB.Status AS PrimaryServiceBusStatus,
        SB.Namespace AS PrimaryServiceBusNameSpace,
        SB.ManagementSharedAccessKeyName AS PrimaryManagementSharedAccessKeyName,
        SB.ManagementSharedAccessKey AS PrimaryManagementSharedAccessKey,
        PSB.Status AS SecondaryServiceBusStatus,
        PSB.Namespace AS SecondaryServiceBusNameSpace,
        PSB.ManagementSharedAccessKeyName AS SecondaryManagementSharedAccessKeyName,
        PSB.ManagementSharedAccessKey AS SecondaryManagementSharedAccessKey,
        ST.Status AS StorageStatus,
        ST.AccountName AS StorageAccountName,
        ST.AccessKey AS StorageAccountKey,
        CH.HostName AS CacheHostName,
        CH.Status AS CacheStatus,
        CH.Ssl AS CacheUseSSL,
        CH.AccessKey AS CacheAccessKey,
        DG.Type AS Type,
        dbo.fn_DefaultInt32IfNull(DG.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(DG.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(DG.UpdateTime) AS UpdateTime,
        dbo.fn_DefaultBitIfNull(DG.AlertEnabled, CONVERT(bit, 0)) AS AlertEnabled,
        ST.ServiceUriSuffix AS StorageServiceUriSuffix,
        MST.Status AS MetadataStorageStatus,
        MST.AccountName AS MetadataStorageAccountName,
        MST.AccessKey AS MetadataStorageAccountKey,
        MST.ServiceUriSuffix AS MetadataStorageServiceUriSuffix
    FROM DataGroup DG
    INNER JOIN TenantMigration TM
        ON TM.DataGroup = DG.Id AND TM.ReadStatus != 42
    LEFT OUTER JOIN ServiceBus SB
        ON SB.DataGroup = DG.Id
    CROSS APPLY TVF_ServiceBus_Id(SB.PairServiceBus) PSB
    LEFT OUTER JOIN Storage ST
        ON ST.DataGroup = DG.Id
    LEFT OUTER JOIN MetadataStorage MST
        ON MST.DataGroup = DG.Id
    LEFT OUTER JOIN Cache CH
        ON CH.DataGroup = DG.Id
    WHERE @Id = TM.TenantId AND
        dbo.fn_IsServiceBusPaired(SB.Id) = CONVERT(bit, 1) AND
        ST.SiblingOf IS NULL AND
        MST.SiblingOf IS NULL

    UNION ALL

    SELECT
        DG.Id AS Id,
        DG.Name AS Name,
        DG.Status AS Status,
        DG.Geo AS Geo,
        SB.Status AS PrimaryServiceBusStatus,
        SB.Namespace AS PrimaryServiceBusNameSpace,
        SB.ManagementSharedAccessKeyName AS PrimaryManagementSharedAccessKeyName,
        SB.ManagementSharedAccessKey AS PrimaryManagementSharedAccessKey,
        NULL AS SecondaryServiceBusStatus,
        NULL AS SecondaryServiceBusNameSpace,
        NULL AS SecondaryManagementSharedAccessKeyName,
        NULL AS SecondaryManagementSharedAccessKey,
        ST.Status AS StorageStatus,
        ST.AccountName AS StorageAccountName,
        ST.AccessKey AS StorageAccountKey,
        CH.HostName AS CacheHostName,
        CH.Status AS CacheStatus,
        CH.Ssl AS CacheUseSSL,
        CH.AccessKey AS CacheAccessKey,
        DG.Type AS Type,
        dbo.fn_DefaultInt32IfNull(DG.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(DG.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(DG.UpdateTime) AS UpdateTime,
        dbo.fn_DefaultBitIfNull(DG.AlertEnabled, CONVERT(bit, 0)) AS AlertEnabled,
        ST.ServiceUriSuffix AS StorageServiceUriSuffix,
        MST.Status AS MetadataStorageStatus,
        MST.AccountName AS MetadataStorageAccountName,
        MST.AccessKey AS MetadataStorageAccountKey,
        MST.ServiceUriSuffix AS MetadataStorageServiceUriSuffix
    FROM DataGroup DG
    INNER JOIN TenantMigration TM
        ON TM.DataGroup = DG.Id AND TM.ReadStatus != 42
    LEFT OUTER JOIN ServiceBus SB
        ON SB.DataGroup = DG.Id
    LEFT OUTER JOIN Storage ST
        ON ST.DataGroup = DG.Id
    LEFT OUTER JOIN MetadataStorage MST
        ON MST.DataGroup = DG.Id
    LEFT OUTER JOIN Cache CH
        ON CH.DataGroup = DG.Id
    WHERE @Id = TM.TenantId AND
        dbo.fn_IsServiceBusPaired(SB.Id) = CONVERT(bit, 0) AND
        ST.SiblingOf IS NULL AND
        MST.SiblingOf IS NULL
    ) S
    OPTION(RECOMPILE, OPTIMIZE FOR UNKNOWN)

    IF @@ROWCOUNT > 0
    BEGIN
    SELECT
        DataGroupId,
        Id,
        Name,
        Status,
        AccountName,
        AccessKey,
        ServiceUriSuffix
    FROM TVF_SiblingsStorage_Tenant_DataGroup(@Id)

    SELECT
        DataGroupId,
        Id,
        Name,
        Status,
        AccountName,
        AccessKey,
        ServiceUriSuffix
    FROM TVF_SiblingsMetadataStorage_Tenant_DataGroup(@Id)
    
    SELECT *
    FROM TVF_EventHubs_Tenant_DataGroup(@Id)
    
    SELECT *
    FROM TVF_DispatcherEndPoint_Tenant_DataGroup(@Id)
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_GetDataGroupsForTenantV3]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetDataGroupsForTenantV3]
(
    @Id uniqueidentifier
)
AS
    DECLARE @DataGroupIdForTenant uniqueidentifier
    
    SET NOCOUNT ON
    SET @DataGroupIdForTenant = (SELECT DataGroup FROM Tenant WHERE Tenant.Id = @Id)

    SELECT
        S.*
    FROM(
    SELECT
        DG.Id AS Id,
        DG.Name AS Name,
        DG.Status AS Status,
        DG.Geo AS Geo,
        SB.Status AS PrimaryServiceBusStatus,
        SB.Namespace AS PrimaryServiceBusNameSpace,
        SB.ManagementSharedAccessKeyName AS PrimaryManagementSharedAccessKeyName,
        SB.ManagementSharedAccessKey AS PrimaryManagementSharedAccessKey,
        PSB.Status AS SecondaryServiceBusStatus,
        PSB.Namespace AS SecondaryServiceBusNameSpace,
        PSB.ManagementSharedAccessKeyName AS SecondaryManagementSharedAccessKeyName,
        PSB.ManagementSharedAccessKey AS SecondaryManagementSharedAccessKey,
        ST.Status AS StorageStatus,
        ST.AccountName AS StorageAccountName,
        ST.AccessKey AS StorageAccountKey,
        CH.HostName AS CacheHostName,
        CH.Status AS CacheStatus,
        CH.Ssl AS CacheUseSSL,
        CH.AccessKey AS CacheAccessKey,
        DG.Type AS Type,
        dbo.fn_DefaultInt32IfNull(DG.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(DG.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(DG.UpdateTime) AS UpdateTime,
        dbo.fn_DefaultBitIfNull(DG.AlertEnabled, CONVERT(bit, 0)) AS AlertEnabled,
        ST.ServiceUriSuffix AS StorageServiceUriSuffix,
        MST.Status AS MetadataStorageStatus,
        MST.AccountName AS MetadataStorageAccountName,
        MST.AccessKey AS MetadataStorageAccountKey,
        MST.ServiceUriSuffix AS MetadataStorageServiceUriSuffix
    FROM DataGroup DG
    INNER JOIN Tenant T
        ON T.DataGroup = DG.Id
    LEFT OUTER JOIN ServiceBus SB
        ON SB.DataGroup = DG.Id
    CROSS APPLY TVF_ServiceBus_Id(SB.PairServiceBus) PSB
    LEFT OUTER JOIN Storage ST
        ON ST.DataGroup = DG.Id
    LEFT OUTER JOIN MetadataStorage MST
        ON MST.DataGroup = DG.Id
    LEFT OUTER JOIN Cache CH
        ON CH.DataGroup = DG.Id
    WHERE (@Id = T.Id) AND
        dbo.fn_IsServiceBusPaired(SB.Id) = CONVERT(bit, 1) AND
        ST.SiblingOf IS NULL AND
        MST.SiblingOf IS NULL

    UNION ALL

    SELECT
        DG.Id AS Id,
        DG.Name AS Name,
        DG.Status AS Status,
        DG.Geo AS Geo,
        SB.Status AS PrimaryServiceBusStatus,
        SB.Namespace AS PrimaryServiceBusNameSpace,
        SB.ManagementSharedAccessKeyName AS PrimaryManagementSharedAccessKeyName,
        SB.ManagementSharedAccessKey AS PrimaryManagementSharedAccessKey,
        NULL AS SecondaryServiceBusStatus,
        NULL AS SecondaryServiceBusNameSpace,
        NULL AS SecondaryManagementSharedAccessKeyName,
        NULL AS SecondaryManagementSharedAccessKey,
        ST.Status AS StorageStatus,
        ST.AccountName AS StorageAccountName,
        ST.AccessKey AS StorageAccountKey,
        CH.HostName AS CacheHostName,
        CH.Status AS CacheStatus,
        CH.Ssl AS CacheUseSSL,
        CH.AccessKey AS CacheAccessKey,
        DG.Type AS Type,
        dbo.fn_DefaultInt32IfNull(DG.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(DG.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(DG.UpdateTime) AS UpdateTime,
        dbo.fn_DefaultBitIfNull(DG.AlertEnabled, CONVERT(bit, 0)) AS AlertEnabled,
        ST.ServiceUriSuffix AS StorageServiceUriSuffix,
        MST.Status AS MetadataStorageStatus,
        MST.AccountName AS MetadataStorageAccountName,
        MST.AccessKey AS MetadataStorageAccountKey,
        MST.ServiceUriSuffix AS MetadataStorageServiceUriSuffix
    FROM DataGroup DG
    INNER JOIN Tenant T
        ON T.DataGroup = DG.Id
    LEFT OUTER JOIN ServiceBus SB
        ON SB.DataGroup = DG.Id
    LEFT OUTER JOIN Storage ST
        ON ST.DataGroup = DG.Id
    LEFT OUTER JOIN MetadataStorage MST
        ON MST.DataGroup = DG.Id
    LEFT OUTER JOIN Cache CH
        ON CH.DataGroup = DG.Id
    WHERE (@Id = T.Id) AND
        dbo.fn_IsServiceBusPaired(SB.Id) = CONVERT(bit, 0) AND
        ST.SiblingOf IS NULL AND
        MST.SiblingOf IS NULL
        
    UNION ALL
    
    SELECT
        DG.Id AS Id,
        DG.Name AS Name,
        DG.Status AS Status,
        DG.Geo AS Geo,
        SB.Status AS PrimaryServiceBusStatus,
        SB.Namespace AS PrimaryServiceBusNameSpace,
        SB.ManagementSharedAccessKeyName AS PrimaryManagementSharedAccessKeyName,
        SB.ManagementSharedAccessKey AS PrimaryManagementSharedAccessKey,
        PSB.Status AS SecondaryServiceBusStatus,
        PSB.Namespace AS SecondaryServiceBusNameSpace,
        PSB.ManagementSharedAccessKeyName AS SecondaryManagementSharedAccessKeyName,
        PSB.ManagementSharedAccessKey AS SecondaryManagementSharedAccessKey,
        ST.Status AS StorageStatus,
        ST.AccountName AS StorageAccountName,
        ST.AccessKey AS StorageAccountKey,
        CH.HostName AS CacheHostName,
        CH.Status AS CacheStatus,
        CH.Ssl AS CacheUseSSL,
        CH.AccessKey AS CacheAccessKey,
        DG.Type AS Type,
        dbo.fn_DefaultInt32IfNull(DG.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(DG.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(DG.UpdateTime) AS UpdateTime,
        dbo.fn_DefaultBitIfNull(DG.AlertEnabled, CONVERT(bit, 0)) AS AlertEnabled,
        ST.ServiceUriSuffix AS StorageServiceUriSuffix,
        MST.Status AS MetadataStorageStatus,
        MST.AccountName AS MetadataStorageAccountName,
        MST.AccessKey AS MetadataStorageAccountKey,
        MST.ServiceUriSuffix AS MetadataStorageServiceUriSuffix
    FROM DataGroup DG
    INNER JOIN TenantMigration TM
        ON TM.DataGroup = DG.Id AND TM.ReadStatus != 42
    LEFT OUTER JOIN ServiceBus SB
        ON SB.DataGroup = DG.Id
    CROSS APPLY TVF_ServiceBus_Id(SB.PairServiceBus) PSB
    LEFT OUTER JOIN Storage ST
        ON ST.DataGroup = DG.Id
    LEFT OUTER JOIN MetadataStorage MST
        ON MST.DataGroup = DG.Id
    LEFT OUTER JOIN Cache CH
        ON CH.DataGroup = DG.Id
    WHERE @Id = TM.TenantId AND
        dbo.fn_IsServiceBusPaired(SB.Id) = CONVERT(bit, 1) AND
        ST.SiblingOf IS NULL AND
        MST.SiblingOf IS NULL

    UNION ALL

    SELECT
        DG.Id AS Id,
        DG.Name AS Name,
        DG.Status AS Status,
        DG.Geo AS Geo,
        SB.Status AS PrimaryServiceBusStatus,
        SB.Namespace AS PrimaryServiceBusNameSpace,
        SB.ManagementSharedAccessKeyName AS PrimaryManagementSharedAccessKeyName,
        SB.ManagementSharedAccessKey AS PrimaryManagementSharedAccessKey,
        NULL AS SecondaryServiceBusStatus,
        NULL AS SecondaryServiceBusNameSpace,
        NULL AS SecondaryManagementSharedAccessKeyName,
        NULL AS SecondaryManagementSharedAccessKey,
        ST.Status AS StorageStatus,
        ST.AccountName AS StorageAccountName,
        ST.AccessKey AS StorageAccountKey,
        CH.HostName AS CacheHostName,
        CH.Status AS CacheStatus,
        CH.Ssl AS CacheUseSSL,
        CH.AccessKey AS CacheAccessKey,
        DG.Type AS Type,
        dbo.fn_DefaultInt32IfNull(DG.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(DG.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(DG.UpdateTime) AS UpdateTime,
        dbo.fn_DefaultBitIfNull(DG.AlertEnabled, CONVERT(bit, 0)) AS AlertEnabled,
        ST.ServiceUriSuffix AS StorageServiceUriSuffix,
        MST.Status AS MetadataStorageStatus,
        MST.AccountName AS MetadataStorageAccountName,
        MST.AccessKey AS MetadataStorageAccountKey,
        MST.ServiceUriSuffix AS MetadataStorageServiceUriSuffix
    FROM DataGroup DG
    INNER JOIN TenantMigration TM
        ON TM.DataGroup = DG.Id AND TM.ReadStatus != 42
    LEFT OUTER JOIN ServiceBus SB
        ON SB.DataGroup = DG.Id
    LEFT OUTER JOIN Storage ST
        ON ST.DataGroup = DG.Id
    LEFT OUTER JOIN MetadataStorage MST
        ON MST.DataGroup = DG.Id
    LEFT OUTER JOIN Cache CH
        ON CH.DataGroup = DG.Id
    WHERE @Id = TM.TenantId AND
        dbo.fn_IsServiceBusPaired(SB.Id) = CONVERT(bit, 0) AND
        ST.SiblingOf IS NULL AND
        MST.SiblingOf IS NULL
    ) S
    OPTION(RECOMPILE, OPTIMIZE FOR UNKNOWN)

    IF @@ROWCOUNT > 0
    BEGIN
    SELECT
        DataGroupId,
        Id,
        Name,
        Status,
        AccountName,
        AccessKey,
        ServiceUriSuffix
    FROM TVF_SiblingsStorage_Tenant_DataGroup(@Id)

    SELECT
        DataGroupId,
        Id,
        Name,
        Status,
        AccountName,
        AccessKey,
        ServiceUriSuffix
    FROM TVF_SiblingsMetadataStorage_Tenant_DataGroup(@Id)
    
    SELECT  Id,
            Name,
            DataGroup,
            Status,
            PairEventHub,
            Geo,
            Namespace,
            ManagementSharedAccessKeyName,
            ManagementSharedAccessKey,
            EntityPath,
            IsDedicated
    FROM TVF_EventHubs_Tenant_DataGroup(@Id)
    
    SELECT  Id,
            Endpoint,
            DataGroup
    FROM TVF_DispatcherEndPoint_Tenant_DataGroup(@Id)
    END

    EXEC dbo.proc_GetPolicyStorageAccount @DataGroupId = @DataGroupIdForTenant

    EXEC dbo.proc_GetServiceEndpoint  @DataGroupId = @DataGroupIdForTenant, @AuditServiceName = "PolicySyncService"
GO
/****** Object:  StoredProcedure [dbo].[proc_GetDataGroupsForTenantV4]    Script Date: 10/26/2020 9:05:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetDataGroupsForTenantV4]
(
    @Id uniqueidentifier
)
AS
    DECLARE @DataGroupIdForTenant uniqueidentifier
    
    SET NOCOUNT ON
    SET @DataGroupIdForTenant = (SELECT DataGroup FROM Tenant WHERE Tenant.Id = @Id)

    SELECT
        S.*
    FROM(
    SELECT
        DG.Id AS Id
    FROM DataGroup DG
    INNER JOIN Tenant T
        ON T.DataGroup = DG.Id
	WHERE (@Id = T.Id)

    UNION ALL

    SELECT
        DG.Id AS Id
    FROM DataGroup DG
    INNER JOIN TenantMigration TM
        ON TM.DataGroup = DG.Id AND TM.ReadStatus != 42
    WHERE @Id = TM.TenantId
    ) S
    OPTION(RECOMPILE, OPTIMIZE FOR UNKNOWN)
GO
/****** Object:  StoredProcedure [dbo].[proc_GetDataGroupStatus]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetDataGroupStatus]

AS   
    BEGIN
	   SET NOCOUNT ON;
	    SELECT dg.[Geo] AS DataGroupLocation
       ,COUNT(Tnt.Id) AS TotalCountOfTenants
	   ,COUNT(DISTINCT dg.Id) AS TotalCountOfDataGroup
	    FROM [dbo].[DataGroup]  dg JOIN  [dbo].[Tenant] Tnt ON dg.[Id] = Tnt.DataGroup
        WHERE dg.Type=1 and dg.status = 1 and dg.state = 2
	    GROUP BY dg.[Geo]
    
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_GetDataGroupsV2]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetDataGroupsV2]
(
    @Type int
)
AS
    SET NOCOUNT ON

    SELECT
        S.*
    FROM(
    SELECT
        DG.Id AS Id,
        DG.Name AS Name,
        DG.Status AS Status,
        DG.Geo AS Geo,
        SB.Status AS PrimaryServiceBusStatus,
        SB.Namespace AS PrimaryServiceBusNameSpace,
        SB.ManagementSharedAccessKeyName AS PrimaryManagementSharedAccessKeyName,
        SB.ManagementSharedAccessKey AS PrimaryManagementSharedAccessKey,
        PSB.Status AS SecondaryServiceBusStatus,
        PSB.Namespace AS SecondaryServiceBusNameSpace,
        PSB.ManagementSharedAccessKeyName AS SecondaryManagementSharedAccessKeyName,
        PSB.ManagementSharedAccessKey AS SecondaryManagementSharedAccessKey,
        ST.Status AS StorageStatus,
        ST.AccountName AS StorageAccountName,
        ST.AccessKey AS StorageAccountKey,
        CH.HostName AS CacheHostName,
        CH.Status AS CacheStatus,
        CH.Ssl AS CacheUseSSL,
        CH.AccessKey AS CacheAccessKey,
        DG.Type AS Type,
        dbo.fn_DefaultInt32IfNull(DG.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(DG.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(DG.UpdateTime) AS UpdateTime,
        dbo.fn_DefaultBitIfNull(DG.AlertEnabled, CONVERT(bit, 0)) AS AlertEnabled,
        ST.ServiceUriSuffix AS StorageServiceUriSuffix,
        MST.Status AS MetadataStorageStatus,
        MST.AccountName AS MetadataStorageAccountName,
        MST.AccessKey AS MetadataStorageAccountKey,
        MST.ServiceUriSuffix AS MetadataStorageServiceUriSuffix
    FROM DataGroup DG
    LEFT OUTER JOIN ServiceBus SB
        ON SB.DataGroup = DG.Id
    CROSS APPLY TVF_ServiceBus_Id(SB.PairServiceBus) PSB
    LEFT OUTER JOIN Storage ST
        ON ST.DataGroup = DG.Id
    LEFT OUTER JOIN MetadataStorage MST
        ON MST.DataGroup = DG.Id
    LEFT OUTER JOIN Cache CH
        ON CH.DataGroup = DG.Id
    WHERE (@Type IS NULL OR @Type = DG.Type) AND
        dbo.fn_IsServiceBusPaired(SB.Id) = CONVERT(bit, 1) AND
        ST.SiblingOf IS NULL AND
        MST.SiblingOf IS NULL

    UNION ALL

    SELECT
        DG.Id AS Id,
        DG.Name AS Name,
        DG.Status AS Status,
        DG.Geo AS Geo,
        SB.Status AS PrimaryServiceBusStatus,
        SB.Namespace AS PrimaryServiceBusNameSpace,
        SB.ManagementSharedAccessKeyName AS PrimaryManagementSharedAccessKeyName,
        SB.ManagementSharedAccessKey AS PrimaryManagementSharedAccessKey,
        NULL AS SecondaryServiceBusStatus,
        NULL AS SecondaryServiceBusNameSpace,
        NULL AS SecondaryManagementSharedAccessKeyName,
        NULL AS SecondaryManagementSharedAccessKey,
        ST.Status AS StorageStatus,
        ST.AccountName AS StorageAccountName,
        ST.AccessKey AS StorageAccountKey,
        CH.HostName AS CacheHostName,
        CH.Status AS CacheStatus,
        CH.Ssl AS CacheUseSSL,
        CH.AccessKey AS CacheAccessKey,
        DG.Type AS Type,
        dbo.fn_DefaultInt32IfNull(DG.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(DG.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(DG.UpdateTime) AS UpdateTime,
        dbo.fn_DefaultBitIfNull(DG.AlertEnabled, CONVERT(bit, 0)) AS AlertEnabled,
        ST.ServiceUriSuffix AS StorageServiceUriSuffix,
        MST.Status AS MetadataStorageStatus,
        MST.AccountName AS MetadataStorageAccountName,
        MST.AccessKey AS MetadataStorageAccountKey,
        MST.ServiceUriSuffix AS MetadataStorageServiceUriSuffix
    FROM DataGroup DG
    LEFT OUTER JOIN ServiceBus SB
        ON SB.DataGroup = DG.Id
    LEFT OUTER JOIN Storage ST
        ON ST.DataGroup = DG.Id
    LEFT OUTER JOIN MetadataStorage MST
        ON MST.DataGroup = DG.Id
    LEFT OUTER JOIN Cache CH
        ON CH.DataGroup = DG.Id
    WHERE (@Type IS NULL OR @Type = DG.Type) AND
        dbo.fn_IsServiceBusPaired(SB.Id) = CONVERT(bit, 0) AND
        ST.SiblingOf IS NULL AND
        MST.SiblingOf IS NULL
    ) S
    OPTION(RECOMPILE, OPTIMIZE FOR UNKNOWN)

    IF @@ROWCOUNT > 0
    BEGIN
    SELECT
        DataGroupId,
        Id,
        Name,
        Status,
        AccountName,
        AccessKey,
        ServiceUriSuffix
    FROM TVF_SiblingsStorage_DataGroupType(@Type)

    SELECT
        DataGroupId,
        Id,
        Name,
        Status,
        AccountName,
        AccessKey,
        ServiceUriSuffix
    FROM TVF_SiblingsMetadataStorage_DataGroupType(@Type)
    
    SELECT EH.*
    FROM dbo.EventHub EH
    INNER JOIN DataGroup DG
        ON EH.DataGroup = DG.Id
    WHERE @Type IS NULL OR @Type = DG.Type;
    
    SELECT DE.*
    FROM dbo.DispatcherEndpoint DE
    INNER JOIN DataGroup DG
        ON DE.DataGroup = DG.Id
    WHERE @Type IS NULL OR @Type = DG.Type
    ORDER BY Id ASC
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_GetDataGroupsV3]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetDataGroupsV3]
(
    @Type int
)
AS
    SET NOCOUNT ON

    SELECT
        S.*
    FROM(
    SELECT
        DG.Id AS Id,
        DG.Name AS Name,
        DG.Status AS Status,
        DG.Geo AS Geo,
        SB.Status AS PrimaryServiceBusStatus,
        SB.Namespace AS PrimaryServiceBusNameSpace,
        SB.ManagementSharedAccessKeyName AS PrimaryManagementSharedAccessKeyName,
        SB.ManagementSharedAccessKey AS PrimaryManagementSharedAccessKey,
        PSB.Status AS SecondaryServiceBusStatus,
        PSB.Namespace AS SecondaryServiceBusNameSpace,
        PSB.ManagementSharedAccessKeyName AS SecondaryManagementSharedAccessKeyName,
        PSB.ManagementSharedAccessKey AS SecondaryManagementSharedAccessKey,
        ST.Status AS StorageStatus,
        ST.AccountName AS StorageAccountName,
        ST.AccessKey AS StorageAccountKey,
        CH.HostName AS CacheHostName,
        CH.Status AS CacheStatus,
        CH.Ssl AS CacheUseSSL,
        CH.AccessKey AS CacheAccessKey,
        DG.Type AS Type,
        dbo.fn_DefaultInt32IfNull(DG.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(DG.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(DG.UpdateTime) AS UpdateTime,
        dbo.fn_DefaultBitIfNull(DG.AlertEnabled, CONVERT(bit, 0)) AS AlertEnabled,
        ST.ServiceUriSuffix AS StorageServiceUriSuffix,
        MST.Status AS MetadataStorageStatus,
        MST.AccountName AS MetadataStorageAccountName,
        MST.AccessKey AS MetadataStorageAccountKey,
        MST.ServiceUriSuffix AS MetadataStorageServiceUriSuffix
    FROM DataGroup DG
    LEFT OUTER JOIN ServiceBus SB
        ON SB.DataGroup = DG.Id
    CROSS APPLY TVF_ServiceBus_Id(SB.PairServiceBus) PSB
    LEFT OUTER JOIN Storage ST
        ON ST.DataGroup = DG.Id
    LEFT OUTER JOIN MetadataStorage MST
        ON MST.DataGroup = DG.Id
    LEFT OUTER JOIN Cache CH
        ON CH.DataGroup = DG.Id
    WHERE (@Type IS NULL OR @Type = DG.Type) AND
        dbo.fn_IsServiceBusPaired(SB.Id) = CONVERT(bit, 1) AND
        ST.SiblingOf IS NULL AND
        MST.SiblingOf IS NULL

    UNION ALL

    SELECT
        DG.Id AS Id,
        DG.Name AS Name,
        DG.Status AS Status,
        DG.Geo AS Geo,
        SB.Status AS PrimaryServiceBusStatus,
        SB.Namespace AS PrimaryServiceBusNameSpace,
        SB.ManagementSharedAccessKeyName AS PrimaryManagementSharedAccessKeyName,
        SB.ManagementSharedAccessKey AS PrimaryManagementSharedAccessKey,
        NULL AS SecondaryServiceBusStatus,
        NULL AS SecondaryServiceBusNameSpace,
        NULL AS SecondaryManagementSharedAccessKeyName,
        NULL AS SecondaryManagementSharedAccessKey,
        ST.Status AS StorageStatus,
        ST.AccountName AS StorageAccountName,
        ST.AccessKey AS StorageAccountKey,
        CH.HostName AS CacheHostName,
        CH.Status AS CacheStatus,
        CH.Ssl AS CacheUseSSL,
        CH.AccessKey AS CacheAccessKey,
        DG.Type AS Type,
        dbo.fn_DefaultInt32IfNull(DG.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(DG.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(DG.UpdateTime) AS UpdateTime,
        dbo.fn_DefaultBitIfNull(DG.AlertEnabled, CONVERT(bit, 0)) AS AlertEnabled,
        ST.ServiceUriSuffix AS StorageServiceUriSuffix,
        MST.Status AS MetadataStorageStatus,
        MST.AccountName AS MetadataStorageAccountName,
        MST.AccessKey AS MetadataStorageAccountKey,
        MST.ServiceUriSuffix AS MetadataStorageServiceUriSuffix
    FROM DataGroup DG
    LEFT OUTER JOIN ServiceBus SB
        ON SB.DataGroup = DG.Id
    LEFT OUTER JOIN Storage ST
        ON ST.DataGroup = DG.Id
    LEFT OUTER JOIN MetadataStorage MST
        ON MST.DataGroup = DG.Id
    LEFT OUTER JOIN Cache CH
        ON CH.DataGroup = DG.Id
    WHERE (@Type IS NULL OR @Type = DG.Type) AND
        dbo.fn_IsServiceBusPaired(SB.Id) = CONVERT(bit, 0) AND
        ST.SiblingOf IS NULL AND
        MST.SiblingOf IS NULL
    ) S
    OPTION(RECOMPILE, OPTIMIZE FOR UNKNOWN)

    IF @@ROWCOUNT > 0
    BEGIN
    SELECT
        DataGroupId,
        Id,
        Name,
        Status,
        AccountName,
        AccessKey,
        ServiceUriSuffix
    FROM TVF_SiblingsStorage_DataGroupType(@Type)

    SELECT
        DataGroupId,
        Id,
        Name,
        Status,
        AccountName,
        AccessKey,
        ServiceUriSuffix
    FROM TVF_SiblingsMetadataStorage_DataGroupType(@Type)
    
    SELECT EH.*
    FROM dbo.EventHub EH
    INNER JOIN DataGroup DG
        ON EH.DataGroup = DG.Id
    WHERE @Type IS NULL OR @Type = DG.Type;
    
    SELECT DE.*
    FROM dbo.DispatcherEndpoint DE
    INNER JOIN DataGroup DG
        ON DE.DataGroup = DG.Id
    WHERE @Type IS NULL OR @Type = DG.Type
    ORDER BY Id ASC

    EXEC dbo.proc_GetPolicyStorageAccount @DataGroupId = NULL

    EXEC dbo.proc_GetServiceEndpoint  @DataGroupId = NULL, @AuditServiceName = "PolicySyncService"

    END
GO
/****** Object:  StoredProcedure [dbo].[proc_GetDataGroupV2]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetDataGroupV2]
(
    @Id uniqueidentifier
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@Id) = 0
    BEGIN
        RAISERROR(15600, -1, -1, 'proc_GetDataGroup')
        RETURN -1
    END

    SELECT TOP 1 
        S.*
    FROM(
    SELECT
        @Id AS Id,
        DG.Name AS Name,
        DG.Status AS Status,
        DG.Geo AS Geo,
        SB.Status AS PrimaryServiceBusStatus,
        SB.Namespace AS PrimaryServiceBusNameSpace,
        SB.ManagementSharedAccessKeyName AS PrimaryManagementSharedAccessKeyName,
        SB.ManagementSharedAccessKey AS PrimaryManagementSharedAccessKey,
        PSB.Status AS SecondaryServiceBusStatus,
        PSB.Namespace AS SecondaryServiceBusNameSpace,
        PSB.ManagementSharedAccessKeyName AS SecondaryManagementSharedAccessKeyName,
        PSB.ManagementSharedAccessKey AS SecondaryManagementSharedAccessKey,
        ST.Status AS StorageStatus,
        ST.AccountName AS StorageAccountName,
        ST.AccessKey AS StorageAccountKey,
        CH.HostName AS CacheHostName,
        CH.Status AS CacheStatus,
        CH.Ssl AS CacheUseSSL,
        CH.AccessKey AS CacheAccessKey,
        DG.Type AS Type,
        dbo.fn_DefaultInt32IfNull(DG.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(DG.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(DG.UpdateTime) AS UpdateTime,
        dbo.fn_DefaultBitIfNull(DG.AlertEnabled, CONVERT(bit, 0)) AS AlertEnabled,
        ST.ServiceUriSuffix AS StorageServiceUriSuffix,
        MST.Status AS MetadataStorageStatus,
        MST.AccountName AS MetadataStorageAccountName,
        MST.AccessKey AS MetadataStorageAccountKey,
        MST.ServiceUriSuffix AS MetadataStorageServiceUriSuffix
    FROM DataGroup DG
    LEFT OUTER JOIN ServiceBus SB
        ON SB.DataGroup = DG.Id
    CROSS APPLY TVF_ServiceBus_Id(SB.PairServiceBus) PSB
    LEFT OUTER JOIN Storage ST
        ON ST.DataGroup = DG.Id
    LEFT OUTER JOIN MetadataStorage MST
        ON MST.DataGroup = DG.Id
    LEFT OUTER JOIN Cache CH
        ON CH.DataGroup = DG.Id
    WHERE DG.Id = @Id AND
        dbo.fn_IsServiceBusPaired(SB.Id) = CONVERT(bit, 1) AND
        ST.SiblingOf IS NULL AND
        MST.SiblingOf IS NULL

    UNION ALL

    SELECT
        @Id AS Id,
        DG.Name AS Name,
        DG.Status AS Status,
        DG.Geo AS Geo,
        SB.Status AS PrimaryServiceBusStatus,
        SB.Namespace AS PrimaryServiceBusNameSpace,
        SB.ManagementSharedAccessKeyName AS PrimaryManagementSharedAccessKeyName,
        SB.ManagementSharedAccessKey AS PrimaryManagementSharedAccessKey,
        NULL AS SecondaryServiceBusStatus,
        NULL AS SecondaryServiceBusNameSpace,
        NULL AS SecondaryManagementSharedAccessKeyName,
        NULL AS SecondaryManagementSharedAccessKey,
        ST.Status AS StorageStatus,
        ST.AccountName AS StorageAccountName,
        ST.AccessKey AS StorageAccountKey,
        CH.HostName AS CacheHostName,
        CH.Status AS CacheStatus,
        CH.Ssl AS CacheUseSSL,
        CH.AccessKey AS CacheAccessKey,
        DG.Type AS Type,
        dbo.fn_DefaultInt32IfNull(DG.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(DG.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(DG.UpdateTime) AS UpdateTime,
        dbo.fn_DefaultBitIfNull(DG.AlertEnabled, CONVERT(bit, 0)) AS AlertEnabled,
        ST.ServiceUriSuffix AS StorageServiceUriSuffix,
        MST.Status AS MetadataStorageStatus,
        MST.AccountName AS MetadataStorageAccountName,
        MST.AccessKey AS MetadataStorageAccountKey,
        MST.ServiceUriSuffix AS MetadataStorageServiceUriSuffix
    FROM DataGroup DG
    LEFT OUTER JOIN ServiceBus SB
        ON SB.DataGroup = DG.Id
    LEFT OUTER JOIN Storage ST
        ON ST.DataGroup = DG.Id
    LEFT OUTER JOIN MetadataStorage MST
        ON MST.DataGroup = DG.Id
    LEFT OUTER JOIN Cache CH
        ON CH.DataGroup = DG.Id
    WHERE DG.Id = @Id AND
        dbo.fn_IsServiceBusPaired(SB.Id) = CONVERT(bit, 0) AND
        ST.SiblingOf IS NULL AND
        MST.SiblingOf IS NULL
    ) S
    OPTION(RECOMPILE, OPTIMIZE FOR UNKNOWN)

    IF @@ROWCOUNT > 0
    BEGIN
    SELECT
        Id,
        Name,
        Status,
        AccountName,
        AccessKey,
        ServiceUriSuffix,
        SiblingOf
    FROM TVF_SiblingsStorage_DataGroup(@Id)

    SELECT
        Id,
        Name,
        Status,
        AccountName,
        AccessKey,
        ServiceUriSuffix
    FROM TVF_SiblingsMetadataStorage_DataGroup(@Id)
    
    SELECT *
    FROM dbo.EventHub where DataGroup = @Id;
    
    EXEC dbo.proc_GetDispatcherByDataGroup @DataGroupId = @Id
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_GetDataGroupV3]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetDataGroupV3]
(
    @Id uniqueidentifier
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@Id) = 0
    BEGIN
        RAISERROR(15600, -1, -1, 'proc_GetDataGroup')
        RETURN -1
    END

    SELECT TOP 1 
        S.*
    FROM(
    SELECT
        @Id AS Id,
        DG.Name AS Name,
        DG.Status AS Status,
        DG.Geo AS Geo,
        SB.Status AS PrimaryServiceBusStatus,
        SB.Namespace AS PrimaryServiceBusNameSpace,
        SB.ManagementSharedAccessKeyName AS PrimaryManagementSharedAccessKeyName,
        SB.ManagementSharedAccessKey AS PrimaryManagementSharedAccessKey,
        PSB.Status AS SecondaryServiceBusStatus,
        PSB.Namespace AS SecondaryServiceBusNameSpace,
        PSB.ManagementSharedAccessKeyName AS SecondaryManagementSharedAccessKeyName,
        PSB.ManagementSharedAccessKey AS SecondaryManagementSharedAccessKey,
        ST.Status AS StorageStatus,
        ST.AccountName AS StorageAccountName,
        ST.AccessKey AS StorageAccountKey,
        CH.HostName AS CacheHostName,
        CH.Status AS CacheStatus,
        CH.Ssl AS CacheUseSSL,
        CH.AccessKey AS CacheAccessKey,
        DG.Type AS Type,
        dbo.fn_DefaultInt32IfNull(DG.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(DG.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(DG.UpdateTime) AS UpdateTime,
        dbo.fn_DefaultBitIfNull(DG.AlertEnabled, CONVERT(bit, 0)) AS AlertEnabled,
        ST.ServiceUriSuffix AS StorageServiceUriSuffix,
        MST.Status AS MetadataStorageStatus,
        MST.AccountName AS MetadataStorageAccountName,
        MST.AccessKey AS MetadataStorageAccountKey,
        MST.ServiceUriSuffix AS MetadataStorageServiceUriSuffix
    FROM DataGroup DG
    LEFT OUTER JOIN ServiceBus SB
        ON SB.DataGroup = DG.Id
    CROSS APPLY TVF_ServiceBus_Id(SB.PairServiceBus) PSB
    LEFT OUTER JOIN Storage ST
        ON ST.DataGroup = DG.Id
    LEFT OUTER JOIN MetadataStorage MST
        ON MST.DataGroup = DG.Id
    LEFT OUTER JOIN Cache CH
        ON CH.DataGroup = DG.Id
    WHERE DG.Id = @Id AND
        dbo.fn_IsServiceBusPaired(SB.Id) = CONVERT(bit, 1) AND
        ST.SiblingOf IS NULL AND
        MST.SiblingOf IS NULL

    UNION ALL

    SELECT
        @Id AS Id,
        DG.Name AS Name,
        DG.Status AS Status,
        DG.Geo AS Geo,
        SB.Status AS PrimaryServiceBusStatus,
        SB.Namespace AS PrimaryServiceBusNameSpace,
        SB.ManagementSharedAccessKeyName AS PrimaryManagementSharedAccessKeyName,
        SB.ManagementSharedAccessKey AS PrimaryManagementSharedAccessKey,
        NULL AS SecondaryServiceBusStatus,
        NULL AS SecondaryServiceBusNameSpace,
        NULL AS SecondaryManagementSharedAccessKeyName,
        NULL AS SecondaryManagementSharedAccessKey,
        ST.Status AS StorageStatus,
        ST.AccountName AS StorageAccountName,
        ST.AccessKey AS StorageAccountKey,
        CH.HostName AS CacheHostName,
        CH.Status AS CacheStatus,
        CH.Ssl AS CacheUseSSL,
        CH.AccessKey AS CacheAccessKey,
        DG.Type AS Type,
        dbo.fn_DefaultInt32IfNull(DG.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(DG.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(DG.UpdateTime) AS UpdateTime,
        dbo.fn_DefaultBitIfNull(DG.AlertEnabled, CONVERT(bit, 0)) AS AlertEnabled,
        ST.ServiceUriSuffix AS StorageServiceUriSuffix,
        MST.Status AS MetadataStorageStatus,
        MST.AccountName AS MetadataStorageAccountName,
        MST.AccessKey AS MetadataStorageAccountKey,
        MST.ServiceUriSuffix AS MetadataStorageServiceUriSuffix
    FROM DataGroup DG
    LEFT OUTER JOIN ServiceBus SB
        ON SB.DataGroup = DG.Id
    LEFT OUTER JOIN Storage ST
        ON ST.DataGroup = DG.Id
    LEFT OUTER JOIN MetadataStorage MST
        ON MST.DataGroup = DG.Id
    LEFT OUTER JOIN Cache CH
        ON CH.DataGroup = DG.Id
    WHERE DG.Id = @Id AND
        dbo.fn_IsServiceBusPaired(SB.Id) = CONVERT(bit, 0) AND
        ST.SiblingOf IS NULL AND
        MST.SiblingOf IS NULL
    ) S
    OPTION(RECOMPILE, OPTIMIZE FOR UNKNOWN)

    IF @@ROWCOUNT > 0
    BEGIN
    SELECT
        Id,
        Name,
        Status,
        AccountName,
        AccessKey,
        ServiceUriSuffix,
        SiblingOf
    FROM TVF_SiblingsStorage_DataGroup(@Id)

    SELECT
        Id,
        Name,
        Status,
        AccountName,
        AccessKey,
        ServiceUriSuffix
    FROM TVF_SiblingsMetadataStorage_DataGroup(@Id)
    
    SELECT *
    FROM dbo.EventHub where DataGroup = @Id;
    
    EXEC dbo.proc_GetDispatcherByDataGroup @DataGroupId = @Id
    
    EXEC dbo.proc_GetPolicyStorageAccount @DataGroupId = @Id
    
    EXEC dbo.proc_GetServiceEndpoint  @DataGroupId = @Id, @AuditServiceName = "PolicySyncService"
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_GetDedicatedEventHubMapping]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetDedicatedEventHubMapping]
AS
    SELECT *
    FROM dbo.DedicatedEventHubMapping
GO
/****** Object:  StoredProcedure [dbo].[proc_GetDispatcherByDataGroup]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetDispatcherByDataGroup]
(
    @DataGroupId uniqueIdentifier
)
AS
    SELECT *
    FROM dbo.DispatcherEndpoint
    WHERE
        DataGroup = @DataGroupId
    ORDER BY Id ASC
GO
/****** Object:  StoredProcedure [dbo].[proc_GetEventHubsByDataGroup]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetEventHubsByDataGroup]
(
    @DataGroupId uniqueIdentifier
)
AS
    SELECT *
    FROM dbo.EventHub
    WHERE
        DataGroup = @DataGroupId
    ORDER BY Id ASC
GO
/****** Object:  StoredProcedure [dbo].[proc_GetIngestDataSources]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------------------------
-- INGEST DATA SOURCE
-- Alter Procedure for GetIngestDataSource.
--------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[proc_GetIngestDataSources]
(
    @DataGroup uniqueidentifier = NULL,
    @Id uniqueidentifier = NULL,
    @IncludeDisabledSource bit = NULL
)
AS
  BEGIN
    SET NOCOUNT ON
    DECLARE @statusCode int = 1

    IF @IncludeDisabledSource IS NOT NULL AND @IncludeDisabledSource = 1
    BEGIN
      SET @statusCode = 0
    END

      IF @DataGroup IS NULL AND @Id IS NULL
          SELECT [Id]
            ,[Name]
            ,[DataGroup]
            ,[Geo]
            ,[Status]
            ,[Type]
            ,[QueryType]
            ,[CertificateThumbprint]
            ,[CertificateStoreName]
            ,[CertificateStoreLocation]
            ,[QueryUrl]
            ,[QueryTables]
            ,[QueryFilters]
            ,[WaterMarkContainer]
            ,[MaxQueryRetries]
            ,[MaxQueryWaitTimeInSec]
            ,[SleepBetweenRetriesInSec]
            ,[CreationTime]
            ,[UpdateTime]
          FROM [dbo].[IngestDataSource] WITH (NOLOCK)
          WHERE [Status] >= @statusCode
          ORDER BY Id ASC
      ELSE IF @Id IS NULL
          SELECT [Id]
            ,[Name]
            ,[DataGroup]
            ,[Geo]
            ,[Status]
            ,[Type]
            ,[QueryType]
            ,[CertificateThumbprint]
            ,[CertificateStoreName]
            ,[CertificateStoreLocation]
            ,[QueryUrl]
            ,[QueryTables]
            ,[QueryFilters]
            ,[WaterMarkContainer]
            ,[MaxQueryRetries]
            ,[MaxQueryWaitTimeInSec]
            ,[SleepBetweenRetriesInSec]
            ,[CreationTime]
            ,[UpdateTime]
          FROM [dbo].[IngestDataSource] WITH (NOLOCK)
          WHERE [DataGroup] = @DataGroup AND [Status] >= @statusCode
          ORDER BY Id ASC
      ELSE IF @DataGroup IS NULL
          SELECT [Id]
            ,[Name]
            ,[DataGroup]
            ,[Geo]
            ,[Status]
            ,[Type]
            ,[QueryType]
            ,[CertificateThumbprint]
            ,[CertificateStoreName]
            ,[CertificateStoreLocation]
            ,[QueryUrl]
            ,[QueryTables]
            ,[QueryFilters]
            ,[WaterMarkContainer]
            ,[MaxQueryRetries]
            ,[MaxQueryWaitTimeInSec]
            ,[SleepBetweenRetriesInSec]
            ,[CreationTime]
            ,[UpdateTime]
          FROM [dbo].[IngestDataSource] WITH (NOLOCK)
          WHERE [Id] = @Id AND [Status] >= @statusCode
          ORDER BY Id ASC
      ELSE
          SELECT [Id]
            ,[Name]
            ,[DataGroup]
            ,[Geo]
            ,[Status]
            ,[Type]
            ,[QueryType]
            ,[CertificateThumbprint]
            ,[CertificateStoreName]
            ,[CertificateStoreLocation]
            ,[QueryUrl]
            ,[QueryTables]
            ,[QueryFilters]
            ,[WaterMarkContainer]
            ,[MaxQueryRetries]
            ,[MaxQueryWaitTimeInSec]
            ,[SleepBetweenRetriesInSec]
            ,[CreationTime]
            ,[UpdateTime]
          FROM [dbo].[IngestDataSource] WITH (NOLOCK)
          WHERE [Id] = @Id AND [DataGroup] = @DataGroup AND [Status] >= @statusCode
          ORDER BY Id ASC
  END
GO
/****** Object:  StoredProcedure [dbo].[proc_GetPolicyStorageAccount]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetPolicyStorageAccount]
(
    @DataGroupId uniqueIdentifier
)
AS

    SELECT 
        DataGroup,
        AccountName,
        AccessKey,
        ServiceUriSuffix,
        Status
    FROM dbo.PolicyStorageAccount
    WHERE
        @DataGroupId IS NULL OR DataGroup = @DataGroupId
GO
/****** Object:  StoredProcedure [dbo].[proc_GetService]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetService]
(
    @Id uniqueidentifier = NULL,
    @TypeName nvarchar(256) = NULL
)
AS
    SET NOCOUNT ON

    DECLARE @serviceTable TABLE
    (
        Id uniqueidentifier,
        Name nvarchar(128) COLLATE Latin1_General_CI_AS_KS_WS,
        TypeName nvarchar(256) COLLATE Latin1_General_CI_AS_KS_WS,
        State int NOT NULL,
        CreationTime datetime,
        UpdateTime datetime
    )

    DECLARE @serviceInstanceTable TABLE
    (
        [Id] uniqueidentifier,
        [Service] uniqueidentifier,
        [Name] nvarchar(128) COLLATE Latin1_General_CI_AS_KS_WS,
        [State] int,
        [CreationTime] datetime,
        [UpdateTime] datetime
    )

    DECLARE @serviceCert TABLE
    (
        [ServiceInstanceId] uniqueidentifier,
        [CertificateId] uniqueidentifier,
        [Subject] nvarchar(256) COLLATE Latin1_General_CI_AS_KS_WS,
        [Thumbprint] nvarchar(40) COLLATE Latin1_General_CI_AS_KS_WS,
        [ExpireTime] datetime
    )

    IF @Id IS NULL AND @TypeName IS NULL
    INSERT INTO @serviceTable
    SELECT
        Id,
        Name,
        TypeName,
        State,
        CreationTime,
        UpdateTime
    FROM dbo.Service SV
    ELSE IF @Id IS NULL
    INSERT INTO @serviceTable
    SELECT
        Id,
        Name,
        TypeName,
        State,
        CreationTime,
        UpdateTime
    FROM dbo.Service SV
    WHERE SV.TypeName = @TypeName
    ELSE IF @TypeName IS NULL
    INSERT INTO @serviceTable
    SELECT
        Id,
        Name,
        TypeName,
        State,
        CreationTime,
        UpdateTime
    FROM dbo.Service SV
    WHERE @Id = SV.Id
    ELSE
    INSERT INTO @serviceTable
    SELECT
        Id,
        Name,
        TypeName,
        State,
        CreationTime,
        UpdateTime
    FROM dbo.Service SV
    WHERE @Id = SV.Id AND @TypeName = SV.TypeName

    INSERT INTO @serviceInstanceTable
    SELECT
        SI.Id,
        SI.Service,
        SI.Name,
        SI.State,
        SI.CreationTime,
        SI.UpdateTime
    FROM dbo.ServiceInstance SI
    JOIN @serviceTable SV
      ON SI.Service = SV.Id

    INSERT INTO @serviceCert
    SELECT
        SC.ServiceInstance,
        CT.Id,
        CT.Subject,
        CT.Thumbprint,
        CT.ExpireTime
    FROM dbo.ServiceCert SC
    JOIN @serviceInstanceTable SI
      ON SI.Id = SC.ServiceInstance
    JOIN dbo.Certificate CT
      ON SC.Certificate = CT.Id

    SELECT * FROM @serviceTable
    SELECT * FROM @serviceInstanceTable
    SELECT * FROM @serviceCert
GO
/****** Object:  StoredProcedure [dbo].[proc_GetServiceCertificate]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetServiceCertificate]
(
    @ServiceInstanceId uniqueidentifier = NULL
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@ServiceInstanceId) = 0
    BEGIN
        SELECT
            SC.ServiceInstance AS ServiceInstanceId,
            CT.Id AS CertificateId,
            CT.Subject AS CertificateSubject,
            CT.Thumbprint AS CertificateThumbprint,
            CT.ExpireTime AS CertificateExpireTime
        FROM dbo.ServiceCert SC
        INNER JOIN dbo.Certificate CT
            ON SC.Certificate = CT.Id
        INNER JOIN dbo.ServiceInstance SI
            ON SC.ServiceInstance = SI.Id
    END
    ELSE
    BEGIN
        SELECT
            SC.ServiceInstance AS ServiceInstanceId,
            CT.Id AS CertificateId,
            CT.Subject AS CertificateSubject,
            CT.Thumbprint AS CertificateThumbprint,
            CT.ExpireTime AS CertificateExpireTime
        FROM dbo.ServiceCert SC
        INNER JOIN dbo.Certificate CT
            ON SC.Certificate = CT.Id
        INNER JOIN dbo.ServiceInstance SI
            ON SC.ServiceInstance = SI.Id
        WHERE SC.ServiceInstance = @ServiceInstanceId
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_GetServiceEndpoint]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetServiceEndpoint]
(
    @DataGroupId uniqueIdentifier,
    @AuditServiceName nvarchar(256)
)
AS
    SELECT DataGroup, EndpointUri
    FROM dbo.ServiceEndpoint INNER JOIN dbo.AuditService ON dbo.AuditService.AuditServiceId = dbo.ServiceEndpoint.AuditServiceId
    WHERE
        (@DataGroupId IS NULL OR DataGroup = @DataGroupId) AND AuditService.AuditServiceName = @AuditServiceName
GO
/****** Object:  StoredProcedure [dbo].[proc_GetServiceInstance]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetServiceInstance]
(
    @ServiceId uniqueidentifier = NULL,
    @Id uniqueidentifier = NULL
)
AS
    SET NOCOUNT ON

    IF @Id IS NULL
    BEGIN
        IF (dbo.fn_IsGuidNotEmpty(@ServiceId) = 0)
        SELECT
            SI.Id AS Id,
            SI.Service AS ServiceId,
            SI.Name AS Name,
            SI.State AS State,
            SI.CreationTime AS CreationTime,
            SI.UpdateTime AS UpdateTime
        FROM dbo.ServiceInstance SI
        JOIN dbo.Service SV
            ON SI.Service = SV.Id
        ELSE
        SELECT
            SI.Id AS Id,
            SI.Service AS ServiceId,
            SI.Name AS Name,
            SI.State AS State,
            SI.CreationTime AS CreationTime,
            SI.UpdateTime AS UpdateTime
        FROM dbo.ServiceInstance SI
        JOIN dbo.Service SV
            ON SI.Service = SV.Id
        WHERE SI.Service = @ServiceId
    END
    ELSE
    BEGIN
        IF (dbo.fn_IsGuidNotEmpty(@ServiceId) = 1)
        SELECT
            SI.Id AS Id,
            SI.Service AS ServiceId,
            SI.Name AS Name,
            SI.State AS State,
            SI.CreationTime AS CreationTime,
            SI.UpdateTime AS UpdateTime
        FROM dbo.ServiceInstance SI
        JOIN dbo.Service SV
            ON SI.Service = SV.Id
        WHERE SI.Id = @Id AND
            SV.Id = @ServiceId
        ELSE
        SELECT
            SI.Id AS Id,
            SI.Service AS ServiceId,
            SI.Name AS Name,
            SI.State AS State,
            SI.CreationTime AS CreationTime,
            SI.UpdateTime AS UpdateTime
        FROM dbo.ServiceInstance SI
        JOIN dbo.Service SV
            ON SI.Service = SV.Id
        WHERE SI.Id = @Id
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_GetSubscription]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetSubscription]
(
    @TenantId uniqueidentifier
)
AS
    SET NOCOUNT ON

    SELECT
        S.Id,
        S.Name,
        S.Status,
        S.MajorCategory,
        S.MinorCategory,
        S.CreationTime,
        S.UpdateTime
    FROM Subscription S
    WHERE S.Tenant = @TenantId
GO
/****** Object:  StoredProcedure [dbo].[proc_GetTenant]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[proc_GetTenant]
(
    @Id uniqueidentifier,
    @NotInState int = NULL
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@Id) = 0
    BEGIN
        RAISERROR(15600, -1, -1, 'proc_GetTenant')
        RETURN -1
    END

    SELECT
        @Id AS Id,
        T.Name AS Name,
        T.AuditingEnabled AS AuditingEnabled,
        SB.Namespace AS PrimaryServiceBusNameSpace,
        SB.ManagementSharedAccessKeyName AS PrimaryManagementSharedAccessKeyName,
        SB.ManagementSharedAccessKey AS PrimaryManagementSharedAccessKey,
        SB.Status AS PrimaryServiceBusStatus,
        PSB.Namespace AS SecondaryServiceBusNameSpace,
        PSB.ManagementSharedAccessKeyName AS SecondaryManagementSharedAccessKeyName,
        PSB.ManagementSharedAccessKey AS SecondaryManagementSharedAccessKey,
        PSB.Status AS SecondaryServiceBusStatus,
        ST.AccountName AS StorageAccountName,
        ST.AccessKey AS StorageAccountKey,
        ST.Status AS StorageStatus,
        ST.DataGroup AS DataGroup,
        DG.Geo AS Location,
        dbo.fn_DefaultInt32IfNull(T.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(T.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(T.UpdateTime) AS UpdateTime,
        T.Type AS Type,
        T.ReceiverPolicy AS ReceiverPolicy,
        T.ReceiverAccessKey AS ReceiverAccessKey,
        T.SecondaryReceiverPolicy As SecondaryReceiverPolicy,
        T.SecondaryReceiverAccessKey As SecondaryReceiverAccessKey,
        ST.ServiceUriSuffix AS StorageServiceUriSuffix,
        T.TopicName AS TopicName,
        T.LoadBalanceCount AS LoadBalanceCount
    FROM
        Tenant T
    INNER JOIN DataGroup DG
        ON T.DataGroup = DG.Id
    LEFT OUTER JOIN ServiceBus SB
        ON T.DataGroup = SB.DataGroup
    CROSS APPLY TVF_ServiceBus_Id(SB.PairServiceBus) PSB
    LEFT OUTER JOIN Storage ST
        ON T.DataGroup = ST.DataGroup
    WHERE
        T.Id = @Id AND
        ( @NotInState IS NULL OR T.State <> @NotInState ) AND
        ST.SiblingOf IS NULL

    IF @@ROWCOUNT > 0
    BEGIN
        EXEC dbo.proc_GetSubscription @TenantId = @Id

        SELECT DISTINCT
            CT.Id AS Id,
            TC.Role AS Role,
            CT.Thumbprint AS Thumbprint,
            CT.ExpireTime AS ExpireTime,
            CT.Content AS Content,
            CT.Password AS Password
        FROM dbo.TenantCert TC
        JOIN dbo.Certificate CT
            ON TC.Certificate = CT.Id
        WHERE TC.Tenant = @Id

        SELECT
            Id,
            Name,
            Status,
            AccountName,
            AccessKey,
            ServiceUriSuffix
        FROM TVF_SiblingsStorage_DataGroup((SELECT DataGroup FROM dbo.Tenant WHERE Id = @Id))
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_GetTenantCert]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetTenantCert]
(
    @Tenant uniqueidentifier,
    @Certificate uniqueidentifier
)
AS
    SET NOCOUNT ON

    IF @Tenant IS NULL
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_GetTenantCert')
        RETURN -1
    END

    IF dbo.fn_IsGuidNotEmpty(@Certificate) = 0
    BEGIN
        SELECT
            Tenant,
            Certificate,
            Role
        FROM [dbo].[TenantCert] 
        WHERE Tenant = @Tenant
    END
    ELSE
    BEGIN
        SELECT
            Tenant,
            Certificate,
            Role
        FROM [dbo].[TenantCert] 
        WHERE Tenant = @Tenant AND Certificate = @Certificate
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_GetTenantCertificate]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetTenantCertificate]
(
    @TenantId uniqueidentifier
)
AS
    SET NOCOUNT ON

    IF @TenantId IS NULL
    RETURN -1

    SELECT
        TenantId,
        CertificateId,
        CertificateThumbprint,
        EncrypedAESKey
    FROM TenantCertificate
    WHERE TenantId = @TenantId
GO
/****** Object:  StoredProcedure [dbo].[proc_GetTenantCertificates]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetTenantCertificates]
(
    @TenantId uniqueidentifier
)
AS
    SET NOCOUNT ON

    IF @TenantId IS NULL
    RETURN -1

    SELECT
        CT.Id AS CertId,
        TC.Role AS Role,
        CT.Thumbprint AS Thumbprint,
        CT.ExpireTime AS ExpireTime,
        CASE WHEN CT.Content IS NOT NULL AND DATALENGTH(CT.Content) > 0 THEN CT.Content ELSE NULL END AS Content,
        CT.Password AS Password
    FROM TenantCert TC WITH (NOLOCK)
    INNER JOIN Tenant TN
        ON TC.Tenant = TN.Id
    INNER JOIN Certificate CT
        ON TC.Certificate = CT.Id
    WHERE TC.Tenant = @TenantId
GO
/****** Object:  StoredProcedure [dbo].[proc_GetTenants]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[proc_GetTenants]
(
    @StartFromTenantId uniqueidentifier,
    @Count int,
    @AuditingEnabled bit,
    @DataGroupId uniqueIdentifier = NULL,
    @NotInState int = NULL
)
AS
    SET NOCOUNT ON

    IF @StartFromTenantId IS NULL
    SELECT @StartFromTenantId = CONVERT(uniqueidentifier, '00000000-0000-0000-0000-000000000000')

    IF @Count IS NULL OR @Count < 1
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_GetTenants')
        RETURN -1
    END

    IF @AuditingEnabled IS NULL
    SELECT TOP (@Count)
        T.Id AS Id,
        T.Name AS Name,
        T.AuditingEnabled AS AuditingEnabled,
        D.Id AS DataGroupId,
        D.Geo AS Location,
        dbo.fn_DefaultInt32IfNull(T.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(T.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(T.UpdateTime) AS UpdateTime,
        T.Type AS Type,
        T.TopicName AS TopicName,
        T.LoadBalanceCount AS LoadBalanceCount
    FROM dbo.Tenant T
    JOIN dbo.DataGroup D
        ON T.DataGroup = D.Id
    WHERE
        T.Id > @StartFromTenantId AND
        T.DataGroup = CASE WHEN @DataGroupId IS NOT NULL THEN @DataGroupId ELSE T.DataGroup END AND
        ( @NotInState IS NULL OR T.State <> @NotInState )
    ORDER BY T.Id ASC
    ELSE
    SELECT TOP (@COUNT)
        T.Id AS Id,
        T.Name AS Name,
        T.AuditingEnabled AS AuditingEnabled,
        D.Id AS DataGroupId,
        D.Geo AS Location,
        dbo.fn_DefaultInt32IfNull(T.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(T.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(T.UpdateTime) AS UpdateTime,
        T.Type AS Type,
        T.TopicName AS TopicName,
        T.LoadBalanceCount AS LoadBalanceCount
    FROM Tenant T
    JOIN dbo.DataGroup D
        ON T.DataGroup = D.Id
    WHERE
        T.Id > @StartFromTenantId AND
        T.DataGroup = CASE WHEN @DataGroupId IS NOT NULL THEN @DataGroupId ELSE T.DataGroup END AND
        T.AuditingEnabled = @AuditingEnabled AND
        ( @NotInState IS NULL OR T.State <> @NotInState )
    ORDER BY T.Id ASC
    OPTION (FORCE ORDER)
GO
/****** Object:  StoredProcedure [dbo].[proc_GetTenantsByLastModifiedTime]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[proc_GetTenantsByLastModifiedTime]
(
    @Count int,
    @AuditingEnabled bit,
    @DataGroupId uniqueIdentifier = NULL,
    @NotInState int = NULL,
    @LastModifiedTime  datetime = NULL
)
AS
    SET NOCOUNT ON

    IF @LastModifiedTime IS NULL
    SELECT @LastModifiedTime = -53690

    IF @Count IS NULL OR @Count < 1
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_GetTenantsByLastModifiedTime')
        RETURN -1
    END

    IF @AuditingEnabled IS NULL
    SELECT TOP (@Count)
        T.Id AS Id,
        T.Name AS Name,
        T.AuditingEnabled AS AuditingEnabled,
        D.Id AS DataGroupId,
        D.Geo AS Location,
        dbo.fn_DefaultInt32IfNull(T.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(T.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(T.UpdateTime) AS UpdateTime,
        T.Type AS Type,
        T.TopicName AS TopicName,
        T.LoadBalanceCount AS LoadBalanceCount
    FROM dbo.Tenant T
    JOIN dbo.DataGroup D
        ON T.DataGroup = D.Id
    WHERE
        T.UpdateTime >= @LastModifiedTime AND
        T.DataGroup = CASE WHEN @DataGroupId IS NOT NULL THEN @DataGroupId ELSE T.DataGroup END AND
        ( @NotInState IS NULL OR T.State <> @NotInState )
    ORDER BY T.UpdateTime ASC
    ELSE
    SELECT TOP (@COUNT)
        T.Id AS Id,
        T.Name AS Name,
        T.AuditingEnabled AS AuditingEnabled,
        D.Id AS DataGroupId,
        D.Geo AS Location,
        dbo.fn_DefaultInt32IfNull(T.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(T.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(T.UpdateTime) AS UpdateTime,
        T.Type AS Type,
        T.TopicName AS TopicName,
        T.LoadBalanceCount AS LoadBalanceCount
    FROM Tenant T
    JOIN dbo.DataGroup D
        ON T.DataGroup = D.Id
    WHERE
        T.UpdateTime >= @LastModifiedTime AND
        T.DataGroup = CASE WHEN @DataGroupId IS NOT NULL THEN @DataGroupId ELSE T.DataGroup END AND
        T.AuditingEnabled = @AuditingEnabled AND
        ( @NotInState IS NULL OR T.State <> @NotInState )
    ORDER BY T.UpdateTime ASC
    OPTION (FORCE ORDER)
GO
/****** Object:  StoredProcedure [dbo].[proc_GetTenantSubscriptionProfile]    Script Date: 10/26/2020 9:05:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[proc_GetTenantSubscriptionProfile]
(
    @Id uniqueidentifier
)
AS
    SET NOCOUNT ON
	DECLARE @EmptyGuid UNIQUEIDENTIFIER = 0x0
    IF dbo.fn_IsGuidNotEmpty(@Id) = 0
    BEGIN
        RAISERROR(15600, -1, -1, 'proc_GetTenantSubscriptionProfile')
        RETURN -1
    END

	IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.Tenant WHERE Id = @Id)
	BEGIN 
		SELECT DISTINCT @EmptyGuid, CAST(0 AS bit), CAST(0 AS bit),CAST(0 AS bigint), CAST(0 AS bigint), CAST(0 AS bigint)
	END
	ELSE
	BEGIN
    SELECT
        @Id AS Id,
        CAST(ISNULL(HasOfficeE3,0) AS bit),
        CAST(ISNULL(HasOfficeE5,0) AS bit),
        CAST(ISNULL(TotalAvailableUnits, 0) AS bigint),
        CAST(ISNULL(TrailAvailableUnits, 0) AS bigint),
        CAST(ISNULL(TenantSubscriptionFlags,0) AS bigint)
    FROM
        TenantInfo WHERE TenantInfo.TenantId = @Id
	END
GO
/****** Object:  StoredProcedure [dbo].[proc_GetTenantSubscriptionProfileTest]    Script Date: 10/26/2020 9:05:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[proc_GetTenantSubscriptionProfileTest]
(
    @Id uniqueidentifier
)
AS
    SET NOCOUNT ON
	DECLARE @EmptyGuid UNIQUEIDENTIFIER = 0x0
    IF dbo.fn_IsGuidNotEmpty(@Id) = 0
    BEGIN
        RAISERROR(15600, -1, -1, 'proc_GetTenantSubscriptionProfile')
        RETURN -1
    END

	IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.Tenant WHERE Id = @Id)
	BEGIN 
		SELECT DISTINCT @EmptyGuid, CAST(0 AS bit), CAST(0 AS bit),CAST(0 AS bigint), CAST(0 AS bigint), CAST(0 AS bigint)
	END
	ELSE
	BEGIN
    SELECT
        @Id AS Id,
        CAST(ISNULL(HasOfficeE3,0) AS bit),
        CAST(ISNULL(HasOfficeE5,0) AS bit),
        CAST(ISNULL(TotalAvailableUnits, 0) AS bigint),
        CAST(ISNULL(TrailAvailableUnits, 0) AS bigint),
        CAST(ISNULL(TenantSubscriptionFlags,0) AS bigint)
    FROM
        TenantInfo WHERE TenantInfo.TenantId = @Id
	END
GO
/****** Object:  StoredProcedure [dbo].[proc_GetTenantsWithTenantInfoByLastModifiedTime]    Script Date: 10/26/2020 9:05:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------------------------
-- Create [proc_GetTenantsWithTenantInfoByLastModifiedTime]
--------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[proc_GetTenantsWithTenantInfoByLastModifiedTime]
(
    @Count int,
    @AuditingEnabled bit,
    @DataGroupId uniqueIdentifier = NULL,
    @NotInState int = NULL,
    @LastModifiedTime  datetime = NULL
)
AS
    SET NOCOUNT ON

    IF @LastModifiedTime IS NULL
    SELECT @LastModifiedTime = -53690

    IF @Count IS NULL OR @Count < 1
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_GetTenantsWithTenantInfoByLastModifiedTime')
        RETURN -1
    END

    IF @AuditingEnabled IS NULL
    SELECT TOP (@Count)
        T.Id AS Id,
        T.Name AS Name,
        T.AuditingEnabled AS AuditingEnabled,
        D.Id AS DataGroupId,
        D.Geo AS Location,
        dbo.fn_DefaultInt32IfNull(T.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(T.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(
			CASE WHEN TF.LastUpdateDate > T.UpdateTime THEN TF.LastUpdateDate
			WHEN TF.CreatedDate > T.UpdateTime THEN TF.CreatedDate
			ELSE T.UpdateTime
			END
		) AS UpdateTime,
        T.Type AS Type,
        T.TopicName AS TopicName,
        T.LoadBalanceCount AS LoadBalanceCount,
		TF.HasOfficeE3 AS HasOfficeE3,
		TF.HasOfficeE5 AS HasOfficeE5,
		TF.TotalAvailableUnits AS TotalAvailableUnits,
		TF.TrailAvailableUnits AS TrailAvailableUnits,
		TF.TenantSubscriptionFlags AS TenantSubscriptionFlags
    FROM dbo.Tenant T
    JOIN dbo.DataGroup D ON T.DataGroup = D.Id
	LEFT JOIN dbo.TenantInfo TF ON TF.TenantId = T.Id
    WHERE
        (T.UpdateTime >= @LastModifiedTime OR TF.CreatedDate >= @LastModifiedTime OR TF.LastUpdateDate >= @LastModifiedTime) AND
        T.DataGroup = CASE WHEN @DataGroupId IS NOT NULL THEN @DataGroupId ELSE T.DataGroup END AND
        ( @NotInState IS NULL OR T.State <> @NotInState )
    ORDER BY (CASE WHEN TF.LastUpdateDate > T.UpdateTime THEN TF.LastUpdateDate
			WHEN TF.CreatedDate > T.UpdateTime THEN TF.CreatedDate
			ELSE T.UpdateTime
			END) ASC
    ELSE
    SELECT TOP (@COUNT)
        T.Id AS Id,
        T.Name AS Name,
        T.AuditingEnabled AS AuditingEnabled,
        D.Id AS DataGroupId,
        D.Geo AS Location,
        dbo.fn_DefaultInt32IfNull(T.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(T.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(
			CASE WHEN TF.LastUpdateDate > T.UpdateTime THEN TF.LastUpdateDate
			WHEN TF.CreatedDate > T.UpdateTime THEN TF.CreatedDate
			ELSE T.UpdateTime
			END
		) AS UpdateTime,
        T.Type AS Type,
        T.TopicName AS TopicName,
        T.LoadBalanceCount AS LoadBalanceCount,
		TF.HasOfficeE3 AS HasOfficeE3,
		TF.HasOfficeE5 AS HasOfficeE5,
		TF.TotalAvailableUnits AS TotalAvailableUnits,
		TF.TrailAvailableUnits AS TrailAvailableUnits,
		TF.TenantSubscriptionFlags AS TenantSubscriptionFlags
    FROM Tenant T
    JOIN dbo.DataGroup D ON T.DataGroup = D.Id
	LEFT JOIN dbo.TenantInfo TF ON TF.TenantId = T.Id
    WHERE
        (T.UpdateTime >= @LastModifiedTime OR TF.CreatedDate >= @LastModifiedTime OR TF.LastUpdateDate >= @LastModifiedTime) AND
        T.DataGroup = CASE WHEN @DataGroupId IS NOT NULL THEN @DataGroupId ELSE T.DataGroup END AND
        T.AuditingEnabled = @AuditingEnabled AND
        ( @NotInState IS NULL OR T.State <> @NotInState )
    ORDER BY (CASE WHEN TF.LastUpdateDate > T.UpdateTime THEN TF.LastUpdateDate
			WHEN TF.CreatedDate > T.UpdateTime THEN TF.CreatedDate
			ELSE T.UpdateTime
			END) ASC
    OPTION (FORCE ORDER)
GO
/****** Object:  StoredProcedure [dbo].[proc_GetTenantUserPolicyBinaryData]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetTenantUserPolicyBinaryData]
(
    @TenantId uniqueidentifier
)
AS
    SET NOCOUNT ON

    IF @TenantId IS NULL
        RETURN -1

    SELECT
        BinaryData
    FROM TenantUserPolicyBinaryData
    WHERE TenantId = @TenantId
GO
/****** Object:  StoredProcedure [dbo].[proc_GetTenantV2]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetTenantV2]
(
    @Id uniqueidentifier,
    @NotInState int = NULL
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@Id) = 0
    BEGIN
        RAISERROR(15600, -1, -1, 'proc_GetTenantV2')
        RETURN -1
    END

    SELECT
        @Id AS Id,
        T.Name AS Name,
        T.AuditingEnabled AS AuditingEnabled,
        SB.Namespace AS PrimaryServiceBusNameSpace,
        SB.ManagementSharedAccessKeyName AS PrimaryManagementSharedAccessKeyName,
        SB.ManagementSharedAccessKey AS PrimaryManagementSharedAccessKey,
        SB.Status AS PrimaryServiceBusStatus,
        PSB.Namespace AS SecondaryServiceBusNameSpace,
        PSB.ManagementSharedAccessKeyName AS SecondaryManagementSharedAccessKeyName,
        PSB.ManagementSharedAccessKey AS SecondaryManagementSharedAccessKey,
        PSB.Status AS SecondaryServiceBusStatus,
        ST.AccountName AS StorageAccountName,
        ST.AccessKey AS StorageAccountKey,
        ST.Status AS StorageStatus,
        ST.DataGroup AS DataGroup,
        DG.Geo AS Location,
        dbo.fn_DefaultInt32IfNull(T.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(T.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(T.UpdateTime) AS UpdateTime,
        T.Type AS Type,
        T.ReceiverPolicy AS ReceiverPolicy,
        T.ReceiverAccessKey AS ReceiverAccessKey,
        T.SecondaryReceiverPolicy As SecondaryReceiverPolicy,
        T.SecondaryReceiverAccessKey As SecondaryReceiverAccessKey,
        ST.ServiceUriSuffix AS StorageServiceUriSuffix,
        T.TopicName AS TopicName,
        T.LoadBalanceCount AS LoadBalanceCount,
        MST.AccountName AS MetadataStorageAccountName,
        MST.AccessKey AS MetadataStorageAccountKey,
        MST.Status AS MetadataStorageStatus,
        MST.ServiceUriSuffix AS MetadataStorageServiceUriSuffix
    FROM
        Tenant T
    INNER JOIN DataGroup DG
        ON T.DataGroup = DG.Id
    LEFT OUTER JOIN ServiceBus SB
        ON T.DataGroup = SB.DataGroup
    CROSS APPLY TVF_ServiceBus_Id(SB.PairServiceBus) PSB
    LEFT OUTER JOIN Storage ST
        ON T.DataGroup = ST.DataGroup
    LEFT OUTER JOIN MetadataStorage MST
        ON T.DataGroup = MST.DataGroup
    WHERE
        T.Id = @Id AND
        ( @NotInState IS NULL OR T.State <> @NotInState ) AND
        ST.SiblingOf IS NULL AND
        MST.SiblingOf IS NULL

    IF @@ROWCOUNT > 0
    BEGIN
        EXEC dbo.proc_GetSubscription @TenantId = @Id

        SELECT DISTINCT
            CT.Id AS Id,
            TC.Role AS Role,
            CT.Thumbprint AS Thumbprint,
            CT.ExpireTime AS ExpireTime,
            CT.Content AS Content,
            CT.Password AS Password
        FROM dbo.TenantCert TC
        JOIN dbo.Certificate CT
            ON TC.Certificate = CT.Id
        WHERE TC.Tenant = @Id

        SELECT
            Id,
            Name,
            Status,
            AccountName,
            AccessKey,
            ServiceUriSuffix
        FROM TVF_SiblingsStorage_DataGroup((SELECT DataGroup FROM dbo.Tenant WHERE Id = @Id))

        SELECT
            Id,
            Name,
            Status,
            AccountName,
            AccessKey,
            ServiceUriSuffix
        FROM TVF_SiblingsMetadataStorage_DataGroup((SELECT DataGroup FROM dbo.Tenant WHERE Id = @Id))
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_GetTenantV3]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetTenantV3]
(
    @Id uniqueidentifier,
    @NotInState int = NULL
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@Id) = 0
    BEGIN
        RAISERROR(15600, -1, -1, 'proc_GetTenantV3')
        RETURN -1
    END

    SELECT
        @Id AS Id,
        T.Name AS Name,
        T.DataGroup AS DataGroup,
        T.AuditingEnabled AS AuditingEnabled,
        DG.Geo AS Location,
        dbo.fn_DefaultInt32IfNull(T.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(T.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(T.UpdateTime) AS UpdateTime,
        T.Type AS Type,
        T.ReceiverPolicy AS ReceiverPolicy,
        T.ReceiverAccessKey AS ReceiverAccessKey,
        T.SecondaryReceiverPolicy As SecondaryReceiverPolicy,
        T.SecondaryReceiverAccessKey As SecondaryReceiverAccessKey,
        T.TopicName AS TopicName,
        T.LoadBalanceCount AS LoadBalanceCount
    FROM
        Tenant T
    INNER JOIN DataGroup DG
        ON T.DataGroup = DG.Id
    WHERE
        T.Id = @Id AND
        ( @NotInState IS NULL OR T.State <> @NotInState )

    IF @@ROWCOUNT > 0
    BEGIN
        EXEC dbo.proc_GetSubscription @TenantId = @Id

        SELECT DISTINCT
            CT.Id AS Id,
            TC.Role AS Role,
            CT.Thumbprint AS Thumbprint,
            CT.ExpireTime AS ExpireTime,
            CT.Content AS Content,
            CT.Password AS Password
        FROM dbo.TenantCert TC
        JOIN dbo.Certificate CT
            ON TC.Certificate = CT.Id
        WHERE TC.Tenant = @Id
        
        SELECT DEHM.* 
        FROM 
            dbo.EventHub EH
        INNER JOIN dbo.DedicatedEventHubMapping DEHM
            ON DEHM.EeventHubId = EH.Id
        WHERE DEHM.TenantId = @Id
        
        
        EXEC dbo.proc_GetDataGroupsForTenantV2 @Id = @Id

        SELECT DataGroup, MigrationTime, ReadStatus
        FROM dbo.TenantMigration
        WHERE TenantId = @Id AND ReadStatus != 42
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_GetTenantV4]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetTenantV4]
(
    @Id uniqueidentifier,
    @NotInState int = NULL
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@Id) = 0
    BEGIN
        RAISERROR(15600, -1, -1, 'proc_GetTenantV4')
        RETURN -1
    END

    SELECT
        @Id AS Id,
        T.Name AS Name,
        T.DataGroup AS DataGroup,
        T.AuditingEnabled AS AuditingEnabled,
        DG.Geo AS Location,
        dbo.fn_DefaultInt32IfNull(T.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(T.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(T.UpdateTime) AS UpdateTime,
        T.Type AS Type,
        T.ReceiverPolicy AS ReceiverPolicy,
        T.ReceiverAccessKey AS ReceiverAccessKey,
        T.SecondaryReceiverPolicy As SecondaryReceiverPolicy,
        T.SecondaryReceiverAccessKey As SecondaryReceiverAccessKey,
        T.TopicName AS TopicName,
        T.LoadBalanceCount AS LoadBalanceCount
    FROM
        Tenant T
    INNER JOIN DataGroup DG
        ON T.DataGroup = DG.Id
    WHERE
        T.Id = @Id AND
        ( @NotInState IS NULL OR T.State <> @NotInState )

    IF @@ROWCOUNT > 0
    BEGIN
        EXEC dbo.proc_GetSubscription @TenantId = @Id

        SELECT DISTINCT
            CT.Id AS Id,
            TC.Role AS Role,
            CT.Thumbprint AS Thumbprint,
            CT.ExpireTime AS ExpireTime,
            CT.Content AS Content,
            CT.Password AS Password
        FROM dbo.TenantCert TC
        JOIN dbo.Certificate CT
            ON TC.Certificate = CT.Id
        WHERE TC.Tenant = @Id
        
        SELECT DEHM.* 
        FROM 
            dbo.EventHub EH
        INNER JOIN dbo.DedicatedEventHubMapping DEHM
            ON DEHM.EeventHubId = EH.Id
        WHERE DEHM.TenantId = @Id
        
        
        EXEC dbo.proc_GetDataGroupsForTenantV2 @Id = @Id

        SELECT DataGroup, MigrationTime, ReadStatus
        FROM dbo.TenantMigration
        WHERE TenantId = @Id AND ReadStatus != 42
		
		SELECT isnull([HasOfficeE3], 0) AS [HasOfficeE3], isnull([HasOfficeE5], 0) AS [HasOfficeE5],  isnull(TotalAvailableUnits, 0) AS TotalAvailableUnits ,  isnull(TrailAvailableUnits, 0) AS TrailAvailableUnits
		FROM dbo.TenantInfo
		WHERE TenantId = @Id
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_GetTenantV5]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetTenantV5]
(
    @Id uniqueidentifier,
    @NotInState int = NULL
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@Id) = 0
    BEGIN
        RAISERROR(15600, -1, -1, 'proc_GetTenantV5')
        RETURN -1
    END

    SELECT
        @Id AS Id,
        T.Name AS Name,
        T.DataGroup AS DataGroup,
        T.AuditingEnabled AS AuditingEnabled,
        DG.Geo AS Location,
        dbo.fn_DefaultInt32IfNull(T.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(T.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(T.UpdateTime) AS UpdateTime,
        T.Type AS Type,
        T.ReceiverPolicy AS ReceiverPolicy,
        T.ReceiverAccessKey AS ReceiverAccessKey,
        T.SecondaryReceiverPolicy As SecondaryReceiverPolicy,
        T.SecondaryReceiverAccessKey As SecondaryReceiverAccessKey,
        T.TopicName AS TopicName,
        T.LoadBalanceCount AS LoadBalanceCount
    FROM
        Tenant T
    INNER JOIN DataGroup DG
        ON T.DataGroup = DG.Id
    WHERE
        T.Id = @Id AND
        ( @NotInState IS NULL OR T.State <> @NotInState )

    IF @@ROWCOUNT > 0
    BEGIN
        EXEC dbo.proc_GetSubscription @TenantId = @Id

        SELECT DISTINCT
            CT.Id AS Id,
            TC.Role AS Role,
            CT.Thumbprint AS Thumbprint,
            CT.ExpireTime AS ExpireTime,
            CT.Content AS Content,
            CT.Password AS Password
        FROM dbo.TenantCert TC
        JOIN dbo.Certificate CT
            ON TC.Certificate = CT.Id
        WHERE TC.Tenant = @Id
        
        SELECT DEHM.* 
        FROM 
            dbo.EventHub EH
        INNER JOIN dbo.DedicatedEventHubMapping DEHM
            ON DEHM.EeventHubId = EH.Id
        WHERE DEHM.TenantId = @Id
        
        
        EXEC dbo.proc_GetDataGroupsForTenantV3 @Id = @Id

        SELECT DataGroup, MigrationTime, ReadStatus
        FROM dbo.TenantMigration
        WHERE TenantId = @Id AND ReadStatus != 42

        SELECT isnull([HasOfficeE3], 0) AS [HasOfficeE3], isnull([HasOfficeE5], 0) AS [HasOfficeE5],  isnull(TotalAvailableUnits, 0) AS TotalAvailableUnits ,  isnull(TrailAvailableUnits, 0) AS TrailAvailableUnits
		FROM dbo.TenantInfo
		WHERE TenantId = @Id
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_GetTenantV6]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetTenantV6]
(
    @Id uniqueidentifier,
    @NotInState int = NULL
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@Id) = 0
    BEGIN
        RAISERROR(15600, -1, -1, 'proc_GetTenantV6')
        RETURN -1
    END

    SELECT
        @Id AS Id,
        T.Name AS Name,
        T.DataGroup AS DataGroup,
        T.AuditingEnabled AS AuditingEnabled,
        DG.Geo AS Location,
        dbo.fn_DefaultInt32IfNull(T.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(T.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(T.UpdateTime) AS UpdateTime,
        T.Type AS Type,
        T.ReceiverPolicy AS ReceiverPolicy,
        T.ReceiverAccessKey AS ReceiverAccessKey,
        T.SecondaryReceiverPolicy As SecondaryReceiverPolicy,
        T.SecondaryReceiverAccessKey As SecondaryReceiverAccessKey,
        T.TopicName AS TopicName,
        T.LoadBalanceCount AS LoadBalanceCount
    FROM
        Tenant T
    INNER JOIN DataGroup DG
        ON T.DataGroup = DG.Id
    WHERE
        T.Id = @Id AND
        ( @NotInState IS NULL OR T.State <> @NotInState )

    IF @@ROWCOUNT > 0
    BEGIN
        EXEC dbo.proc_GetSubscription @TenantId = @Id

        SELECT DISTINCT
            CT.Id AS Id,
            TC.Role AS Role,
            CT.Thumbprint AS Thumbprint,
            CT.ExpireTime AS ExpireTime,
            CT.Content AS Content,
            CT.Password AS Password
        FROM dbo.TenantCert TC
        JOIN dbo.Certificate CT
            ON TC.Certificate = CT.Id
        WHERE TC.Tenant = @Id
        
        SELECT DEHM.* 
        FROM 
            dbo.EventHub EH
        INNER JOIN dbo.DedicatedEventHubMapping DEHM
            ON DEHM.EeventHubId = EH.Id
        WHERE DEHM.TenantId = @Id
        
        
        EXEC dbo.proc_GetDataGroupsForTenantV3 @Id = @Id

        SELECT DataGroup, MigrationTime, ReadStatus
        FROM dbo.TenantMigration
        WHERE TenantId = @Id AND ReadStatus != 42

        SELECT isnull([HasOfficeE3], 0) AS [HasOfficeE3], isnull([HasOfficeE5], 0) AS [HasOfficeE5], isnull([TotalAvailableUnits], 0) AS [TotalAvailableUnits], isnull([TrailAvailableUnits],0) AS [TrailAvailableUnits] , isnull([TenantSubscriptionFlags], 0) AS [TenantSubscriptionFlags]
		FROM dbo.TenantInfo
		WHERE TenantId = @Id
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_GetTenantV7]    Script Date: 10/26/2020 9:05:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetTenantV7]
(
    @Id uniqueidentifier,
    @NotInState int = NULL
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@Id) = 0
    BEGIN
        RAISERROR(15600, -1, -1, 'proc_GetTenantV7')
        RETURN -1
    END

    SELECT
        @Id AS Id,
        T.Name AS Name,
        T.DataGroup AS DataGroup,
        T.AuditingEnabled AS AuditingEnabled,
        DG.Geo AS Location,
        dbo.fn_DefaultInt32IfNull(T.State, 0) AS State,
        dbo.fn_DefaultDateTimeIfNull(T.CreationTime) AS CreationTime,
        dbo.fn_DefaultDateTimeIfNull(T.UpdateTime) AS UpdateTime,
        T.Type AS Type,
        T.ReceiverPolicy AS ReceiverPolicy,
        T.ReceiverAccessKey AS ReceiverAccessKey,
        T.SecondaryReceiverPolicy As SecondaryReceiverPolicy,
        T.SecondaryReceiverAccessKey As SecondaryReceiverAccessKey,
        T.TopicName AS TopicName,
        T.LoadBalanceCount AS LoadBalanceCount
    FROM
        Tenant T
    INNER JOIN DataGroup DG
        ON T.DataGroup = DG.Id
    WHERE
        T.Id = @Id AND
        ( @NotInState IS NULL OR T.State <> @NotInState )

    IF @@ROWCOUNT > 0
    BEGIN
        EXEC dbo.proc_GetSubscription @TenantId = @Id

        SELECT DISTINCT
            CT.Id AS Id,
            TC.Role AS Role,
            CT.Thumbprint AS Thumbprint,
            CT.ExpireTime AS ExpireTime,
            CT.Content AS Content,
            CT.Password AS Password
        FROM dbo.TenantCert TC
        JOIN dbo.Certificate CT
            ON TC.Certificate = CT.Id
        WHERE TC.Tenant = @Id
        
        SELECT DEHM.* 
        FROM 
            dbo.EventHub EH
        INNER JOIN dbo.DedicatedEventHubMapping DEHM
            ON DEHM.EeventHubId = EH.Id
        WHERE DEHM.TenantId = @Id
        
		EXEC dbo.proc_GetDataGroupsForTenantV4 @Id = @Id

        SELECT DataGroup, MigrationTime, ReadStatus
        FROM dbo.TenantMigration
        WHERE TenantId = @Id AND ReadStatus != 42

        SELECT isnull([HasOfficeE3], 0) AS [HasOfficeE3], isnull([HasOfficeE5], 0) AS [HasOfficeE5], isnull([TotalAvailableUnits], 0) AS [TotalAvailableUnits], isnull([TrailAvailableUnits],0) AS [TrailAvailableUnits] , isnull([TenantSubscriptionFlags], 0) AS [TenantSubscriptionFlags]
		FROM dbo.TenantInfo
		WHERE TenantId = @Id
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_GetTopicNameForTenantProvisioning]    Script Date: 10/26/2020 9:05:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------------------------
   -- proc_GetTopicNameForTenantProvisioning - gets the topicName with the least number of tenants.
--------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[proc_GetTopicNameForTenantProvisioning]
(
    @DataGroupId uniqueidentifier,
    @MaxTenantCount int
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@DataGroupId) = 0
    BEGIN
        RAISERROR(15600, -1, -1, 'proc_GetTopicNameForTenantProvisioning')
        RETURN -1
    END

    IF @MaxTenantCount IS NULL OR @MaxTenantCount < 1
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_GetTopicNameForTenantProvisioning')
        RETURN -1
    END

    SELECT TOP 1  TopicName, COUNT(ID) as TenantCount
    FROM Tenant
    WHERE DataGroup = @DataGroupId
    GROUP BY TopicName
    HAVING COUNT(ID) <= @MaxTenantCount
    ORDER BY TenantCount ASC
GO
/****** Object:  StoredProcedure [dbo].[proc_GetUnscrubKey]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetUnscrubKey]
(
    @CertificateId int
)
AS
    SET NOCOUNT ON

    IF @CertificateId IS NULL
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_GetUnscrubKey')
        RETURN -1
    END

    SELECT
        CertificateId,
        CertificateThumbprint,
        EncryptedAESKey
    FROM UnscrubberKey WITH (NOLOCK)
    WHERE CertificateId = @CertificateId
GO
/****** Object:  StoredProcedure [dbo].[proc_GetVersion]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_GetVersion]
(
    @SequenceId uniqueidentifier
)
AS
    SET NOCOUNT ON

    DECLARE @version nvarchar(32) = N'0.0.0.0'
    DECLARE @timeStamp datetime = GETUTCDATE()

    SELECT
        @version = Version,
        @timeStamp = Timestamp
    FROM [Version]
    WHERE VersionId = @SequenceId

    SELECT @version, @timeStamp
GO
/****** Object:  StoredProcedure [dbo].[proc_MigrateTenant]    Script Date: 10/26/2020 9:05:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[proc_MigrateTenant]    Script Date: 5/18/2020 9:01:20 PM ******/
CREATE PROCEDURE [dbo].[proc_MigrateTenant]
(
    @TenantId uniqueIdentifier,
    @TargetDataGroupId uniqueIdentifier
)
AS
    IF @TargetDataGroupId IS NULL OR
       @TenantId IS NULL OR LEN(LTRIM(RTRIM(@TargetDataGroupId))) = 0 OR
       LEN(LTRIM(RTRIM(@TenantId))) = 0
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_MigrateTenant')
        RETURN -1
    END

    DECLARE @DataGroupExists bit = CONVERT(bit, 0)
    DECLARE @TenantExists bit = CONVERT(bit, 0)
    DECLARE @Succeeded bit = CONVERT(bit, 1)
    DECLARE @ExistingDataGroup uniqueIdentifier
    BEGIN TRANSACTION
        SELECT
            @DataGroupExists = CONVERT(bit, 1)
        FROM dbo.DataGroup WITH(UPDLOCK, HOLDLOCK)
        WHERE Id = @TargetDataGroupId

        IF @DataGroupExists = CONVERT(bit, 0)
        BEGIN
            GOTO CLEANUP 
        END
        
        SELECT
            @TenantExists = CONVERT(bit, 1)
        FROM dbo.Tenant WITH(UPDLOCK, HOLDLOCK)
        WHERE Id = @TenantId

        IF @TenantExists = CONVERT(bit, 0)
        BEGIN
            GOTO CLEANUP 
        END
        
        SELECT
            @ExistingDataGroup = DataGroup 
        FROM dbo.Tenant WITH(UPDLOCK, HOLDLOCK)
        WHERE Id = @TenantId
        
        IF @ExistingDataGroup = @TargetDataGroupId 
        BEGIN
            GOTO CLEANUP 
        END
        
        UPDATE Tenant SET DataGroup=@TargetDataGroupId,UpdateTime=GETDATE()  WHERE id=@TenantId;

		IF @@ROWCOUNT <> 1 
        BEGIN
            SELECT @Succeeded = CONVERT(bit, 0)
        END

        INSERT INTO TenantMigrationHistory
        (
            TenantId,
            OriginalDataGroup,
            TargetDataGroup,
            ChangeTime
        )
        VALUES
        (
            @TenantId,
            @ExistingDataGroup,
            @TargetDataGroupId,
            GETDATE()
        )

        IF @@ROWCOUNT <> 1 
        BEGIN
            SELECT @Succeeded = CONVERT(bit, 0)
        END

CLEANUP:
    IF @Succeeded = CONVERT(bit, 0)
    BEGIN
        RAISERROR(
            N'Failed to migrate tenant.',
            18,
            -1) WITH NOWAIT
        ROLLBACK TRANSACTION
    END
    ELSE
    BEGIN
        COMMIT TRANSACTION
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_ReleaseLock]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_ReleaseLock]
(
    @Lock nvarchar(256),
    @Owner nvarchar(64)
)
AS
    SET NOCOUNT ON

    IF (@Lock IS NULL OR LEN(@Lock) = 0) OR
       (@Owner IS NULL OR LEN(@Owner) = 0)
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_ReleaseLock')
        RETURN -1
    END

    DECLARE @preOwner nvarchar(64) = NULL
    DECLARE @expireTime datetime = DATEADD(SECOND, -1, GETUTCDATE())

    BEGIN TRAN
    SELECT @preOwner = Owner
    FROM dbo.Lock
    WHERE Name = @Lock AND
        Expiry > GETUTCDATE()

    IF @preOwner IS NULL
    BEGIN
        ROLLBACK TRAN
        RETURN
    END

    IF @preOwner = @Owner
    BEGIN
        UPDATE dbo.Lock
        SET Expiry = @expireTime
        WHERE Name = @Lock AND
            Owner = @Owner
        COMMIT TRAN
    END
    ELSE
    BEGIN
        ROLLBACK TRAN
        RAISERROR(
            N'The current owner of lock %s is %s. %s is not allowed to relase a lock held by another owner.',
            18,
            -1,
            @Lock,
            @preOwner,
            @Owner) WITH NOWAIT
        RETURN -1
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_RelocateTenant]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_RelocateTenant]
(
    @TenantId uniqueIdentifier,
    @DataGroupId uniqueIdentifier,
	@ReadStatus int
)
AS
    IF @DataGroupId IS NULL OR
       @TenantId IS NULL OR LEN(LTRIM(RTRIM(@DataGroupId))) = 0 OR
       LEN(LTRIM(RTRIM(@TenantId))) = 0
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_RelocateTenant')
        RETURN -1
    END

    DECLARE @DataGroupExists bit = CONVERT(bit, 0)
    DECLARE @TenantExists bit = CONVERT(bit, 0)
    DECLARE @Succeeded bit = CONVERT(bit, 1)
    DECLARE @ExistingDataGroup uniqueIdentifier
    BEGIN TRANSACTION
        SELECT
            @DataGroupExists = CONVERT(bit, 1)
        FROM dbo.DataGroup WITH(UPDLOCK, HOLDLOCK)
        WHERE Id = @DataGroupId

        IF @DataGroupExists = CONVERT(bit, 0)
        BEGIN
            GOTO CLEANUP 
        END
        
        SELECT
            @TenantExists = CONVERT(bit, 1)
        FROM dbo.Tenant WITH(UPDLOCK, HOLDLOCK)
        WHERE Id = @TenantId

        IF @TenantExists = CONVERT(bit, 0)
        BEGIN
            GOTO CLEANUP 
        END
        
        SELECT
            @ExistingDataGroup = DataGroup 
        FROM dbo.Tenant WITH(UPDLOCK, HOLDLOCK)
        WHERE Id = @TenantId
        
        IF @ExistingDataGroup = @DataGroupId 
        BEGIN
            GOTO CLEANUP 
        END
        
        UPDATE Tenant SET DataGroup=@DataGroupId,UpdateTime=GETDATE()  WHERE id=@TenantId;

		IF @@ROWCOUNT <> 1 
        BEGIN
            SELECT @Succeeded = CONVERT(bit, 0)
        END

        INSERT INTO TenantMigration
        (
            TenantId,
            DataGroup,
            ReadStatus,
            MigrationTime
        )
        VALUES 
        (
            @TenantId,
            @ExistingDataGroup,
            @ReadStatus,
            GetDate()
        )

        IF @@ROWCOUNT <> 1 
        BEGIN
            SELECT @Succeeded = CONVERT(bit, 0)
        END

CLEANUP:
    IF @Succeeded = CONVERT(bit, 0)
    BEGIN
        RAISERROR(
            N'Failed to trigger tenant relocation',
            18,
            -1) WITH NOWAIT
        ROLLBACK TRANSACTION
    END
    ELSE
    BEGIN
        COMMIT TRANSACTION
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_SetConfigValue]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[proc_SetConfigValue]
(
    @NameSpace nvarchar(32),
    @Name nvarchar(64),
    @Value nvarchar(max)
)
AS
    SET NOCOUNT ON

    IF @NameSpace IS NULL OR LEN(LTRIM(RTRIM(@Namespace))) = 0 OR
        @Name IS NULL OR LEN(LTRIM(RTRIM(@Name))) = 0
    BEGIN
        RAISERROR(15600, -1, -1, 'proc_SetConfigValue')
        RETURN -1
    END

    DECLARE @id uniqueidentifier = (SELECT Id FROM dbo.ConfigValues WHERE Namespace = @Namespace AND Name = @Name)

    IF @id IS NOT NULL
        UPDATE dbo.ConfigValues
        SET Value = @Value
        WHERE Id = @id
    ELSE
        INSERT INTO dbo.ConfigValues
        (Id, Namespace, Name, Value)
        VALUES
        (newid(), @Namespace, @Name, @Value)
GO
/****** Object:  StoredProcedure [dbo].[proc_SetVersion]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_SetVersion]
(
    @SequenceId uniqueidentifier,
    @Version nvarchar(32)
)
AS
    SET NOCOUNT ON

    IF EXISTS (SELECT TOP 1 1 FROM Version WHERE VersionId = @SequenceId)
        UPDATE [Version]
        SET Version = @Version, Timestamp = GETUTCDATE()
        WHERE VersionId = @SequenceId
    ELSE
        INSERT INTO [Version] ([VersionId], [Version], [Timestamp])
        VALUES (@SequenceId, @Version, GETUTCDATE())
GO
/****** Object:  StoredProcedure [dbo].[proc_UpdateCertificate]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_UpdateCertificate]
(
    @Id uniqueidentifier,
    @UpdatedSubject nvarchar(256),
    @UpdatedThumbprint nvarchar(40),
    @UpdatedExpireTime datetime,
    @UpdatedContent varbinary(8000),
    @UpdatedPassword nvarchar(512)
)
AS
    SET NOCOUNT ON

    IF @Id IS NULL OR
       @UpdatedSubject IS NULL OR
       @UpdatedExpireTime IS NULL OR
       @UpdatedExpireTime IS NULL
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_UpdateCertificate')
        RETURN -1
    END

    UPDATE Certificate 
    SET
        Subject = @UpdatedSubject,
        Thumbprint = @UpdatedThumbprint,
        ExpireTime = @UpdatedExpireTime,
        Content = @UpdatedContent,
        Password = @UpdatedPassword
    WHERE Id = @Id

    SELECT
        Id,
        Subject,
        Thumbprint,
        ExpireTime,
        Content,
        Password
    FROM [dbo].[Certificate]
    WHERE Id = @Id
GO
/****** Object:  StoredProcedure [dbo].[proc_UpdateConfigValue]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[proc_UpdateConfigValue]
(
    @NameSpace nvarchar(32),
    @Name nvarchar(64),
    @Value nvarchar(max)
)
AS
    SET NOCOUNT ON

    IF @NameSpace IS NULL OR LEN(LTRIM(RTRIM(@Namespace))) = 0 OR
        @Name IS NULL OR LEN(LTRIM(RTRIM(@Name))) = 0
    BEGIN
        RAISERROR(15600, -1, -1, 'proc_UpdateConfigValue')
        RETURN -1
    END

    DECLARE @id uniqueidentifier

    SELECT @id = Id
    FROM ConfigValues WITH(UPDLOCK, HOLDLOCK)
    WHERE NameSpace = @NameSpace AND
        Name = @Name

    IF @id IS NOT NULL
        UPDATE ConfigValues
        SET Value = @Value
    ELSE
        INSERT INTO ConfigValues
        (
            Id,
            NameSpace,
            Name,
            Value
        )
        VALUES
        (
            newid(),
            @NameSpace,
            @Name,
            @Value
        )
GO
/****** Object:  StoredProcedure [dbo].[proc_UpdateDataGroup]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_UpdateDataGroup]
(
    @Id uniqueIdentifier,
    @Name nvarchar(64),
    @Status int,
    @State int,
    @AlertEnabled bit = NULL
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@Id) = 0
    BEGIN
        RAISERROR(15600, -1, -1, 'proc_UpdateDataGroup')
        RETURN -1
    END

    DECLARE @strDataGroupId nvarchar(36) = CONVERT(nvarchar(36), @Id)

    IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.DataGroup WHERE Id = @Id)
    BEGIN
        RAISERROR(
            N'Data group %s does not exist.',
            18,
            -1,
            @strDataGroupId) WITH NOWAIT
        RETURN -1
    END

    DECLARE @Succeeded bit = CONVERT(bit, 0)

    BEGIN TRAN

    IF @Name IS NOT NULL AND LEN(LTRIM(RTRIM(@Name))) > 0
    BEGIN
        UPDATE dbo.DataGroup
        SET Name = @Name, UpdateTime = GETUTCDATE()
        WHERE Id = @Id

        IF @@ROWCOUNT <> 1
        GOTO CLEANUP
    END

    IF @Status IS NOT NULL
    BEGIN
        UPDATE dbo.DataGroup
        SET Status = @Status, UpdateTime = GETUTCDATE()
        WHERE Id = @Id

        IF @@ROWCOUNT <> 1
        GOTO CLEANUP
    END

    IF @State IS NOT NULL
    BEGIN
        UPDATE dbo.DataGroup
        SET State = @State, UpdateTime = GETUTCDATE()
        WHERE Id = @Id

        IF @@ROWCOUNT <> 1
        GOTO CLEANUP
    END

    IF @AlertEnabled IS NOT NULL
    BEGIN
        UPDATE dbo.DataGroup
        SET AlertEnabled = @AlertEnabled, UpdateTime = GETUTCDATE()
        WHERE Id = @Id

        IF @@ROWCOUNT <> 1
        GOTO CLEANUP
    END

    SELECT @Succeeded = CONVERT(bit, 1)
CLEANUP:
    IF @Succeeded = CONVERT(bit, 1)
    BEGIN
        COMMIT TRAN
    END
    ELSE
    BEGIN
        ROLLBACK TRAN
        RAISERROR(
            58126,
            11,
            1,
            N'Failed to update service. Please try again later.') WITH NOWAIT
        RETURN -1
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_UpdateDataSubscription]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[proc_UpdateDataSubscription]
(
    @Id uniqueidentifier,
    @Name nvarchar(32),
    @Status int,
    @TenantId uniqueidentifier,
    @MajorCategory nvarchar(64),
    @MinorCategory nvarchar(64)
)
AS
    SET NOCOUNT ON

    IF @Id IS NULL OR
       @Name IS NULL OR
       @Status IS NULL OR
       @TenantId IS NULL OR
       @MajorCategory IS NULL
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_UpdateDataSubscription')
        RETURN -1
    END

    DECLARE @lastTenantId uniqueidentifier = NULL

    SELECT 
        @lastTenantId = Tenant
    FROM Subscription
    WHERE Id = @Id

    IF @lastTenantId IS NULL
    BEGIN
        RAISERROR(
            N'The subscription for the id does not exist.',
            18,
            -1) WITH NOWAIT
        return -1
    END

    IF @lastTenantId <> @TenantId
    BEGIN
        DECLARE @strSubscriptionId nvarchar(36) = CONVERT(nvarchar(36), @Id)
        DECLARE @strLastTenantId nvarchar(36) = CONVERT(nvarchar(36), @lastTenantId)
        DECLARE @strTenantId nvarchar(36) = CONVERT(nvarchar(36), @TenantId)
        RAISERROR(
            N'Moving subscription %s from tenant %s to tenant %s is not allowed.',
            18,
            -1,
            @strSubscriptionId,
            @strLastTenantId,
            @strTenantId) WITH NOWAIT
        return -1
    END

    DECLARE @existingSubscriptionId uniqueidentifier = ( SELECT TOP 1 Id FROM [dbo].[Subscription] WHERE Tenant = @TenantId AND Name = @Name )
    IF @existingSubscriptionId IS NOT NULL AND @existingSubscriptionId <> @Id
    BEGIN
        DECLARE @stringTenantId nvarchar(36) = CONVERT(nvarchar(36), @TenantId)
        DECLARE @stringExistingSubscriptionId nvarchar(36) = CONVERT(nvarchar(36), @existingSubscriptionId)
        RAISERROR(
            N'Subscription %s of tenant %s already exists with Id %s.',
            18,
            -1,
            @Name,
            @stringTenantId,
            @stringExistingSubscriptionId) WITH NOWAIT
        RETURN -1
    END

    UPDATE Subscription 
    SET
        Id=@Id,
        Name=@Name,
        Status=@Status,
        Tenant=@TenantId,
        MajorCategory=@MajorCategory,
        MinorCategory=CASE WHEN @MinorCategory IS NULL THEN N'' ELSE @MinorCategory END,
		UpdateTime=GETUTCDATE()
    WHERE Id=@Id

    IF @@ROWCOUNT <> 1
    BEGIN
        RAISERROR(
            N'Failed to update the subscription.',
            18,
            -1) WITH NOWAIT
        RETURN -1
    END

    SELECT
        Id,
        Name,
        Status,
        Tenant,
        MajorCategory,
        MinorCategory,
        @lastTenantId
    FROM [dbo].[Subscription] 
    WHERE Id = @Id
GO
/****** Object:  StoredProcedure [dbo].[proc_UpdateIngestDataSource]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_UpdateIngestDataSource]
(
    @Id uniqueIdentifier,
    @Name nvarchar(64) = NULL,
    @DataGroup uniqueIdentifier = NULL,
    @Geo nvarchar(32) = NULL,
    @Status int = NULL,
    @Type int = NULL,
    @QueryType int = NULL,
    @CertificateThumbprint nvarchar(40) = NULL,
    @CertificateStoreName nvarchar(30) = NULL,
    @CertificateStoreLocation nvarchar(20) = NULL,
    @QueryUrl nvarchar(200) = NULL,
    @QueryTables nvarchar(1024) = NULL,
    @MaxQueryRetries int = NULL,
    @MaxQueryWaitTimeInSec int = NULL,
    @SleepBetweenRetriesInSec int = NULL,
    @WaterMarkContainer nvarchar(200) = NULL,
    @QueryFilters nvarchar(max) = NULL,
    @UpdateQueryFilter bit = NULL
)
AS
  BEGIN
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@Id) = 0
    BEGIN
        RAISERROR(15600, -1, -1, 'proc_UpdateIngestDataSource: ingest data source Id cannot be Guid.Empty.')
        RETURN -1
    END

    DECLARE @strDataSourceId nvarchar(36) = CONVERT(nvarchar(36), @Id)

    IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.IngestDataSource WHERE Id = @Id)
    BEGIN
        RAISERROR(
            N'Ingestion data source %s does not exist.',
            18,
            -1,
            @strDataSourceId) WITH NOWAIT
        RETURN -1
    END

    DECLARE @CurrentTime DateTime = GETUTCDATE()
    DECLARE @Succeeded bit = CONVERT(bit, 0)

    BEGIN TRAN

    IF @Name IS NOT NULL AND LEN(LTRIM(RTRIM(@Name))) > 0
    BEGIN
        UPDATE dbo.IngestDataSource
        SET Name = @Name, UpdateTime = @CurrentTime
        WHERE Id = @Id

        IF @@ROWCOUNT <> 1
        GOTO CLEANUP
    END

    IF @DataGroup IS NOT NULL
    BEGIN
        -----------------------------------------
        --  DataGroup Id cannot be Guid.Empty  --
        -----------------------------------------
        IF dbo.fn_IsGuidNotEmpty(@DataGroup) = 0
        BEGIN
            RAISERROR(15600, -1, -1, 'proc_UpdateIngestDataSource: ingest data source DataGroupId cannot be Guid.Empty.')
            RETURN -1
        END

        -----------------------------------------
        --   DataGroup must exist in DB        --
        -----------------------------------------
        DECLARE @strDataGroupId nvarchar(36) = CONVERT(nvarchar(36), @DataGroup)
        IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.DataGroup WHERE Id = @DataGroup AND [Type] = 2)
        BEGIN
            RAISERROR(
                N'Ingest type data group %s for the ingest data source does not exist.',
                18,
                -1,
                @strDataGroupId) WITH NOWAIT
            RETURN -1
        END

        UPDATE dbo.IngestDataSource
        SET DataGroup = @DataGroup, UpdateTime = @CurrentTime
        WHERE Id = @Id

        IF @@ROWCOUNT <> 1
        GOTO CLEANUP
    END

    IF  @Geo IS NOT NULL AND LEN(LTRIM(RTRIM(@Geo))) > 0
    BEGIN
        UPDATE dbo.IngestDataSource
        SET Geo = @Geo, UpdateTime = @CurrentTime
        WHERE Id = @Id

        IF @@ROWCOUNT <> 1
        GOTO CLEANUP
    END

    IF  @Status IS NOT NULL
    BEGIN
        UPDATE dbo.IngestDataSource
        SET Status = @Status, UpdateTime = @CurrentTime
        WHERE Id = @Id

        IF @@ROWCOUNT <> 1
        GOTO CLEANUP
    END

    IF  @Type IS NOT NULL
    BEGIN
        UPDATE dbo.IngestDataSource
        SET Type = @Type, UpdateTime = @CurrentTime
        WHERE Id = @Id

        IF @@ROWCOUNT <> 1
        GOTO CLEANUP
    END

    IF  @QueryType IS NOT NULL
    BEGIN
        UPDATE dbo.IngestDataSource
        SET QueryType = @QueryType, UpdateTime = @CurrentTime
        WHERE Id = @Id

        IF @@ROWCOUNT <> 1
        GOTO CLEANUP
    END

    IF  @CertificateThumbprint IS NOT NULL AND LEN(LTRIM(RTRIM(@CertificateThumbprint))) > 0
    BEGIN
        UPDATE dbo.IngestDataSource
        SET CertificateThumbprint = @CertificateThumbprint, UpdateTime = @CurrentTime
        WHERE Id = @Id

        IF @@ROWCOUNT <> 1
        GOTO CLEANUP
    END

    IF  @CertificateStoreName IS NOT NULL AND LEN(LTRIM(RTRIM(@CertificateStoreName))) > 0
    BEGIN
        UPDATE dbo.IngestDataSource
        SET CertificateStoreName = @CertificateStoreName, UpdateTime = @CurrentTime
        WHERE Id = @Id

        IF @@ROWCOUNT <> 1
        GOTO CLEANUP
    END

    IF  @CertificateStoreLocation IS NOT NULL AND LEN(LTRIM(RTRIM(@CertificateStoreLocation))) > 0
    BEGIN
        UPDATE dbo.IngestDataSource
        SET CertificateStoreLocation = @CertificateStoreLocation, UpdateTime = @CurrentTime
        WHERE Id = @Id

        IF @@ROWCOUNT <> 1
        GOTO CLEANUP
    END

    IF  @QueryUrl IS NOT NULL AND LEN(LTRIM(RTRIM(@QueryUrl))) > 0
    BEGIN
        UPDATE dbo.IngestDataSource
        SET QueryUrl = @QueryUrl, UpdateTime = @CurrentTime
        WHERE Id = @Id

        IF @@ROWCOUNT <> 1
        GOTO CLEANUP
    END

    IF  @QueryTables IS NOT NULL AND LEN(LTRIM(RTRIM(@QueryTables))) > 0
    BEGIN
        UPDATE dbo.IngestDataSource
        SET QueryTables = @QueryTables, UpdateTime = @CurrentTime
        WHERE Id = @Id

        IF @@ROWCOUNT <> 1
        GOTO CLEANUP
    END

    ---------------------------------------------------------------------------------
    -- QueryFilter is optional and nullable. 
    -- So reset it even if it is null or string.Empty if specified to be updated. --
    ---------------------------------------------------------------------------------
    IF @UpdateQueryFilter IS NOT NULL AND @UpdateQueryFilter = 1
    BEGIN
        UPDATE dbo.IngestDataSource
        SET QueryFilters = @QueryFilters, UpdateTime = @CurrentTime
        WHERE Id = @Id

        IF @@ROWCOUNT <> 1
        GOTO CLEANUP
    END

    IF  @MaxQueryRetries IS NOT NULL AND @MaxQueryRetries >= 0 AND @MaxQueryRetries <= 10
    BEGIN
        UPDATE dbo.IngestDataSource
        SET MaxQueryRetries = @MaxQueryRetries, UpdateTime = @CurrentTime
        WHERE Id = @Id

        IF @@ROWCOUNT <> 1
        GOTO CLEANUP
    END

    IF  @MaxQueryWaitTimeInSec IS NOT NULL AND @MaxQueryWaitTimeInSec >= 0 AND @MaxQueryWaitTimeInSec <= 500
    BEGIN
        UPDATE dbo.IngestDataSource
        SET MaxQueryWaitTimeInSec = @MaxQueryWaitTimeInSec, UpdateTime = @CurrentTime
        WHERE Id = @Id

        IF @@ROWCOUNT <> 1
        GOTO CLEANUP
    END

    IF  @SleepBetweenRetriesInSec IS NOT NULL AND @SleepBetweenRetriesInSec >= 0 AND @SleepBetweenRetriesInSec <= 30
    BEGIN
        UPDATE dbo.IngestDataSource
        SET SleepBetweenRetriesInSec = @SleepBetweenRetriesInSec, UpdateTime = @CurrentTime
        WHERE Id = @Id

        IF @@ROWCOUNT <> 1
        GOTO CLEANUP
    END

    IF  @WaterMarkContainer IS NOT NULL AND LEN(LTRIM(RTRIM(@WaterMarkContainer))) > 0
    BEGIN
        UPDATE dbo.IngestDataSource
        SET WaterMarkContainer = @WaterMarkContainer, UpdateTime = @CurrentTime
        WHERE Id = @Id

        IF @@ROWCOUNT <> 1
        GOTO CLEANUP
    END

    SELECT @Succeeded = CONVERT(bit, 1)
  CLEANUP:
    IF @Succeeded = CONVERT(bit, 1)
    BEGIN
        COMMIT TRAN
    END
    ELSE
    BEGIN
        ROLLBACK TRAN
        RAISERROR(
            58126,
            11,
            1,
            N'Failed to update IngestDataSource. Please try again later.') WITH NOWAIT
        RETURN -1
    END

  END
GO
/****** Object:  StoredProcedure [dbo].[proc_UpdateService]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_UpdateService]
(
    @Id uniqueidentifier,
    @Name nvarchar(128) = NULL,
    @TypeName nvarchar(256) = NULL,
    @State int = NULL,
    @InstanceDeleteState int,
    @ServiceDeleteState int
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@Id) = 0
    BEGIN
        RAISERROR(15600, -1, -1, 'proc_UpdateService')
        RETURN -1
    END

    DECLARE @strServiceId nvarchar(36) = CONVERT(nvarchar(36), @Id)
    IF @State = @ServiceDeleteState AND EXISTS (
        SELECT TOP 1 1
        FROM dbo.ServiceInstance SI
        WHERE SI.State <> @InstanceDeleteState
    )
    BEGIN
        RAISERROR(
            N'Service with ID %s still have dependant service instances. It cannot be deleted.',
            18,
            -1,
            @strServiceId) WITH NOWAIT
        RETURN -1
    END

    DECLARE @existingServiceId uniqueidentifier
    SELECT TOP 1 @existingServiceId = Id FROM dbo.Service WHERE TypeName = @TypeName
    IF @existingServiceId IS NOT NULL
    BEGIN
        SELECT @strServiceId = CONVERT(nvarchar(36), @existingServiceId)
        RAISERROR(
            N'Service with type name %s already exists with ID %s.',
            18,
            -1,
            @TypeName,
            @strServiceId) WITH NOWAIT
        RETURN -1
    END

    DECLARE @Succeeded bit = CONVERT(bit, 0)
    BEGIN TRAN
    IF @Name IS NOT NULL AND LEN(LTRIM(RTRIM(@Name))) > 0
    BEGIN
        UPDATE dbo.Service
        SET Name = @Name, UpdateTime = GETUTCDATE()
        WHERE Id = @Id
        IF @@ROWCOUNT <> 1
        GOTO CLEANUP
    END

    IF @TypeName IS NOT NULL AND LEN(LTRIM(RTRIM(@TypeName))) > 0
    BEGIN
        UPDATE dbo.Service
        SET TypeName = @TypeName, UpdateTime = GETUTCDATE()
        WHERE Id = @Id
        IF @@ROWCOUNT <> 1
        GOTO CLEANUP
    END

    IF @State IS NOT NULL
    BEGIN
        UPDATE dbo.Service
        SET State = @State, UpdateTime = GETUTCDATE()
        WHERE Id = @Id
        IF @@ROWCOUNT <> 1
        GOTO CLEANUP
    END

    SELECT @Succeeded = CONVERT(bit, 1)
CLEANUP:
    IF @Succeeded = CONVERT(bit, 1)
    BEGIN
        COMMIT TRAN
    END
    ELSE
    BEGIN
        ROLLBACK TRAN
        RAISERROR(
            58126,
            11,
            1,
            N'Failed to update service. Please try again later.') WITH NOWAIT
        RETURN -1
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_UpdateServiceInstance]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_UpdateServiceInstance]
(
    @Id uniqueidentifier,
    @Name nvarchar(128) = NULL,
    @State int = NULL,
    @ServiceDeleteState int
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@Id) = 0
    BEGIN
        RAISERROR(15600, -1, -1, 'proc_UpdateServiceInstance')
        RETURN -1
    END

    DECLARE @serviceId uniqueidentifier
    DECLARE @strServiceInstanceId nvarchar(36) = CONVERT(nvarchar(36), @Id)

    SELECT
        @serviceId = SI.Service
    FROM dbo.Service SV
    JOIN dbo.ServiceInstance SI
        ON SV.Id = SI.Service
    WHERE SI.Id = @Id AND SV.State <> @ServiceDeleteState

    IF @ServiceId IS NULL
    BEGIN
        RAISERROR(
            N'Service of service instance %s not found.',
            18,
            -1,
            @strServiceInstanceId) WITH NOWAIT
        RETURN -1
    END

    DECLARE @Succeeded bit = CONVERT(bit, 0)

    BEGIN TRAN

    IF @Name IS NOT NULL AND LEN(LTRIM(RTRIM(@Name))) > 0
    BEGIN
        UPDATE dbo.ServiceInstance
        SET Name = @Name, UpdateTime = GETUTCDATE()
        WHERE Id = @Id

        IF @@ROWCOUNT <> 1
        GOTO CLEANUP
    END

    IF @State IS NOT NULL
    BEGIN
        UPDATE dbo.ServiceInstance
        SET State = @State, UpdateTime = GETUTCDATE()
        WHERE Id = @Id

        IF @@ROWCOUNT <> 1
        GOTO CLEANUP
    END

    SELECT @Succeeded = CONVERT(bit, 1)
CLEANUP:
    IF @Succeeded = CONVERT(bit, 1)
    BEGIN
        COMMIT TRAN
    END
    ELSE
    BEGIN
        ROLLBACK TRAN
        RAISERROR(
            58126,
            11,
            1,
            N'Failed to update service instance. Please try again later.') WITH NOWAIT
        RETURN -1
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_UpdateTenant]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[proc_UpdateTenant]
(
    @TenantId uniqueidentifier,
    @Name nvarchar(64),
    @AuditingEnabled bit,
    @State int = NULL,
    @Type int = NULL,
    @LoadBalanceCount int = NULL
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@TenantId) = 0 OR
       @Name IS NULL OR LEN(LTRIM(RTRIM(@Name))) = 0 OR
       @AuditingEnabled IS NULL
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_UpdateTenant')
        RETURN -1
    END

    UPDATE dbo.Tenant
    SET
        Id = @TenantId,
        Name = @Name,
        AuditingEnabled = @AuditingEnabled,
        State = @State,
        Type = @Type,
        LoadBalanceCount = @LoadBalanceCount,
        UpdateTime = GETUTCDATE()
    WHERE
        Id = @TenantId

    IF @@ROWCOUNT <> 1
    BEGIN
        RAISERROR(
            58126,
            11,
            1,
            N'Failed to update the tenant. Please try again later.') WITH NOWAIT
        RETURN -1
    END
GO
/****** Object:  StoredProcedure [dbo].[proc_UpdateTenantCert]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_UpdateTenantCert]
(
    @Tenant uniqueidentifier,
    @Certificate uniqueidentifier,
    @Role int
)
AS
    SET NOCOUNT ON

    IF @Tenant IS NULL OR
       @Certificate IS NULL OR
       @Role IS NULL
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_UpdateTenantCert')
        RETURN -1
    END

    UPDATE TenantCert 
    SET
        Tenant=@Tenant,
        Certificate=@Certificate,
        Role=@Role
    WHERE Tenant=@Tenant AND Certificate=@Certificate

    SELECT
        Tenant,
        Certificate,
        Role
    FROM [dbo].[TenantCert]
    WHERE Tenant = @Tenant AND Certificate = @Certificate
GO
/****** Object:  StoredProcedure [dbo].[proc_UpdateTenantMigrationReadStatus]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_UpdateTenantMigrationReadStatus]
(
    @tenantId uniqueidentifier,
    @dataGroup uniqueidentifier,
    @migratedFromTime datetime,
    @readCompleteState int,
    @readInProgressState int
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@TenantId) = 0 OR
       dbo.fn_IsGuidNotEmpty(@dataGroup) = 0 OR
       @migratedFromTime IS NULL OR
       @readCompleteState IS NULL OR
       @readInProgressState IS NULL
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_UpdateTenantMigrationReadStatus')
        RETURN -1
    END

    UPDATE dbo.TenantMigration
    SET ReadStatus = (@readCompleteState | ReadStatus) & (~ @readInProgressState)
    WHERE tenantId = @tenantId AND DataGroup = @dataGroup AND MigrationTime = @migratedFromTime

    IF @@ROWCOUNT = 0
        RAISERROR(
            N'Failed to update the tenant Migration. The tenant does not exist.',
            18,
            -1) WITH NOWAIT
GO
/****** Object:  StoredProcedure [dbo].[proc_UpdateTenantReceiverPolicy]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_UpdateTenantReceiverPolicy]
(
    @TenantId uniqueidentifier,
    @ReceiverPolicy nvarchar(64),
    @ReceiverAccessKey nvarchar(512),
    @SecondaryReceiverPolicy nvarchar(64) = NULL,
    @SecondaryReceiverAccessKey nvarchar(512) = NULL
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@TenantId) = 0 OR
       LEN(LTRIM(RTRIM(@ReceiverPolicy))) = 0 OR
       LEN(LTRIM(RTRIM(@ReceiverAccessKey))) = 0
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_UpdateTenantReceiverPolicy')
        RETURN -1
    END

    UPDATE dbo.Tenant 
    SET
        ReceiverPolicy = @ReceiverPolicy,
        ReceiverAccessKey = @ReceiverAccessKey,
        SecondaryReceiverPolicy = @SecondaryReceiverPolicy,
        SecondaryReceiverAccessKey = @SecondaryReceiverAccessKey,
        UpdateTime = GETUTCDATE()
    WHERE Id = @TenantId

    IF @@ROWCOUNT = 0
        RAISERROR(
            N'Failed to update the tenant receiver policy. The tenant does not exist.',
            18,
            -1) WITH NOWAIT
GO
/****** Object:  StoredProcedure [dbo].[proc_UpdateTenantUserPolicyBinaryData]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_UpdateTenantUserPolicyBinaryData]
(
    @TenantId uniqueidentifier,
    @BinaryData varbinary(max)
)
AS
    SET NOCOUNT ON

    IF NOT EXISTS (SELECT 1 FROM TenantUserPolicyBinaryData WHERE TenantId = @TenantId)
    
    INSERT INTO [TenantUserPolicyBinaryData] ([TenantId] , [BinaryData], [CreationTime],[UpdateTime]) 
        VALUES  (  @TenantId, @BinaryData, GETUTCDATE(), GETUTCDATE())
    ELSE
    UPDATE [TenantUserPolicyBinaryData] 
    SET [BinaryData] = @BinaryData,  [UpdateTime] = GETUTCDATE()
    WHERE TenantId = @TenantId
GO
/****** Object:  StoredProcedure [dbo].[sp_alterdiagram]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_alterdiagram]
	(
		@diagramname 	sysname,
		@owner_id	int	= null,
		@version 	int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId 			int
		declare @retval 		int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @ShouldChangeUID	int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid ARG', 16, 1)
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();	 
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		revert;
	
		select @ShouldChangeUID = 0
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		
		if(@DiagId IS NULL or (@IsDbo = 0 and @theId <> @UIDFound))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end
	
		if(@IsDbo <> 0)
		begin
			if(@UIDFound is null or USER_NAME(@UIDFound) is null) -- invalid principal_id
			begin
				select @ShouldChangeUID = 1 ;
			end
		end

		-- update dds data			
		update dbo.sysdiagrams set definition = @definition where diagram_id = @DiagId ;

		-- change owner
		if(@ShouldChangeUID = 1)
			update dbo.sysdiagrams set principal_id = @theId where diagram_id = @DiagId ;

		-- update dds version
		if(@version is not null)
			update dbo.sysdiagrams set version = @version where diagram_id = @DiagId ;

		return 0
	END
	
GO
/****** Object:  StoredProcedure [dbo].[sp_creatediagram]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_creatediagram]
	(
		@diagramname 	sysname,
		@owner_id		int	= null, 	
		@version 		int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId int
		declare @retval int
		declare @IsDbo	int
		declare @userName sysname
		if(@version is null or @diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID(); 
		select @IsDbo = IS_MEMBER(N'db_owner');
		revert; 
		
		if @owner_id is null
		begin
			select @owner_id = @theId;
		end
		else
		begin
			if @theId <> @owner_id
			begin
				if @IsDbo = 0
				begin
					RAISERROR (N'E_INVALIDARG', 16, 1);
					return -1
				end
				select @theId = @owner_id
			end
		end
		-- next 2 line only for test, will be removed after define name unique
		if EXISTS(select diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @diagramname)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end
	
		insert into dbo.sysdiagrams(name, principal_id , version, definition)
				VALUES(@diagramname, @theId, @version, @definition) ;
		
		select @retval = @@IDENTITY 
		return @retval
	END
	
GO
/****** Object:  StoredProcedure [dbo].[sp_dropdiagram]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_dropdiagram]
	(
		@diagramname 	sysname,
		@owner_id	int	= null
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT; 
		
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		delete from dbo.sysdiagrams where diagram_id = @DiagId;
	
		return 0;
	END
	
GO
/****** Object:  StoredProcedure [dbo].[sp_helpdiagramdefinition]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_helpdiagramdefinition]
	(
		@diagramname 	sysname,
		@owner_id	int	= null 		
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		set nocount on

		declare @theId 		int
		declare @IsDbo 		int
		declare @DiagId		int
		declare @UIDFound	int
	
		if(@diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner');
		if(@owner_id is null)
			select @owner_id = @theId;
		revert; 
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname;
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId ))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end

		select version, definition FROM dbo.sysdiagrams where diagram_id = @DiagId ; 
		return 0
	END
	
GO
/****** Object:  StoredProcedure [dbo].[sp_helpdiagrams]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_helpdiagrams]
	(
		@diagramname sysname = NULL,
		@owner_id int = NULL
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		DECLARE @user sysname
		DECLARE @dboLogin bit
		EXECUTE AS CALLER;
			SET @user = USER_NAME();
			SET @dboLogin = CONVERT(bit,IS_MEMBER('db_owner'));
		REVERT;
		SELECT
			[Database] = DB_NAME(),
			[Name] = name,
			[ID] = diagram_id,
			[Owner] = USER_NAME(principal_id),
			[OwnerID] = principal_id
		FROM
			sysdiagrams
		WHERE
			(@dboLogin = 1 OR USER_NAME(principal_id) = @user) AND
			(@diagramname IS NULL OR name = @diagramname) AND
			(@owner_id IS NULL OR principal_id = @owner_id)
		ORDER BY
			4, 5, 1
	END
	
GO
/****** Object:  StoredProcedure [dbo].[sp_perf_stats_azure]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[sp_perf_stats_azure] @appname sysname='PSSDIAG', @runtime datetime AS 
BEGIN 
  SET NOCOUNT ON
  DECLARE @msg varchar(100)
  DECLARE @querystarttime datetime
  DECLARE @queryduration int
  DECLARE @qrydurationwarnthreshold int
  DECLARE @servermajorversion int
  DECLARE @cpu_time_start bigint, @elapsed_time_start bigint
  DECLARE @sql nvarchar(max)
  DECLARE @cte nvarchar(max)
  DECLARE @rowcount bigint

  SELECT @cpu_time_start = cpu_time, @elapsed_time_start = total_elapsed_time FROM sys.dm_exec_requests WHERE session_id = @@SPID

  --IF OBJECT_ID ('tempdb.dbo.#tmp_requests') IS NULL DROP TABLE #tmp_requests
  --IF OBJECT_ID ('tempdb.dbo.#tmp_requests2') IS NULL DROP TABLE #tmp_requests2
  
  IF @runtime IS NULL 
  BEGIN 
    SET @runtime = GETDATE()
    SET @msg = 'Start time: ' + CONVERT (varchar(30), @runtime, 126)
    RAISERROR (@msg, 0, 1) WITH NOWAIT
  END
  SET @qrydurationwarnthreshold = 500
  
  -- SERVERPROPERTY ('ProductVersion') returns e.g. "9.00.2198.00" --> 9
  SET @servermajorversion = REPLACE (LEFT (CONVERT (varchar, SERVERPROPERTY ('ProductVersion')), 2), '.', '')

  RAISERROR (@msg, 0, 1) WITH NOWAIT
  SET @querystarttime = GETDATE()

declare @tmp_requests table(
	[session_id] [smallint] NULL,
	[request_id] [int] NULL,
	[ecid] [int] NULL,
	[task_address] [varbinary](8) NULL,
	[blocking_session_id] [smallint] NULL,
	[task_state] [nvarchar](15) NULL,
	[scheduler_id] [int] NULL,
	[wait_type] [nvarchar](50) NULL,
	[wait_resource] [nvarchar](40) NULL,
	[last_wait_type] [nvarchar](50) NULL,
	[open_trans] [int] NULL,
	[transaction_isolation_level] [varchar](30) NULL,
	[is_user_process] [bit] NULL,
	[request_cpu_time] [int] NULL,
	[request_logical_reads] [bigint] NULL,
	[request_reads] [bigint] NULL,
	[request_writes] [bigint] NULL,
	[memory_usage] [int] NULL,
	[session_cpu_time] [int] NULL,
	[session_reads] [bigint] NULL,
	[session_writes] [bigint] NULL,
	[session_logical_reads] [bigint] NULL,
	[total_scheduled_time] [int] NULL,
	[total_elapsed_time] [int] NULL,
	[last_request_start_time] [datetime] NULL,
	[last_request_end_time] [datetime] NULL,
	[session_row_count] [bigint] NULL,
	[prev_error] [int] NULL,
	[open_resultsets] [int] NULL,
	[request_total_elapsed_time] [int] NULL,
	[percent_complete] [decimal](5, 2) NULL,
	[est_completion_time] [bigint] NULL,
	[transaction_id] [bigint] NULL,
	[request_start_time] [datetime] NULL,
	[request_status] [nvarchar](15) NULL,
	[command] [nvarchar](16) NULL,
	[plan_handle] [varbinary](64) NULL,
	[sql_handle] [varbinary](64) NULL,
	[statement_start_offset] [int] NULL,
	[statement_end_offset] [int] NULL,
	[database_id] [smallint] NULL,
	[user_id] [int] NULL,
	[executing_managed_code] [bit] NULL,
	[pending_io_count] [int] NULL,
	[login_time] [datetime] NULL,
	[host_name] [nvarchar](20) NULL,
	[program_name] [nvarchar](50) NULL,
	[host_process_id] [int] NULL,
	[client_version] [int] NULL,
	[client_interface_name] [nvarchar](30) NULL,
	[login_name] [nvarchar](30) NULL,
	[nt_domain] [nvarchar](30) NULL,
	[nt_user_name] [nvarchar](20) NULL,
	[net_packet_size] [int] NULL,
	[client_net_address] [varchar](20) null,
	[most_recent_sql_handle] [varbinary](64) null,
	[session_status] [nvarchar](15) null,
	[group_id] [int] null,
	wait_time int,
	[context_info] varbinary(128)
)


--select * from sys.dm_exec_sessions



insert into @tmp_requests
  SELECT
    sess.session_id, req.request_id, null ecid, null task_address, req.blocking_session_id,  null task_state, 
    null scheduler_id, LEFT (ISNULL (req.wait_type, ''), 50) AS wait_type, LEFT (ISNULL (req.wait_resource, ''), 40) AS wait_resource, 
    LEFT (req.last_wait_type, 50) AS last_wait_type, 
    sess_tran.open_transaction_count as     open_trans, 
    
    LEFT (CASE COALESCE(req.transaction_isolation_level, sess.transaction_isolation_level)
      WHEN 0 THEN '0-Read Committed' 
      WHEN 1 THEN '1-Read Uncommitted (NOLOCK)' 
      WHEN 2 THEN '2-Read Committed' 
      WHEN 3 THEN '3-Repeatable Read' 
      WHEN 4 THEN '4-Serializable' 
      WHEN 5 THEN '5-Snapshot' 
      ELSE CONVERT (varchar(30), req.transaction_isolation_level) + '-UNKNOWN' 
    END, 30) AS transaction_isolation_level, 
    sess.is_user_process, req.cpu_time AS request_cpu_time, 
    req.logical_reads request_logical_reads,
    req.reads request_reads,
     req.writes request_writes,
    sess.memory_usage, sess.cpu_time AS session_cpu_time, sess.reads AS session_reads, sess.writes AS session_writes, sess.logical_reads AS session_logical_reads, 
    sess.total_scheduled_time, sess.total_elapsed_time, sess.last_request_start_time, sess.last_request_end_time, sess.row_count AS session_row_count, 
    sess.prev_error, req.open_resultset_count AS open_resultsets, req.total_elapsed_time AS request_total_elapsed_time, 
    CONVERT (decimal(5,2), req.percent_complete) AS percent_complete, req.estimated_completion_time AS est_completion_time, req.transaction_id, 
    req.start_time AS request_start_time, LEFT (req.status, 15) AS request_status, req.command, req.plan_handle, req.sql_handle, req.statement_start_offset, 
    req.statement_end_offset, req.database_id, req.[user_id], req.executing_managed_code, null pending_io_count, sess.login_time, 
    LEFT (sess.[host_name], 20) AS [host_name], LEFT (ISNULL (sess.program_name, ''), 50) AS program_name, ISNULL (sess.host_process_id, 0) AS host_process_id, 
    ISNULL (sess.client_version, 0) AS client_version, LEFT (ISNULL (sess.client_interface_name, ''), 30) AS client_interface_name, 
    LEFT (ISNULL (sess.login_name, ''), 30) AS login_name, LEFT (ISNULL (sess.nt_domain, ''), 30) AS nt_domain, LEFT (ISNULL (sess.nt_user_name, ''), 20) AS nt_user_name, 
    ISNULL (conn.net_packet_size, 0) AS net_packet_size, LEFT (ISNULL (conn.client_net_address, ''), 20) AS client_net_address, conn.most_recent_sql_handle, 
    LEFT (sess.status, 15) AS session_status,
    /* sys.dm_os_workers and sys.dm_os_threads removed due to perf impact, no predicate pushdown (SQLBU #488971) */
    --  workers.is_preemptive,
    --  workers.is_sick, 
    --  workers.exception_num AS last_worker_exception, 
    --  convert (varchar (20), master.dbo.fn_varbintohexstr (workers.exception_address)) AS last_exception_address
    --  threads.os_thread_id 
    sess.group_id,
    req.wait_time,
    sess.[context_info]
    
  --INTO #tmp_requests
  FROM sys.dm_exec_sessions sess 
  /* Join hints are required here to work around bad QO join order/type decisions (ultimately by-design, caused by the lack of accurate DMV card estimates) */
  LEFT OUTER MERGE JOIN sys.dm_exec_requests req  ON sess.session_id = req.session_id
  --LEFT OUTER MERGE JOIN sys.dm_os_tasks tasks ON tasks.session_id = sess.session_id AND tasks.request_id = req.request_id 
  /* The following two DMVs removed due to perf impact, no predicate pushdown (SQLBU #488971) */
  --  LEFT OUTER MERGE JOIN sys.dm_os_workers workers ON tasks.worker_address = workers.worker_address
  --  LEFT OUTER MERGE JOIN sys.dm_os_threads threads ON workers.thread_address = threads.thread_address
  LEFT OUTER MERGE JOIN sys.dm_exec_connections conn on conn.session_id = sess.session_id
  left outer merge join sys.dm_tran_session_transactions sess_tran on sess.session_id=sess_tran.session_id
  WHERE 
    /* Get execution state for all active queries... */
    
    (req.session_id IS not NULL AND (sess.is_user_process = 1 OR req.status  NOT IN ('background', 'sleeping')))
    /* ... and also any head blockers, even though they may not be running a query at the moment. */
    OR (sess.session_id IN (SELECT DISTINCT blocking_session_id FROM sys.dm_exec_requests WHERE blocking_session_id != 0))
  /* redundant due to the use of join hints, but added here to suppress warning message */
  OPTION (FORCE ORDER, recompile) 
  
  
  SET @rowcount = @@ROWCOUNT
  SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
  IF @queryduration > @qrydurationwarnthreshold
    PRINT 'DebugPrint: perfstats qry1 - ' + CONVERT (varchar, @queryduration) + 'ms, rowcount=' + CONVERT(varchar, @rowcount) + CHAR(13) + CHAR(10)

  IF NOT EXISTS (SELECT * FROM @tmp_requests WHERE session_id <> @@SPID AND ISNULL (host_name, '') != @appname) BEGIN
    PRINT 'No active queries'
  END
  ELSE BEGIN
    -- There are active queries (other than this one). 
    -- This query could be collapsed into the query above.  It is broken out here to avoid an excessively 
    -- large memory grant due to poor cardinality estimates (see previous bugs -- ultimate cause is the 
    -- lack of good stats for many DMVs). 
    SET @querystarttime = GETDATE()
declare @tmp_requests2 table(
	[tmprownum] [int]  NULL,
	[session_id] [smallint] NULL,
	[request_id] [int] NULL,
	[ecid] [int] NULL,
	[blocking_session_id] [smallint] NULL,
	[blocking_ecid] [int] NULL ,
	[task_state] [nvarchar](15) NULL,
	[wait_type] [nvarchar](60) NULL,
	[wait_duration_ms] [bigint] NULL,
	[wait_resource] [nvarchar](40) NULL,
	[resource_description] [nvarchar](140) NULL,
	[last_wait_type] [nvarchar](50) NULL,
	[open_trans] [int] NULL,
	[transaction_isolation_level] [varchar](30) NULL,
	[is_user_process] [bit] NULL,
	[request_cpu_time] [int] NULL,
	[request_logical_reads] [bigint] NULL,
	[request_reads] [bigint] NULL,
	[request_writes] [bigint] NULL,
	[memory_usage] [int] NULL,
	[session_cpu_time] [int] NULL,
	[session_reads] [bigint] NULL,
	[session_writes] [bigint] NULL,
	[session_logical_reads] [bigint] NULL,
	[total_scheduled_time] [int] NULL,
	[total_elapsed_time] [int] NULL,
	[last_request_start_time] [datetime] NULL,
	[last_request_end_time] [datetime] NULL,
	[session_row_count] [bigint] NULL,
	[prev_error] [int] NULL,
	[open_resultsets] [int] NULL,
	[request_total_elapsed_time] [int] NULL,
	[percent_complete] [decimal](5, 2) NULL,
	[est_completion_time] [bigint] NULL,
	[tran_name] [nvarchar](24) NULL,
	[transaction_begin_time] [datetime] NULL,
	[tran_type] [varchar](15) NULL,
	[tran_state] [varchar](15) NULL,
	[request_start_time] [datetime] NULL,
	[request_status] [nvarchar](15) NULL,
	[command] [nvarchar](16) NULL,
	[plan_handle] [varbinary](64) NULL,
	[sql_handle] [varbinary](64) NULL,
	[statement_start_offset] [int] NULL,
	[statement_end_offset] [int] NULL,
	[database_id] [smallint] NULL,
	[user_id] [int] NULL,
	[executing_managed_code] [bit] NULL,
	[pending_io_count] [int] NULL,
	[login_time] [datetime] NULL,
	[host_name] [nvarchar](20) NULL,
	[program_name] [nvarchar](50) NULL,
	[host_process_id] [int] NULL,
	[client_version] [int] NULL,
	[client_interface_name] [nvarchar](30) NULL,
	[login_name] [nvarchar](30) NULL,
	[nt_domain] [nvarchar](30) NULL,
	[nt_user_name] [nvarchar](20) NULL,
	[net_packet_size] [int] NULL,
	[client_net_address] [varchar](20) null,
	[most_recent_sql_handle] [varbinary](64) null,
	[session_status] [nvarchar](15) null ,
	[scheduler_id] [int] null ,
	[group_id] [int] null,
	[context_info] varbinary(128) null
	
) 



insert into @tmp_requests2

    SELECT 
      --IDENTITY (int,1,1) AS tmprownum, 
      row_number() over (order by  r.session_id) as tmprownum,
      r.session_id, r.request_id, r.ecid, r.blocking_session_id, null blocking_ecid, 
      r.task_state, r.wait_type, r.wait_time wait_duration_ms, r.wait_resource, 
      null resource_description, r.last_wait_type, r.open_trans, 
      r.transaction_isolation_level, r.is_user_process, r.request_cpu_time, r.request_logical_reads, r.request_reads, 
      r.request_writes, r.memory_usage, r.session_cpu_time, r.session_reads, r.session_writes, r.session_logical_reads, 
      r.total_scheduled_time, r.total_elapsed_time, r.last_request_start_time, r.last_request_end_time, r.session_row_count, 
      r.prev_error, r.open_resultsets, r.request_total_elapsed_time, r.percent_complete, r.est_completion_time, 
      -- r.tran_name, r.transaction_begin_time, r.tran_type, r.tran_state, 
      LEFT (COALESCE (reqtrans.name, sesstrans.name, ''), 24) AS tran_name, 
      COALESCE (reqtrans.transaction_begin_time, sesstrans.transaction_begin_time) AS transaction_begin_time, 
      LEFT (CASE COALESCE (reqtrans.transaction_type, sesstrans.transaction_type)
        WHEN 1 THEN '1-Read/write'
        WHEN 2 THEN '2-Read only'
        WHEN 3 THEN '3-System'
        WHEN 4 THEN '4-Distributed'
        ELSE CONVERT (varchar(30), COALESCE (reqtrans.transaction_type, sesstrans.transaction_type)) + '-UNKNOWN' 
      END, 15) AS tran_type, 
      LEFT (CASE COALESCE (reqtrans.transaction_state, sesstrans.transaction_state)
        WHEN 0 THEN '0-Initializing'
        WHEN 1 THEN '1-Initialized'
        WHEN 2 THEN '2-Active'
        WHEN 3 THEN '3-Ended'
        WHEN 4 THEN '4-Preparing'
        WHEN 5 THEN '5-Prepared'
        WHEN 6 THEN '6-Committed'
        WHEN 7 THEN '7-Rolling back'
        WHEN 8 THEN '8-Rolled back'
        ELSE CONVERT (varchar(30), COALESCE (reqtrans.transaction_state, sesstrans.transaction_state)) + '-UNKNOWN'
      END, 15) AS tran_state, 
      r.request_start_time, r.request_status, r.command, r.plan_handle, r.sql_handle, r.statement_start_offset, 
      r.statement_end_offset, r.database_id, r.[user_id], r.executing_managed_code, r.pending_io_count, r.login_time, 
      r.[host_name], r.program_name, r.host_process_id, r.client_version, r.client_interface_name, r.login_name, r.nt_domain, 
      r.nt_user_name, r.net_packet_size, r.client_net_address, r.most_recent_sql_handle, r.session_status, r.scheduler_id,
      -- r.is_preemptive, r.is_sick, r.last_worker_exception, r.last_exception_address, 
      -- r.os_thread_id
      r.group_id,
      r.[context_info]
    
    FROM @tmp_requests r
    /* Join hints are required here to work around bad QO join order/type decisions (ultimately by-design, caused by the lack of accurate DMV card estimates) */
    LEFT OUTER MERGE JOIN sys.dm_tran_active_transactions reqtrans ON r.transaction_id = reqtrans.transaction_id
    
    LEFT OUTER MERGE JOIN sys.dm_tran_session_transactions sessions_transactions on sessions_transactions.session_id = r.session_id
    
    LEFT OUTER MERGE JOIN sys.dm_tran_active_transactions sesstrans ON sesstrans.transaction_id = sessions_transactions.transaction_id
    
    --LEFT OUTER MERGE JOIN sys.dm_os_waiting_tasks waits ON waits.waiting_task_address = r.task_address 
    ORDER BY r.session_id, blocking_ecid
    
    
    /* redundant due to the use of join hints, but added here to suppress warning message */
    OPTION (FORCE ORDER)  
    SET @rowcount = @@ROWCOUNT
    SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
    IF @queryduration > @qrydurationwarnthreshold
      PRINT 'DebugPrint: perfstats qry2 - ' + CONVERT (varchar, @queryduration) + 'ms, rowcount=' + CONVERT(varchar, @rowcount) + CHAR(13) + CHAR(10)

    /* This index typically takes <10ms to create, and drops the head blocker summary query cost from ~250ms CPU down to ~20ms. */
    --CREATE NONCLUSTERED INDEX idx1 ON #tmp_requests2 (blocking_session_id, session_id, wait_type, wait_duration_ms)
    RAISERROR ('-- requests --', 0, 1) WITH NOWAIT
    /* Output Resultset #1: summary of all active requests (and head blockers) */
    /* Dynamic (but explicitly parameterized) SQL used here to allow for (optional) direct-to-database data collection 
    ** without unnecessary code duplication. */
    
    
    
    SET @querystarttime = GETDATE()

    SELECT TOP 10000 CONVERT (varchar(30), @runtime, 126) AS runtime, 
      session_id, request_id, ecid, blocking_session_id, blocking_ecid, task_state, 
      wait_type, wait_duration_ms, wait_resource, resource_description, last_wait_type, 
      open_trans, transaction_isolation_level, is_user_process, 
      request_cpu_time, request_logical_reads, request_reads, request_writes, memory_usage, 
      session_cpu_time, session_reads, session_writes, session_logical_reads, total_scheduled_time, 
      total_elapsed_time, CONVERT (varchar, last_request_start_time, 126) AS last_request_start_time, 
      CONVERT (varchar, last_request_end_time, 126) AS last_request_end_time, session_row_count, 
      prev_error, open_resultsets, request_total_elapsed_time, percent_complete, 
      est_completion_time, tran_name, 
      CONVERT (varchar, transaction_begin_time, 126) AS transaction_begin_time, tran_type, 
      tran_state, CONVERT (varchar, request_start_time, 126) AS request_start_time, request_status, 
      command, statement_start_offset, statement_end_offset, database_id, [user_id], 
      executing_managed_code, pending_io_count, CONVERT (varchar, login_time, 126) AS login_time, 
      [host_name], program_name, host_process_id, client_version, client_interface_name, login_name, 
      nt_domain, nt_user_name, net_packet_size, client_net_address, session_status, 
      scheduler_id,
      -- is_preemptive, is_sick, last_worker_exception, last_exception_address
      -- os_thread_id
      group_id,
      [context_info]
    FROM @tmp_requests2 r
    WHERE ISNULL ([host_name], '''') != @appname /*AND r.session_id != @@SPID*/
      /* One EC can have multiple waits in sys.dm_os_waiting_tasks (e.g. parent thread waiting on multiple children, for example 
      ** for parallel create index; or mem grant waits for RES_SEM_FOR_QRY_COMPILE).  This will result in the same EC being listed 
      ** multiple times in the request table, which is counterintuitive for most people.  Instead of showing all wait relationships, 
      ** for each EC we will report the wait relationship that has the longest wait time.  (If there are multiple relationships with 
      ** the same wait time, blocker spid/ecid is used to choose one of them.)  If it were not for , we would do this 
      ** exclusion in the previous query to avoid storing data that will ultimately be filtered out. */
      AND NOT EXISTS 
        (SELECT * FROM @tmp_requests2 r2 
         WHERE r.session_id = r2.session_id AND r.request_id = r2.request_id AND r.ecid = r2.ecid AND r.wait_type = r2.wait_type 
           AND (r2.wait_duration_ms > r.wait_duration_ms OR (r2.wait_duration_ms = r.wait_duration_ms AND r2.tmprownum > r.tmprownum)))
    option (recompile)
    
    SET @rowcount = @@ROWCOUNT
    SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
    RAISERROR ('', 0, 1) WITH NOWAIT
    IF @queryduration > @qrydurationwarnthreshold
      PRINT 'DebugPrint: perfstats qry3 - ' + CONVERT (varchar, @queryduration) + 'ms, rowcount=' + CONVERT(varchar, @rowcount) + CHAR(13) + CHAR(10)

    /* Resultset #2: Head blocker summary */
    /* Intra-query blocking relationships (parallel query waits) aren't "true" blocking problems that we should report on here. */
    IF NOT EXISTS (SELECT * FROM @tmp_requests2 WHERE blocking_session_id != 0 AND wait_type NOT IN ('WAITFOR', 'EXCHANGE', 'CXPACKET')) 
    BEGIN 
      PRINT ''
      PRINT '-- No blocking detected --'
      PRINT ''
    END
    ELSE BEGIN
      PRINT ''
      PRINT '-----------------------'
      PRINT '-- BLOCKING DETECTED --'
      PRINT ''
      RAISERROR ('-- headblockersummary --', 0, 1) WITH NOWAIT;
      /* We need stats like the number of spids blocked, max waittime, etc, for each head blocker.  Use a recursive CTE to 
      ** walk the blocking hierarchy. Again, explicitly parameterized dynamic SQL used to allow optional collection direct  
      ** to a database. */
        --SET @sql = @cte + @sql
      SET @querystarttime = GETDATE();
      --EXEC sp_executesql @sql, N'@runtime datetime', @runtime = @runtime
      
      WITH BlockingHierarchy (head_blocker_session_id, session_id, blocking_session_id, wait_type, wait_duration_ms, 
        wait_resource, statement_start_offset, statement_end_offset, plan_handle, sql_handle, most_recent_sql_handle, [Level]) 
      AS (
        SELECT head.session_id AS head_blocker_session_id, head.session_id AS session_id, head.blocking_session_id, 
          head.wait_type, head.wait_duration_ms, head.wait_resource, head.statement_start_offset, head.statement_end_offset, 
          head.plan_handle, head.sql_handle, head.most_recent_sql_handle, 0 AS [Level]
        FROM @tmp_requests2 head
        WHERE (head.blocking_session_id IS NULL OR head.blocking_session_id = 0) 
          AND head.session_id IN (SELECT DISTINCT blocking_session_id FROM @tmp_requests2 WHERE blocking_session_id != 0) 
        UNION ALL 
        SELECT h.head_blocker_session_id, blocked.session_id, blocked.blocking_session_id, blocked.wait_type, 
          blocked.wait_duration_ms, blocked.wait_resource, h.statement_start_offset, h.statement_end_offset, 
          h.plan_handle, h.sql_handle, h.most_recent_sql_handle, [Level] + 1
        FROM @tmp_requests2 blocked
        INNER JOIN BlockingHierarchy AS h ON h.session_id = blocked.blocking_session_id and h.session_id!=blocked.session_id --avoid infinite recursion for latch type of blocknig
        WHERE h.wait_type COLLATE Latin1_General_BIN NOT IN ('EXCHANGE', 'CXPACKET') or h.wait_type is null 
      )
      SELECT CONVERT (varchar(30), @runtime, 126) AS runtime, 
        head_blocker_session_id, COUNT(*) AS blocked_task_count, SUM (ISNULL (wait_duration_ms, 0)) AS tot_wait_duration_ms, 
        LEFT (CASE 
          WHEN wait_type LIKE 'LCK%' COLLATE Latin1_General_BIN AND wait_resource LIKE '%\[COMPILE\]%' ESCAPE '\' COLLATE Latin1_General_BIN 
            THEN 'COMPILE (' + ISNULL (wait_resource, '') + ')' 
          WHEN wait_type LIKE 'LCK%' COLLATE Latin1_General_BIN THEN 'LOCK BLOCKING' 
          WHEN wait_type LIKE 'PAGELATCH%' COLLATE Latin1_General_BIN THEN 'PAGELATCH_* WAITS' 
          WHEN wait_type LIKE 'PAGEIOLATCH%' COLLATE Latin1_General_BIN THEN 'PAGEIOLATCH_* WAITS' 
          ELSE wait_type
        END, 40) AS blocking_resource_wait_type, AVG (ISNULL (wait_duration_ms, 0)) AS avg_wait_duration_ms, MAX(wait_duration_ms) AS max_wait_duration_ms, 
        MAX ([Level]) AS max_blocking_chain_depth, 
        MAX (ISNULL (CONVERT (nvarchar(60), CASE 
          WHEN sql.objectid IS NULL THEN NULL 
          ELSE REPLACE(REPLACE (REPLACE (SUBSTRING (sql.[text], CHARINDEX ('CREATE ', CONVERT (nvarchar(512), SUBSTRING (sql.[text], 1, 1000)) COLLATE Latin1_General_BIN), 50) COLLATE Latin1_General_BIN, CHAR(10), ' '), CHAR(13), ' '), CHAR(09), ' ')
        END), '')) AS head_blocker_proc_name, 
        MAX (ISNULL (sql.objectid, 0)) AS head_blocker_proc_objid, MAX (ISNULL (CONVERT (nvarchar(1000), REPLACE( REPLACE (REPLACE (SUBSTRING (sql.[text], ISNULL (statement_start_offset, 0)/2 + 1, 
          CASE WHEN ISNULL (statement_end_offset, 8192) <= 0 THEN 8192 
          ELSE ISNULL (statement_end_offset, 8192)/2 - ISNULL (statement_start_offset, 0)/2 END + 1) COLLATE Latin1_General_BIN, 
        CHAR(13), ' '), CHAR(10), ' '), CHAR(09), ' ')), '')) AS stmt_text, 
        CONVERT (varbinary (64), MAX (ISNULL (plan_handle, 0x))) AS head_blocker_plan_handle
      FROM BlockingHierarchy
      OUTER APPLY sys.dm_exec_sql_text (ISNULL (sql_handle, most_recent_sql_handle)) AS sql
      WHERE blocking_session_id != 0 AND [Level] > 0
      GROUP BY head_blocker_session_id, 
        LEFT (CASE 
          WHEN wait_type LIKE 'LCK%' COLLATE Latin1_General_BIN AND wait_resource LIKE '%\[COMPILE\]%' ESCAPE '\' COLLATE Latin1_General_BIN 
            THEN 'COMPILE (' + ISNULL (wait_resource, '') + ')' 
          WHEN wait_type LIKE 'LCK%' COLLATE Latin1_General_BIN THEN 'LOCK BLOCKING' 
          WHEN wait_type LIKE 'PAGELATCH%' COLLATE Latin1_General_BIN THEN 'PAGELATCH_* WAITS' 
          WHEN wait_type LIKE 'PAGEIOLATCH%' COLLATE Latin1_General_BIN THEN 'PAGEIOLATCH_* WAITS' 
          ELSE wait_type
        END, 40) 
      ORDER BY SUM (wait_duration_ms) DESC;
      
      
      SET @rowcount = @@ROWCOUNT
      SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
      RAISERROR ('', 0, 1) WITH NOWAIT
      IF @queryduration > @qrydurationwarnthreshold
        PRINT 'DebugPrint: perfstats qry4 - ' + CONVERT (varchar, @queryduration) + 'ms, rowcount=' + CONVERT(varchar, @rowcount) + CHAR(13) + CHAR(10)
    END

    /* Resultset #3: inputbuffers and query stats for "expensive" queries, head blockers, and "first-tier" blocked spids */
    PRINT ''
    RAISERROR ('-- notableactivequeries --', 0, 1) WITH NOWAIT

    SET @querystarttime = GETDATE()
--    EXEC sp_executesql @sql, N'@runtime datetime, @appname sysname', @runtime = @runtime, @appname = @appname

    SELECT DISTINCT TOP 500 
      CONVERT (varchar(30), @runtime, 126) AS runtime, r.session_id AS session_id, r.request_id AS request_id, stat.execution_count AS plan_total_exec_count, 
      stat.total_worker_time/1000 AS plan_total_cpu_ms, stat.total_elapsed_time/1000 AS plan_total_duration_ms, stat.total_physical_reads AS plan_total_physical_reads, 
      stat.total_logical_writes AS plan_total_logical_writes, stat.total_logical_reads AS plan_total_logical_reads, 
      
      db_name() AS dbname, 
      sql.objectid AS objectid, 
      CONVERT (nvarchar(60), CASE 
        WHEN sql.objectid IS NULL THEN NULL 
        ELSE REPLACE( REPLACE (REPLACE (SUBSTRING (sql.[text] COLLATE Latin1_General_BIN, CHARINDEX ('CREATE ', SUBSTRING (sql.[text] COLLATE Latin1_General_BIN, 1, 1000)), 50), CHAR(10), ' '), CHAR(13), ' '), CHAR(09),' ')
      END) AS procname, 
      CONVERT (nvarchar(300), REPLACE( REPLACE (REPLACE (CONVERT (nvarchar(300), SUBSTRING (sql.[text], ISNULL (r.statement_start_offset, 0)/2 + 1, 
          CASE WHEN ISNULL (r.statement_end_offset, 8192) <= 0 THEN 8192 
          ELSE ISNULL (r.statement_end_offset, 8192)/2 - ISNULL (r.statement_start_offset, 0)/2 END + 1)) COLLATE Latin1_General_BIN, 
        CHAR(13), ' '), CHAR(10), ' '), CHAR(09), ' ')) AS stmt_text, 
      CONVERT (varbinary (64), (r.plan_handle)) AS plan_handle,
      group_id
    FROM @tmp_requests2 r
    LEFT OUTER JOIN sys.dm_exec_query_stats stat ON r.plan_handle = stat.plan_handle AND stat.statement_start_offset = r.statement_start_offset
    --OUTER APPLY sys.dm_exec_plan_attributes (r.plan_handle) pa
    OUTER APPLY sys.dm_exec_sql_text (ISNULL (r.sql_handle, r.most_recent_sql_handle)) AS sql
    WHERE 
     ( 
        /* We do not want to pull inputbuffers for everyone. The conditions below determine which ones we will fetch. */
        (r.session_id IN (SELECT blocking_session_id FROM @tmp_requests2 WHERE blocking_session_id != 0)) -- head blockers
        OR (r.blocking_session_id IN (SELECT blocking_session_id FROM @tmp_requests2 WHERE blocking_session_id != 0)) -- "first-tier" blocked requests
        OR (LTRIM (r.wait_type) <> '''' OR r.wait_duration_ms > 500) -- waiting for some resource
        OR (r.open_trans > 5) -- possible orphaned transaction
        OR (r.request_total_elapsed_time > 25000) -- long-running query
        OR (r.request_logical_reads > 1000000 OR r.request_cpu_time > 3000) -- expensive (CPU) query
        OR (r.request_reads + r.request_writes > 5000 OR r.pending_io_count > 400) -- expensive (I/O) query
        OR (r.memory_usage > 25600) -- expensive (memory > 200MB) query
        -- OR (r.is_sick > 0) -- spinloop
      )
    ORDER BY stat.total_worker_time/1000 DESC

    SET @rowcount = @@ROWCOUNT
    RAISERROR ('', 0, 1) WITH NOWAIT
    SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
    IF @rowcount >= 500 PRINT 'WARNING: notableactivequeries output artificially limited to 500 rows'
    IF @queryduration > @qrydurationwarnthreshold
      PRINT 'DebugPrint: perfstats qry5 - ' + CONVERT (varchar, @queryduration) + 'ms, rowcount=' + CONVERT(varchar, @rowcount) + CHAR(13) + CHAR(10)

    IF '%runmode%' = 'REALTIME' BEGIN 
      -- In near-realtime/direct-to-database mode, we have to maintain tbl_BLOCKING_CHAINS on-the-fly
      -- 1) Insert new blocking chains
      INSERT INTO tbl_BLOCKING_CHAINS (first_rownum, last_rownum, num_snapshots, blocking_start, blocking_end, head_blocker_session_id, 
        blocking_wait_type, max_blocked_task_count, max_total_wait_duration_ms, avg_wait_duration_ms, max_wait_duration_ms, 
        max_blocking_chain_depth, head_blocker_session_id_orig)
      SELECT rownum, NULL, 1, runtime, NULL, 
        CASE WHEN blocking_resource_wait_type LIKE 'COMPILE%' THEN 'COMPILE BLOCKING' ELSE head_blocker_session_id END AS head_blocker_session_id, 
        blocking_resource_wait_type, blocked_task_count, tot_wait_duration_ms, avg_wait_duration_ms, max_wait_duration_ms, 
        max_blocking_chain_depth, head_blocker_session_id
      FROM tbl_HEADBLOCKERSUMMARY b1 
      WHERE b1.runtime = @runtime AND NOT EXISTS (
        SELECT * FROM tbl_BLOCKING_CHAINS b2  
        WHERE b2.blocking_end IS NULL  -- end-of-blocking has not been detected yet
          AND b2.head_blocker_session_id = CASE WHEN blocking_resource_wait_type LIKE 'COMPILE%' THEN 'COMPILE BLOCKING' ELSE head_blocker_session_id END -- same head blocker
          AND b2.blocking_wait_type = b1.blocking_resource_wait_type -- same type of blocking
      )
      PRINT 'Inserted ' + CONVERT (varchar, @@ROWCOUNT) + ' new blocking chains...'

      -- 2) Update statistics for in-progress blocking incidents
      UPDATE tbl_BLOCKING_CHAINS 
      SET last_rownum = b2.rownum, num_snapshots = b1.num_snapshots + 1, 
        max_blocked_task_count = CASE WHEN b1.max_blocked_task_count > b2.blocked_task_count THEN b1.max_blocked_task_count ELSE b2.blocked_task_count END, 
        max_total_wait_duration_ms = CASE WHEN b1.max_total_wait_duration_ms > b2.tot_wait_duration_ms THEN b1.max_total_wait_duration_ms ELSE b2.tot_wait_duration_ms END, 
        avg_wait_duration_ms = (b1.num_snapshots-1) * b1.avg_wait_duration_ms + b2.avg_wait_duration_ms / b1.num_snapshots, 
        max_wait_duration_ms = CASE WHEN b1.max_wait_duration_ms > b2.max_wait_duration_ms THEN b1.max_wait_duration_ms ELSE b2.max_wait_duration_ms END, 
        max_blocking_chain_depth = CASE WHEN b1.max_blocking_chain_depth > b2.max_blocking_chain_depth THEN b1.max_blocking_chain_depth ELSE b2.max_blocking_chain_depth END
      FROM tbl_BLOCKING_CHAINS b1 
      INNER JOIN tbl_HEADBLOCKERSUMMARY b2 ON b1.blocking_end IS NULL -- end-of-blocking has not been detected yet
          AND b2.head_blocker_session_id = b1.head_blocker_session_id -- same head blocker
          AND b1.blocking_wait_type = b2.blocking_resource_wait_type -- same type of blocking
          AND b2.runtime = @runtime
      PRINT 'Updated ' + CONVERT (varchar, @@ROWCOUNT) + ' in-progress blocking chains...'

      -- 3) "Close out" blocking chains that were just resolved
      UPDATE tbl_BLOCKING_CHAINS 
      SET blocking_end = @runtime
      FROM tbl_BLOCKING_CHAINS b1
      WHERE blocking_end IS NULL AND NOT EXISTS (
        SELECT * FROM tbl_HEADBLOCKERSUMMARY b2 WHERE b2.runtime = @runtime 
          AND b2.head_blocker_session_id = b1.head_blocker_session_id -- same head blocker
          AND b1.blocking_wait_type = b2.blocking_resource_wait_type -- same type of blocking
      )
      PRINT + CONVERT (varchar, @@ROWCOUNT) + ' blocking chains have ended.'
    END

    RAISERROR ('', 0, 1) WITH NOWAIT
  END

  -- Raise a diagnostic message if we use much more CPU than normal (a typical execution uses <300ms)
  DECLARE @cpu_time bigint, @elapsed_time bigint
  SELECT @cpu_time = cpu_time - @cpu_time_start, @elapsed_time = total_elapsed_time - @elapsed_time_start FROM sys.dm_exec_requests WHERE session_id = @@SPID
  IF (@elapsed_time > 2000 OR @cpu_time > 750)
    PRINT 'DebugPrint: perfstats tot - ' + CONVERT (varchar, @elapsed_time) + 'ms elapsed, ' + CONVERT (varchar, @cpu_time) + 'ms cpu' + CHAR(13) + CHAR(10)  

  SET NOCOUNT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[sp_perf_stats_azure_infrequent11]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_perf_stats_azure_infrequent11] @runtime datetime, @firstrun int = 0 AS 
BEGIN
  SET NOCOUNT ON
  DECLARE @queryduration int
  DECLARE @querystarttime datetime
  DECLARE @qrydurationwarnthreshold int
  DECLARE @cpu_time_start bigint, @elapsed_time_start bigint
  DECLARE @servermajorversion int
  DECLARE @msg varchar(100)
  DECLARE @sql nvarchar(max)

  IF @runtime IS NULL 
  BEGIN 
    SET @runtime = GETDATE()
    SET @msg = 'Start time: ' + CONVERT (varchar(30), @runtime, 126)
    RAISERROR (@msg, 0, 1) WITH NOWAIT
  END
  SET @qrydurationwarnthreshold = 750

  SELECT @cpu_time_start = cpu_time, @elapsed_time_start = total_elapsed_time FROM sys.dm_exec_requests WHERE session_id = @@SPID

  /* SERVERPROPERTY ('ProductVersion') returns e.g. "9.00.2198.00" --> 9 */
  SET @servermajorversion = REPLACE (LEFT (CONVERT (varchar, SERVERPROPERTY ('ProductVersion')), 2), '.', '')

  /* Resultset #1: Server global wait stats */
  PRINT ''
  RAISERROR ('-- dm_db_wait_stats --', 0, 1) WITH NOWAIT;
  SET @querystarttime = GETDATE()
--  EXEC sp_executesql @sql, N'@runtime datetime', @runtime = @runtime

  SELECT CONVERT (varchar(30), @runtime, 126) AS runtime, LEFT (wait_type, 45) AS wait_type, waiting_tasks_count, wait_time_ms, max_wait_time_ms, signal_wait_time_ms
  FROM sys.dm_db_wait_stats
  WHERE waiting_tasks_count > 0 OR wait_time_ms > 0 OR signal_wait_time_ms > 0
  ORDER BY wait_time_ms DESC

  SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
  RAISERROR ('', 0, 1) WITH NOWAIT
  IF @queryduration > @qrydurationwarnthreshold
    PRINT 'DebugPrint: perfstats2 qry1 - ' + CONVERT (varchar, @queryduration) + 'ms' + CHAR(13) + CHAR(10)

  SET NOCOUNT OFF
END


SET NOCOUNT ON
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[sp_renamediagram]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_renamediagram]
	(
		@diagramname 		sysname,
		@owner_id		int	= null,
		@new_diagramname	sysname
	
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @DiagIdTarg		int
		declare @u_name			sysname
		if((@diagramname is null) or (@new_diagramname is null))
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT;
	
		select @u_name = USER_NAME(@owner_id)
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		-- if((@u_name is not null) and (@new_diagramname = @diagramname))	-- nothing will change
		--	return 0;
	
		if(@u_name is null)
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @new_diagramname
		else
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @owner_id and name = @new_diagramname
	
		if((@DiagIdTarg is not null) and  @DiagId <> @DiagIdTarg)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end		
	
		if(@u_name is null)
			update dbo.sysdiagrams set [name] = @new_diagramname, principal_id = @theId where diagram_id = @DiagId
		else
			update dbo.sysdiagrams set [name] = @new_diagramname where diagram_id = @DiagId
		return 0
	END
	
GO
/****** Object:  StoredProcedure [dbo].[sp_upgraddiagrams]    Script Date: 5/12/2020 8:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_upgraddiagrams]
	AS
	BEGIN
		IF OBJECT_ID(N'dbo.sysdiagrams') IS NOT NULL
			return 0;
	
		CREATE TABLE dbo.sysdiagrams
		(
			name sysname NOT NULL,
			principal_id int NOT NULL,	-- we may change it to varbinary(85)
			diagram_id int PRIMARY KEY IDENTITY,
			version int,
	
			definition varbinary(max)
			CONSTRAINT UK_principal_name UNIQUE
			(
				principal_id,
				name
			)
		);


		/* Add this if we need to have some form of extended properties for diagrams */
		/*
		IF OBJECT_ID(N'dbo.sysdiagram_properties') IS NULL
		BEGIN
			CREATE TABLE dbo.sysdiagram_properties
			(
				diagram_id int,
				name sysname,
				value varbinary(max) NOT NULL
			)
		END
		*/

		IF OBJECT_ID(N'dbo.dtproperties') IS NOT NULL
		begin
			insert into dbo.sysdiagrams
			(
				[name],
				[principal_id],
				[version],
				[definition]
			)
			select	 
				convert(sysname, dgnm.[uvalue]),
				DATABASE_PRINCIPAL_ID(N'dbo'),			-- will change to the sid of sa
				0,							-- zero for old format, dgdef.[version],
				dgdef.[lvalue]
			from dbo.[dtproperties] dgnm
				inner join dbo.[dtproperties] dggd on dggd.[property] = 'DtgSchemaGUID' and dggd.[objectid] = dgnm.[objectid]	
				inner join dbo.[dtproperties] dgdef on dgdef.[property] = 'DtgSchemaDATA' and dgdef.[objectid] = dgnm.[objectid]
				
			where dgnm.[property] = 'DtgSchemaNAME' and dggd.[uvalue] like N'_EA3E6268-D998-11CE-9454-00AA00A3F36E_' 
			return 2;
		end
		return 1;
	END
	
GO
