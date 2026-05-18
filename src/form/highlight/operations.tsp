using Http;

@tag("Forms")
namespace CoreSystem.Forms {
	@summary("Get Form Highlight")
	@doc("Get the highlight question and its response statistics for a specific form. Returns 200 with questionId=null when no highlight is configured.")
	@route("/forms/{formId}/highlight")
	@get
	op getFormHighlight(@path formId: uuid): {
		@statusCode statusCode: 200;
		@body response: HighlightResponse;
	} | {
		@statusCode statusCode: 404;
		@body error: NotFound;
	};

	@summary("Set Form Highlight")
	@doc("Set or update the highlight question for a specific form. Returns 400 if the question is not a choice-based type (singleChoice, multipleChoice, dropdown, detailedMultipleChoice).")
	@route("/forms/{formId}/highlight")
	@put
	op setFormHighlight(@path formId: uuid, @body req: HighlightRequest): {
		@statusCode statusCode: 200;
		@body response: HighlightResponse;
	} | {
		@statusCode statusCode: 400;
		@body error: BadRequest;
	} | {
		@statusCode statusCode: 404;
		@body error: NotFound;
	};

	@summary("Clear Form Highlight")
	@doc("Clear the highlight question for a specific form.")
	@route("/forms/{formId}/highlight")
	@delete
	op clearFormHighlight(@path formId: uuid): {
		@statusCode statusCode: 204;
	} | {
		@statusCode statusCode: 404;
		@body error: NotFound;
	};
}
