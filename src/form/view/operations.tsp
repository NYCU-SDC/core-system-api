using Http;

@tag("Views")
namespace CoreSystem.Views {
	@summary("Create Form View")
	@doc("Create a new view for a form with default settings. Conflict when the name is already in use.")
	@route("/forms/{formId}/views")
	@post
	op createFormView(@path formId: uuid): {
		@statusCode statusCode: 201;
		@body response: ViewResponse;
	} | {
		@statusCode statusCode: 400;
		@body error: BadRequest;
	} | {
		@statusCode statusCode: 404;
		@body error: NotFound;
	};

	@summary("List Form Views")
	@doc("List all views for a specific form.")
	@route("/forms/{formId}/views")
	@get
	op listFormViews(@path formId: uuid): {
		@statusCode statusCode: 200;
		@body response: ViewResponse[];
	} | {
		@statusCode statusCode: 404;
		@body error: NotFound;
	};

	@summary("Get Form View")
	@doc("Get a specific view by its unique identifier.")
	@route("/forms/{formId}/views/{viewId}")
	@get
	op getFormView(@path formId: uuid, @path viewId: uuid): {
		@statusCode statusCode: 200;
		@body response: ViewResponse;
	} | {
		@statusCode statusCode: 404;
		@body error: NotFound;
	};

	@summary("Update Form View")
	@doc("Partially update a view. Only the provided fields (name, locked, order) will be updated. Can be used to rename, lock/unlock, or update column visibility.")
	@route("/forms/{formId}/views/{viewId}")
	@patch(#{ implicitOptionality: true })
	op updateFormView(@path formId: uuid, @path viewId: uuid, @body req: UpdateViewRequest): {
		@statusCode statusCode: 200;
		@body response: ViewResponse;
	} | {
		@statusCode statusCode: 400;
		@body error: BadRequest;
	} | {
		@statusCode statusCode: 404;
		@body error: NotFound;
	};

	@summary("Delete Form View")
	@doc("Delete a view by its unique identifier.")
	@route("/forms/{formId}/views/{viewId}")
	@delete
	op deleteFormView(@path formId: uuid, @path viewId: uuid): {
		@statusCode statusCode: 204;
	} | {
		@statusCode statusCode: 404;
		@body error: NotFound;
	} | {
		@statusCode statusCode: 409;
		@body error: Conflict;
	} ;

	@summary("Duplicate Form View")
	@doc("Create a duplicate of an existing view. The new view's name defaults to the original name suffixed with '的副本'.")
	@route("/forms/{formId}/views/{viewId}/duplicate")
	@post
	op duplicateFormView(@path formId: uuid, @path viewId: uuid): {
		@statusCode statusCode: 201;
		@body response: ViewResponse;
	} | {
		@statusCode statusCode: 404;
		@body error: NotFound;
	};
}
