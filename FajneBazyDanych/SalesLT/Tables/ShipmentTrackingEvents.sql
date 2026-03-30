CREATE TABLE [SalesLT].[ShipmentTrackingEvents] (
    [EventID]      BIGINT        NULL,
    [SalesOrderID] INT           NOT NULL,
    [EventDate]    DATETIME      NOT NULL,
    [Location]     VARCHAR (100) NULL,
    [Status]       VARCHAR (50)  NULL,
    [Notes]        VARCHAR (200) NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_Tracking]
    ON [SalesLT].[ShipmentTrackingEvents]([SalesOrderID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ShipmentTracking_DeliveryStatus]
    ON [SalesLT].[ShipmentTrackingEvents]([SalesOrderID] ASC, [EventDate] ASC) WHERE ([Status]='Delivered');

