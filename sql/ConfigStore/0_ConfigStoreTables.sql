/****** Object:  Table [dbo].[AuditPolicy]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditPolicy](
	[Id] [uniqueidentifier] NOT NULL,
	[PolicyName] [nvarchar](64) NOT NULL,
	[AuditPolicyData] [nvarchar](2048) NOT NULL,
	[Type] [int] NULL,
	[Priority] [int] NULL,
	[AADLicense] [nvarchar](2048) NOT NULL,
	[CreationTime] [datetime] NOT NULL,
	[UpdateTime] [datetime] NOT NULL,
 CONSTRAINT [PolicyId_PK] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuditService]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditService](
	[AuditServiceId] [int] NOT NULL,
	[AuditServiceName] [nvarchar](256) NOT NULL,
 CONSTRAINT [AuditService_PK] PRIMARY KEY CLUSTERED 
(
	[AuditServiceId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cache]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cache](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[DataGroup] [uniqueidentifier] NOT NULL,
	[Status] [int] NOT NULL,
	[Geo] [nvarchar](32) NOT NULL,
	[HostName] [nvarchar](256) NOT NULL,
	[AccessKey] [nvarchar](512) NOT NULL,
	[Ssl] [bit] NOT NULL,
 CONSTRAINT [Cache_PK] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Certificate]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Certificate](
	[Id] [uniqueidentifier] NOT NULL,
	[Subject] [nvarchar](256) NOT NULL,
	[Thumbprint] [nvarchar](40) NOT NULL,
	[ExpireTime] [datetime] NOT NULL,
	[Content] [varbinary](8000) NULL,
	[Password] [nvarchar](512) NULL,
 CONSTRAINT [Certificate_PK] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConfigValues]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConfigValues](
	[Id] [uniqueidentifier] NOT NULL,
	[Namespace] [nvarchar](32) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
 CONSTRAINT [ConfigValues_PK] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DataGroup]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DataGroup](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Status] [int] NOT NULL,
	[Geo] [nvarchar](64) NOT NULL,
	[Type] [int] NULL,
	[State] [int] NULL,
	[CreationTime] [datetime] NULL,
	[UpdateTime] [datetime] NULL,
	[AlertEnabled] [bit] NULL,
 CONSTRAINT [DataGroup_PK] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DedicatedEventHubMapping]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DedicatedEventHubMapping](
	[TenantId] [uniqueidentifier] NOT NULL,
	[EeventHubId] [uniqueidentifier] NOT NULL,
	[StartPartition] [int] NOT NULL,
	[PartitionCount] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DispatcherEndpoint]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DispatcherEndpoint](
	[Id] [uniqueidentifier] NOT NULL,
	[Endpoint] [nvarchar](256) NOT NULL,
	[DataGroup] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventHub]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventHub](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
	[DataGroup] [uniqueidentifier] NOT NULL,
	[Status] [int] NOT NULL,
	[PairEventHub] [uniqueidentifier] NULL,
	[Geo] [nvarchar](32) NOT NULL,
	[Namespace] [nvarchar](256) NOT NULL,
	[ManagementSharedAccessKeyName] [nvarchar](64) NOT NULL,
	[ManagementSharedAccessKey] [nvarchar](512) NOT NULL,
	[EntityPath] [nvarchar](64) NOT NULL,
	[IsDedicated] [int] NOT NULL,
 CONSTRAINT [EventHub_PK] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IngestDataSource]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IngestDataSource](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](32) NOT NULL,
	[DataGroup] [uniqueidentifier] NOT NULL,
	[Geo] [nvarchar](32) NOT NULL,
	[Status] [int] NOT NULL,
	[Type] [int] NOT NULL,
	[CertificateThumbprint] [nvarchar](40) NOT NULL,
	[CertificateStoreName] [nvarchar](30) NOT NULL,
	[CertificateStoreLocation] [nvarchar](20) NOT NULL,
	[QueryUrl] [nvarchar](200) NOT NULL,
	[QueryTables] [nvarchar](1024) NOT NULL,
	[QueryFilters] [nvarchar](max) NULL,
	[MaxQueryRetries] [int] NOT NULL,
	[MaxQueryWaitTimeInSec] [int] NOT NULL,
	[SleepBetweenRetriesInSec] [int] NOT NULL,
	[WaterMarkContainer] [nvarchar](200) NOT NULL,
	[QueryType] [int] NOT NULL,
	[CreationTime] [datetime] NULL,
	[UpdateTime] [datetime] NULL,
 CONSTRAINT [IngestDataSource_PK] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Lock]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lock](
	[Name] [nvarchar](256) NOT NULL,
	[Owner] [nvarchar](64) NOT NULL,
	[LockTime] [datetime] NOT NULL,
	[Expiry] [datetime] NOT NULL,
	[Status]  AS (case when getutcdate()>[Expiry] then N'Available' else N'Granted' end),
 CONSTRAINT [Lock_PK] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MetadataStorage]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MetadataStorage](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
	[DataGroup] [uniqueidentifier] NOT NULL,
	[Status] [int] NOT NULL,
	[Geo] [nvarchar](32) NOT NULL,
	[AccountName] [nvarchar](64) NOT NULL,
	[AccessKey] [nvarchar](512) NOT NULL,
	[ServiceUriSuffix] [nvarchar](128) NULL,
	[SiblingOf] [uniqueidentifier] NULL,
 CONSTRAINT [MetadataStorage_PK] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PolicyStorageAccount]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PolicyStorageAccount](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
	[DataGroup] [uniqueidentifier] NOT NULL,
	[Status] [int] NOT NULL,
	[Geo] [nvarchar](32) NOT NULL,
	[AccountName] [nvarchar](64) NOT NULL,
	[AccessKey] [nvarchar](512) NOT NULL,
	[ServiceUriSuffix] [nvarchar](128) NULL,
 CONSTRAINT [PolicyStorageAccount_PK] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Service]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Service](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[TypeName] [nvarchar](256) NOT NULL,
	[State] [int] NOT NULL,
	[CreationTime] [datetime] NOT NULL,
	[UpdateTime] [datetime] NOT NULL,
 CONSTRAINT [Service_PK] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [Service_Name_UQ] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [Service_TypeName_UQ] UNIQUE NONCLUSTERED 
(
	[TypeName] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ServiceBus]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServiceBus](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
	[DataGroup] [uniqueidentifier] NOT NULL,
	[Status] [int] NOT NULL,
	[PairServiceBus] [uniqueidentifier] NULL,
	[Geo] [nvarchar](32) NOT NULL,
	[Namespace] [nvarchar](256) NOT NULL,
	[ManagementSharedAccessKeyName] [nvarchar](64) NOT NULL,
	[ManagementSharedAccessKey] [nvarchar](512) NOT NULL,
 CONSTRAINT [ServiceBus_PK] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ServiceCert]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServiceCert](
	[ServiceInstance] [uniqueidentifier] NOT NULL,
	[Certificate] [uniqueidentifier] NOT NULL,
 CONSTRAINT [ServiceCert_PK] PRIMARY KEY CLUSTERED 
(
	[ServiceInstance] ASC,
	[Certificate] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ServiceEndpoint]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServiceEndpoint](
	[Id] [uniqueidentifier] NOT NULL,
	[EndpointUri] [nvarchar](256) NOT NULL,
	[DataGroup] [uniqueidentifier] NOT NULL,
	[AuditServiceId] [int] NOT NULL,
 CONSTRAINT [ServiceEndpoint_PK] PRIMARY KEY CLUSTERED 
(
	[DataGroup] ASC,
	[AuditServiceId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ServiceInstance]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServiceInstance](
	[Id] [uniqueidentifier] NOT NULL,
	[Service] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[State] [int] NOT NULL,
	[CreationTime] [datetime] NOT NULL,
	[UpdateTime] [datetime] NOT NULL,
 CONSTRAINT [ServiceInstance_PK] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [ServiceInstance_ServiceName_UQ] UNIQUE NONCLUSTERED 
(
	[Service] ASC,
	[Name] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Storage]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Storage](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
	[DataGroup] [uniqueidentifier] NOT NULL,
	[Status] [int] NOT NULL,
	[Geo] [nvarchar](32) NOT NULL,
	[AccountName] [nvarchar](64) NOT NULL,
	[AccessKey] [nvarchar](512) NOT NULL,
	[ServiceUriSuffix] [nvarchar](128) NULL,
	[SiblingOf] [uniqueidentifier] NULL,
 CONSTRAINT [Storage_PK] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Subscription]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Subscription](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](32) NOT NULL,
	[Status] [int] NOT NULL,
	[Tenant] [uniqueidentifier] NOT NULL,
	[MajorCategory] [nvarchar](64) NOT NULL,
	[MinorCategory] [nvarchar](64) NOT NULL,
	[CreationTime] [datetime] NULL,
	[UpdateTime] [datetime] NULL,
 CONSTRAINT [Subscription_PK] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sysdiagrams]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sysdiagrams](
	[name] [sysname] NOT NULL,
	[principal_id] [int] NOT NULL,
	[diagram_id] [int] IDENTITY(1,1) NOT NULL,
	[version] [int] NULL,
	[definition] [varbinary](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[diagram_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK_principal_name] UNIQUE NONCLUSTERED 
(
	[principal_id] ASC,
	[name] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tenant]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tenant](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[AuditingEnabled] [bit] NOT NULL,
	[DataGroup] [uniqueidentifier] NOT NULL,
	[State] [int] NULL,
	[CreationTime] [datetime] NULL,
	[UpdateTime] [datetime] NULL,
	[Type] [int] NULL,
	[ReceiverPolicy] [nvarchar](64) NULL,
	[ReceiverAccessKey] [nvarchar](512) NULL,
	[SecondaryReceiverPolicy] [nvarchar](64) NULL,
	[SecondaryReceiverAccessKey] [nvarchar](512) NULL,
	[TopicName] [nvarchar](100) NULL,
	[LoadBalanceCount] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TenantCert]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TenantCert](
	[Tenant] [uniqueidentifier] NOT NULL,
	[Certificate] [uniqueidentifier] NOT NULL,
	[Role] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TenantInfo]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TenantInfo](
	[TenantId] [uniqueidentifier] NOT NULL,
	[HasOfficeE3] [bit] NULL,
	[HasOfficeE5] [bit] NULL,
	[TotalAvailableUnits] [bigint] NULL,
	[TrailAvailableUnits] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[LastUpdateDate] [datetime] NULL,
	[TenantSubscriptionFlags] [bigint] NULL,
 CONSTRAINT [TenantInfo_PK_TenantId] PRIMARY KEY CLUSTERED 
(
	[TenantId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TenantMigration]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TenantMigration](
	[TenantId] [uniqueidentifier] NOT NULL,
	[DataGroup] [uniqueidentifier] NOT NULL,
	[MigrationTime] [datetime] NOT NULL,
	[ReadStatus] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TenantUserPolicyBinaryData]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TenantUserPolicyBinaryData](
	[TenantId] [uniqueidentifier] NOT NULL,
	[BinaryData] [varbinary](max) NOT NULL,
	[UpdateTime] [datetime] NOT NULL,
	[CreationTime] [datetime] NOT NULL,
 CONSTRAINT [TenantId_PK] PRIMARY KEY CLUSTERED 
(
	[TenantId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UnscrubberKey]    Script Date: 5/12/2020 8:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UnscrubberKey](
	[CertificateId] [int] NOT NULL,
	[CertificateThumbprint] [nvarchar](80) NOT NULL,
	[EncryptedAESKey] [nvarchar](2048) NOT NULL,
 CONSTRAINT [ScrubKeys_PK_Latest] PRIMARY KEY CLUSTERED 
(
	[CertificateId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Version]    Script Date: 5/12/2020 8:03:58 PM ******/
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
ALTER TABLE [dbo].[DataGroup] ADD  DEFAULT (NULL) FOR [Type]
GO
ALTER TABLE [dbo].[IngestDataSource] ADD  DEFAULT ((1)) FOR [QueryType]
GO
ALTER TABLE [dbo].[IngestDataSource] ADD  DEFAULT (NULL) FOR [CreationTime]
GO
ALTER TABLE [dbo].[IngestDataSource] ADD  DEFAULT (NULL) FOR [UpdateTime]
GO
ALTER TABLE [dbo].[MetadataStorage] ADD  DEFAULT (NULL) FOR [ServiceUriSuffix]
GO
ALTER TABLE [dbo].[MetadataStorage] ADD  DEFAULT (NULL) FOR [SiblingOf]
GO
ALTER TABLE [dbo].[PolicyStorageAccount] ADD  DEFAULT (NULL) FOR [ServiceUriSuffix]
GO
ALTER TABLE [dbo].[Storage] ADD  DEFAULT (NULL) FOR [ServiceUriSuffix]
GO
ALTER TABLE [dbo].[Storage] ADD  DEFAULT (NULL) FOR [SiblingOf]
GO
ALTER TABLE [dbo].[Subscription] ADD  DEFAULT (NULL) FOR [CreationTime]
GO
ALTER TABLE [dbo].[Subscription] ADD  DEFAULT (NULL) FOR [UpdateTime]
GO
ALTER TABLE [dbo].[TenantInfo] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ServiceEndpoint]  WITH CHECK ADD  CONSTRAINT [ServiceEndPoint_AuditService_FK] FOREIGN KEY([AuditServiceId])
REFERENCES [dbo].[AuditService] ([AuditServiceId])
GO
ALTER TABLE [dbo].[ServiceEndpoint] CHECK CONSTRAINT [ServiceEndPoint_AuditService_FK]
GO
ALTER TABLE [dbo].[TenantMigration]  WITH CHECK ADD FOREIGN KEY([DataGroup])
REFERENCES [dbo].[DataGroup] ([Id])
GO
ALTER TABLE [dbo].[TenantMigration]  WITH CHECK ADD FOREIGN KEY([TenantId])
REFERENCES [dbo].[Tenant] ([Id])
GO
