Create trigger tgr_AuditLogTableChange on database
for create_table, alter_table, drop_table
as 
begin
	set nocount on;

	Declare @EventData XML = EVENTDATA()

	Insert into dbo.DatabaseAuditLog (UserName, EventType, ObjectName, TSQLCommand)
	Values (
		ORIGINAL_LOGIN(),
		@EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)'),
        @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(100)'),
        @EventData.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'NVARCHAR(MAX)')
	);
End