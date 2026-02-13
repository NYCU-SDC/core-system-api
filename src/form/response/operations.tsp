using Http;

@tag("Responses")
namespace CoreSystem.Responses {
	@summary("Create Form Response")
	@doc("Create a new response of a form.")
	@route("/forms/{formId}/responses")
	@post
	op createFormResponse(@path formId: uuid): {
		@statusCode statusCode: 201;
		@body response: CreateResponse;
	} | {
		@statusCode statusCode: 404;
		@body error: NotFound;
	};

	@summary("Submit Form Response")
	@doc("Submit all the answer in the form response.")
	@route("/responses/{responseId}/submit")
	@post
	op submitFormResponse(@path responseId: uuid, @body req: AnswersRequest): {
		@statusCode statusCode: 200;
	} | {
		@statusCode statusCode: 404;
		@body error: NotFound;
	};

	@summary("List Form Responses")
	@doc("List all responses for a specific form.")
	@route("/forms/{formId}/responses")
	@get
	op listFormResponses(@path formId: uuid): {
		@statusCode statusCode: 200;
		@body response: ListResponse;
	} | {
		@statusCode statusCode: 404;
		@body error: NotFound;
	};

	@summary("Get Form Response")
	@doc("Get the preview answer by response ID.")
	@route("/forms/{formId}/responses/{responseId}")
	@get
	op getFormResponse(@path formId: uuid, @path responseId: uuid): {
		@statusCode statusCode: 200;
		@body response: GetFormResponse;
	} | {
		@statusCode statusCode: 404;
		@body error: NotFound;
	};

	@summary("List Response Sections")
	@doc("List the form structure of the response.")
	@route("/responses/{responseId}/sections")
	@get
	op listResponseSections(@path responseId: uuid): {
		@statusCode statusCode: 200;
		@body response: ListSectionResponse;
	} | {
		@statusCode statusCode: 404;
		@body error: NotFound;
	};

	@summary("Delete Form Response")
	@doc("Delete a response and all its associated data.")
	@route("/forms/{formId}/responses/{responseId}")
	@delete
	op deleteFormResponse(@path formId: uuid, @path responseId: uuid): {
		@statusCode statusCode: 204;
	} | {
		@statusCode statusCode: 404;
		@body error: NotFound;
	};
}
