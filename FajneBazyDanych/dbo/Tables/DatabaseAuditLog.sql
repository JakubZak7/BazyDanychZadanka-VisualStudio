CREATE TABLE [dbo].[DatabaseAuditLog] (
    [LogID]       INT            IDENTITY (1, 1) NOT NULL,
    [EventDate]   DATETIME       DEFAULT (getdate()) NULL,
    [UserName]    NVARCHAR (100) NULL,
    [EventType]   NVARCHAR (100) NULL,
    [ObjectName]  NVARCHAR (100) NULL,
    [TSQLCommand] NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([LogID] ASC)
);

