using Http;

@tag("Unit")
namespace CoreSystem.Unit {
	@summary("Add Parent-Child Relationship")
	@post
	@route("/orgs/relations")
	@doc("Create a new parent-child relationship between units by linking them")
	op addParentChild(@body Request: ParentChildRequest): {
		@statusCode statusCode: 201;
		@body parentChild: ParentChild;
	};

	@summary("Remove Parent-Child Relationship")
	@delete
	@route("/orgs/relations/child-id/{child_id}")
	@doc("Remove a parent-child relationship between units by unlinking them")
	op removeParentChild(@path child_id: uuid): {
		@statusCode statusCode: 204;
	} | {
		@statusCode statusCode: 404;
		@body error: string;
	};
}
