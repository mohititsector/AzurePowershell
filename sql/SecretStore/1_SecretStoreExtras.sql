/****** Object:  UserDefinedFunction [dbo].[fn_IsGuidNotEmpty]    Script Date: 5/13/2020 2:02:54 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[fn_IsStringNotEmpty]    Script Date: 5/13/2020 2:02:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fn_IsStringNotEmpty]
(
    @string nvarchar(max)
)
RETURNS bit AS
BEGIN
    RETURN
        CASE
            WHEN @string IS NULL OR LEN(LTRIM(RTRIM(@string))) = 0
            THEN 0
            ELSE 1
        END
END
GO
/****** Object:  StoredProcedure [dbo].[proc_DeleteSecret]    Script Date: 5/13/2020 2:02:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[proc_DeleteSecret]
(
    @Id uniqueIdentifier
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@Id) = 0
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_DeleteSecret')
        RETURN -1
    END

    DELETE FROM
        Secret
    WHERE
        Id = @Id
    
GO
/****** Object:  StoredProcedure [dbo].[proc_GetSecret]    Script Date: 5/13/2020 2:02:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[proc_GetSecret]
(
    @Id uniqueidentifier = NULL,
    @ScopeType int = NULL,
    @Scope nvarchar(256) = NULL,
    @Type int = NULL
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@Id) = 0 AND
        @ScopeType IS NULL AND
        dbo.fn_IsStringNotEmpty(@Scope) = 0 AND
        @Type IS NULL
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_GetSecret')
        RETURN -1
    END

    IF dbo.fn_IsGuidNotEmpty(@Id) = 1
    SELECT
        SR.Id AS Id,
        SR.Name AS Name,
        SR.[Key] AS [Key],
        SR.Type AS Type,
        SR.State AS State,
        SR.ScopeType AS ScopeType,
        SR.Scope AS Scope,
        SR.CreationTime AS CreationTime,
        SR.UpdateTime AS UpdateTime,
        SR.RetiringTime AS RetiringTime,
        SR.RetireTime AS RetireTime
    FROM dbo.Secret SR WITH(INDEX=[Secret_PK])
    WHERE SR.Id = @Id
    ELSE
    SELECT
        SR.Id AS Id,
        SR.Name AS Name,
        SR.[Key] AS [Key],
        SR.Type AS Type,
        SR.State AS State,
        SR.ScopeType AS ScopeType,
        SR.Scope AS Scope,
        SR.CreationTime AS CreationTime,
        SR.UpdateTime AS UpdateTime,
        SR.RetiringTime AS RetiringTime,
        SR.RetireTime AS RetireTime
    FROM dbo.Secret SR WITH(INDEX=[Secret_ScopeType_Scope_Type])
    WHERE SR.ScopeType = @ScopeType AND
        Scope = @Scope AND
        Type = @Type
GO
/****** Object:  StoredProcedure [dbo].[proc_GetVersion]    Script Date: 5/13/2020 2:02:54 PM ******/
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
/****** Object:  StoredProcedure [dbo].[proc_SetVersion]    Script Date: 5/13/2020 2:02:54 PM ******/
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
/****** Object:  StoredProcedure [dbo].[proc_UpdateSecret]    Script Date: 5/13/2020 2:02:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[proc_UpdateSecret]
(
    @Id uniqueIdentifier,
    @Name nvarchar(256) = NULL,
    @Key varbinary(max) = NULL,
    @Type int = NULL,
    @State int = NULL,
    @ScopeType int = NULL,
    @Scope nvarchar(256) = NULL,
    @RetireTime datetime = NULL,
    @RetireWindow bigint = NULL
)
AS
    SET NOCOUNT ON

    IF dbo.fn_IsGuidNotEmpty(@Id) = 0
    BEGIN
        RAISERROR (15600, -1, -1, 'proc_UpdateSecret')
        RETURN -1
    END

    DECLARE @utcNow datetime = GETUTCDATE()
    DECLARE @Succeeded bit = CONVERT(bit, 0)

    IF @RetireWindow IS NULL
    SET @RetireWindow = 604800 /* 7 days in seconds */

    IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.Secret WHERE Id = @Id)
    BEGIN
        IF dbo.fn_IsStringNotEmpty(@Name) = 0 OR
           @Key IS NULL OR
           @Type IS NULL OR
           @State IS NULL OR
           @ScopeType IS NULL OR
           @Scope IS NULL OR
           @RetireTime IS NULL OR
           @RetireWindow <= 0
        BEGIN
            RAISERROR (15600, -1, -1, 'proc_UpdateSecret')
            RETURN -1
        END

        BEGIN TRAN

        INSERT
        INTO dbo.Secret
        (
            [Id],
            [Name],
            [Key],
            [Type],
            [State],
            [ScopeType],
            [Scope],
            [CreationTime],
            [UpdateTime],
            [RetireTime],
            [RetireWindow]
        )
        VALUES
        (
            @Id,
            @Name,
            @Key,
            @Type,
            @State,
            @ScopeType,
            @Scope,
            @utcNow,
            @utcNow,
            @RetireTime,
            @RetireWindow
        )

        IF @@ROWCOUNT <> 1
        GOTO CLEANUP

        SELECT @Succeeded = CONVERT(bit, 1)
    END
    ELSE
    BEGIN
        BEGIN TRAN

        IF dbo.fn_IsStringNotEmpty(@Name) = 1
                BEGIN
                        UPDATE dbo.Secret
                        SET Name = @Name
                        WHERE Id = @Id

                        IF @@ROWCOUNT <> 1
                        GOTO CLEANUP
                END

        IF @Key IS NOT NULL
                BEGIN
                        UPDATE dbo.Secret
                        SET [Key] = @Key
                        WHERE Id = @Id

                        IF @@ROWCOUNT <> 1
                        GOTO CLEANUP
                END

        IF @State IS NOT NULL
                BEGIN
                        UPDATE dbo.Secret
                        SET State = @State
                        WHERE Id = @Id

                        IF @@ROWCOUNT <> 1
                        GOTO CLEANUP
                END

        IF @RetireTime IS NOT NULL
                BEGIN
                        UPDATE dbo.Secret
                        SET RetireTime = @RetireTime
                        WHERE Id = @Id

                        IF @@ROWCOUNT <> 1
                        GOTO CLEANUP
                END

        IF @RetireWindow IS NOT NULL
                BEGIN
                        UPDATE dbo.Secret
                        SET RetireWindow = @RetireWindow
                        WHERE Id = @Id

                        IF @@ROWCOUNT <> 1
                        GOTO CLEANUP
                END

        UPDATE dbo.Secret
        SET UpdateTime = GETUTCDATE()
        WHERE Id = @Id

        IF @@ROWCOUNT <> 1
        GOTO CLEANUP

        SELECT @Succeeded = CONVERT(bit, 1)
    END
CLEANUP:
    IF @Succeeded = CONVERT(bit, 1)
    BEGIN
        COMMIT TRAN
        EXEC dbo.proc_GetSecret @Id = @Id
    END
    ELSE
    BEGIN
        ROLLBACK TRAN
        RAISERROR(
            58126,
            11,
            1,
            N'Failed to update secret. Please try again later.') WITH NOWAIT
        RETURN -1
    END
GO
