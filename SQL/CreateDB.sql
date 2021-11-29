CREATE DATABASE [GoFlex]
GO

USE [GoFlex]
GO

/****** Object:  Table [dbo].[City] */
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[City](
	[CityId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](64) NOT NULL,
 CONSTRAINT [City_pk] PRIMARY KEY NONCLUSTERED 
(
	[CityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Location] */
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Location](
	[LocationId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
	[Address] [nvarchar](512) NOT NULL,
	[PhoneNumber] [varchar](15) NOT NULL,
	[Photo] [varchar](max) NULL,
	[CityId] [int] NOT NULL,
 CONSTRAINT [Location_pk] PRIMARY KEY NONCLUSTERED 
(
	[LocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Location]  WITH CHECK ADD  CONSTRAINT [Location_City_CityId_fk] FOREIGN KEY([CityId])
REFERENCES [dbo].[City] ([CityId])
GO

ALTER TABLE [dbo].[Location] CHECK CONSTRAINT [Location_City_CityId_fk]
GO


/****** Object:  Table [dbo].[Role] */
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Role](
	[RoleId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](64) NOT NULL,
 CONSTRAINT [Role_pk] PRIMARY KEY NONCLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


/****** Object:  Table [dbo].[User] */
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[User](
	[UserId] [uniqueidentifier] NOT NULL,
	[PasswordHash] [nvarchar](128) NOT NULL,
	[PasswordSalt] [nvarchar](128) NOT NULL,
	[RoleId] [int] NULL,
	[Email] [varchar](64) NOT NULL,
 CONSTRAINT [User_pk] PRIMARY KEY NONCLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [User_Role_fk] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([RoleId])
ON UPDATE CASCADE
ON DELETE SET NULL
GO

ALTER TABLE [dbo].[User] CHECK CONSTRAINT [User_Role_fk]
GO


/****** Object:  Table [dbo].[EventCategory] */
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EventCategory](
	[EventCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](64) NOT NULL,
 CONSTRAINT [EventCategory_pk] PRIMARY KEY NONCLUSTERED 
(
	[EventCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



/****** Object:  Table [dbo].[Event] */
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Event](
	[EventId] [int] IDENTITY(1,1) NOT NULL,
	[EventCategoryId] [int] NOT NULL,
	[LocationId] [int] NULL,
	[OrganizerId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[DateTime] [datetime2](7) NOT NULL,
	[Photo] [varchar](max) NULL,
	[CreateTime] [datetime2](7) NOT NULL,
	[IsApproved] [bit] NULL,
 CONSTRAINT [Event_pk] PRIMARY KEY NONCLUSTERED 
(
	[EventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Event] ADD  DEFAULT (NULL) FOR [IsApproved]
GO

ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [Event_EventCategory_EventCategoryId_fk] FOREIGN KEY([EventCategoryId])
REFERENCES [dbo].[EventCategory] ([EventCategoryId])
GO

ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [Event_EventCategory_EventCategoryId_fk]
GO

ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [Event_Location_LocationId_fk] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([LocationId])
GO

ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [Event_Location_LocationId_fk]
GO

ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [Event_User_UserId_fk] FOREIGN KEY([OrganizerId])
REFERENCES [dbo].[User] ([UserId])
GO

ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [Event_User_UserId_fk]
GO



/****** Object:  Table [dbo].[EventPrice] */
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EventPrice](
	[EventPriceId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Price] [money] NULL,
	[EventId] [int] NOT NULL,
	[Total] [int] NOT NULL,
	[IsRemoved] [bit] NOT NULL,
 CONSTRAINT [EventPrice_pk] PRIMARY KEY NONCLUSTERED 
(
	[EventPriceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[EventPrice] ADD  DEFAULT ((0)) FOR [IsRemoved]
GO

ALTER TABLE [dbo].[EventPrice]  WITH CHECK ADD  CONSTRAINT [EventPrice_Event_EventId_fk] FOREIGN KEY([EventId])
REFERENCES [dbo].[Event] ([EventId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[EventPrice] CHECK CONSTRAINT [EventPrice_Event_EventId_fk]
GO



/****** Object:  Table [dbo].[Order]  */
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Order](
	[OrderId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[EventId] [int] NOT NULL,
	[Timestamp] [datetime] NOT NULL,
 CONSTRAINT [Order_pk] PRIMARY KEY NONCLUSTERED 
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [Order_Event_EventId_fk] FOREIGN KEY([EventId])
REFERENCES [dbo].[Event] ([EventId])
GO

ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [Order_Event_EventId_fk]
GO

ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [Order_User_UserId_fk] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserId])
GO

ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [Order_User_UserId_fk]
GO



/****** Object:  Table [dbo].[OrderItem] ****/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[OrderItem](
	[OrderId] [int] NOT NULL,
	[EventPriceId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[OrderItemId] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [OrderItem_pk_2] PRIMARY KEY NONCLUSTERED 
(
	[OrderItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [OrderItem_pk] UNIQUE NONCLUSTERED 
(
	[OrderId] ASC,
	[EventPriceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[OrderItem]  WITH CHECK ADD  CONSTRAINT [OrderItem_EventPrice_EventPriceId_fk] FOREIGN KEY([EventPriceId])
REFERENCES [dbo].[EventPrice] ([EventPriceId])
GO

ALTER TABLE [dbo].[OrderItem] CHECK CONSTRAINT [OrderItem_EventPrice_EventPriceId_fk]
GO

ALTER TABLE [dbo].[OrderItem]  WITH CHECK ADD  CONSTRAINT [OrderItem_Order_OrderId_fk] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Order] ([OrderId])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[OrderItem] CHECK CONSTRAINT [OrderItem_Order_OrderId_fk]
GO



/****** Object:  Table [dbo].[OrderItemSecret] */
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[OrderItemSecret](
	[OrderItemId] [int] NOT NULL,
	[OrderItemSecretId] [uniqueidentifier] NOT NULL,
	[IsUsed] [bit] NOT NULL,
 CONSTRAINT [OrderItemSecret_pk] PRIMARY KEY NONCLUSTERED 
(
	[OrderItemSecretId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[OrderItemSecret] ADD  DEFAULT ((0)) FOR [IsUsed]
GO

ALTER TABLE [dbo].[OrderItemSecret]  WITH CHECK ADD  CONSTRAINT [OrderItemSecret_OrderItem_OrderItemId_fk] FOREIGN KEY([OrderItemId])
REFERENCES [dbo].[OrderItem] ([OrderItemId])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[OrderItemSecret] CHECK CONSTRAINT [OrderItemSecret_OrderItem_OrderItemId_fk]
GO


/****** Object:  Table [dbo].[Comment] */
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Comment](
	[CommentId] [uniqueidentifier] NOT NULL,
	[ParentId] [uniqueidentifier] NULL,
	[EventId] [int] NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Text] nvarchar(256) NOT NULL,
 CONSTRAINT [OrderItemSecret_pk] PRIMARY KEY NONCLUSTERED 
(
	[CommentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Comment]  WITH CHECK ADD  CONSTRAINT [Comment_Event_EventId_fk] FOREIGN KEY([EventId])
REFERENCES [dbo].[Event] ([EventId])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Comment] CHECK CONSTRAINT [Comment_Event_EventId_fk]
GO

ALTER TABLE [dbo].[Comment]  WITH CHECK ADD  CONSTRAINT [Comment_Comment_CommentId_fk] FOREIGN KEY([ParentId])
REFERENCES [dbo].[Comment] ([ParentId])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Comment] CHECK CONSTRAINT [Comment_Comment_CommentId_fk]
GO

ALTER TABLE [dbo].[Comment]  WITH CHECK ADD  CONSTRAINT [Comment_User_UserId_fk] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserId])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Comment] CHECK CONSTRAINT [Comment_User_UserId_fk]
GO