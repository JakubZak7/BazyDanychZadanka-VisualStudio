CREATE TABLE [SalesLT].[ProductReview] (
    [ReviewID]     INT            IDENTITY (1, 1) NOT NULL,
    [ProductID]    INT            NOT NULL,
    [ReviewerName] NVARCHAR (50)  NULL,
    [Rating]       INT            NULL,
    [ReviewText]   NVARCHAR (MAX) NULL,
    [ReviewDate]   DATETIME       DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ReviewID] ASC),
    CHECK ([Rating]>=(1) AND [Rating]<=(5)),
    CONSTRAINT [FK_ProductReview_Product] FOREIGN KEY ([ProductID]) REFERENCES [SalesLT].[Product] ([ProductID])
);

