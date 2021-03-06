/****** Object:  Table [dbo].[Query]    Script Date: 5/13/2020 2:01:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Query](
	[id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
	[key] [image] NOT NULL,
	[Type] [int] NOT NULL,
	[State] [int] NOT NULL,
	[ScopeType] [int] NOT NULL,
	[Scope] [nvarchar](256) NOT NULL,
	[CreationTime] [datetime2](3) NOT NULL,
	[UpdateTime] [datetime2](3) NOT NULL,
	[RetireTime] [datetime2](3) NOT NULL,
	[RetireWindow] [bigint] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Secret]    Script Date: 5/13/2020 2:01:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Secret](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
	[Key] [varbinary](max) NOT NULL,
	[Type] [int] NOT NULL,
	[State] [int] NOT NULL,
	[ScopeType] [int] NOT NULL,
	[Scope] [nvarchar](256) NOT NULL,
	[CreationTime] [datetime] NOT NULL,
	[UpdateTime] [datetime] NOT NULL,
	[RetireTime] [datetime] NOT NULL,
	[RetireWindow] [bigint] NOT NULL,
	[RetiringTime]  AS (dateadd(second, -[RetireWindow],[RetireTime])) PERSISTED,
 CONSTRAINT [Secret_PK] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Version]    Script Date: 5/13/2020 2:01:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Version](
	[VersionId] [uniqueidentifier] NOT NULL,
	[Version] [nvarchar](32) NOT NULL,
	[Timestamp] [datetime] NOT NULL,
 CONSTRAINT [Version_PK] PRIMARY KEY CLUSTERED 
(
	[VersionId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
