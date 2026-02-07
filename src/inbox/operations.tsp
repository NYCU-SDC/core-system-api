using Http;

@tag("Inbox")
namespace CoreSystem.Inbox {
	@summary("List Inbox Messages")
	@doc("Get all the preview of the inbox messages with pagination.")
	@route("/inbox")
	@get
	@list
	op getInboxMessages(
		@query isRead?: boolean = false,
		@query isStarred?: boolean = false,
		@query isArchived?: boolean = false,
		@query search?: string,
		@query unitIds?: uuid[],
		@query @pageIndex page?: int32 = 1,
		@query @pageSize size?: int32 = 10,
	): {
		@statusCode statusCode: 200;
		@body body: {
			@pageItems items: UserInboxMessage[];
			totalPages: int32;
			totalItems: int32;
			currentPage: int32;
			pageSize: int32;
			hasNextPage: boolean;
		};
	} | errorResponse;

	@summary("Get Inbox Message")
	@doc("Get the user inbox message by its unique identifier.")
	@route("/inbox/{id}")
	@get
	op getInboxMessage(@path id: uuid): {
		@statusCode statusCode: 200;
		@body body: UserInboxMessageDetail;
	} | errorResponse;

	@summary("Update Inbox Message Flags")
	@doc("Update flags for the user inbox message.")
	@route("/inbox/{id}")
	@put
	op updateInboxMessageFlag(
		@path id: uuid,

		@example(#{ isRead: false, isStarred: true, isArchived: false })
		@body
		body: {
			isRead?: boolean = false;
			isStarred?: boolean = false;
			isArchived?: boolean = false;
		},
	): {
		@statusCode statusCode: 200;
		@body body: UserInboxMessage;
	} | errorResponse;
}
