CREATE NONCLUSTERED INDEX [Secret_ScopeType_Scope_Type] ON [dbo].[Secret]
(
  [ScopeType] ASC,
  [Scope] ASC,
  [Type] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO

/****** Object:  Index [Secret_State_RetireTime]    Script Date: 10/3/2020 12:30:09 PM ******/
CREATE NONCLUSTERED INDEX [Secret_State_RetireTime] ON [dbo].[Secret]
(
  [State] ASC,
  [RetireTime] ASC,
  [RetireWindow] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO


/****** Object:  Index [nci_wi_Secret_9F1886C792A4050CC8E3604C83291CD8]    Script Date: 10/3/2020 12:30:29 PM ******/
CREATE NONCLUSTERED INDEX [nci_wi_Secret_9F1886C792A4050CC8E3604C83291CD8] ON [dbo].[Secret]
(
  [Scope] ASC,
  [ScopeType] ASC,
  [Type] ASC
)
INCLUDE([CreationTime], [Key], [Name], [RetireTime], [RetiringTime], [State], [UpdateTime]) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO