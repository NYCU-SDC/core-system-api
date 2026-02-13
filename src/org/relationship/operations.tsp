using Http;

@tag("Unit")
namespace CoreSystem.Unit {
	@summary("Add Parent-Child Relationship")
	@post
	@route("/orgs/relations")
	@doc("Create a new parent-child relationship between units by linking them")
	op addParentChild(@body request: ParentChildRequest): {
		@statusCode statusCode: 201;
		@body parentChild: ParentChild;
	};

	@summary("Remove Parent-Child Relationship")
	@delete
	@route("/orgs/relations/child-id/{childId}")
	@doc("Remove a parent-child relationship between units by unlinking them")
	op removeParentChild(@path childId: uuid): {
		@statusCode statusCode: 204;
	} | {
		@statusCode statusCode: 404;
		@body error: string;
	};
}
