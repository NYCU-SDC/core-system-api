using Http;

@tag("Forms")
namespace CoreSystem.Forms {
	// for form edit - question management
	@summary("Create Question")
	@doc("Create a new question for a specific section.")
	@route("/sections/{id}/questions")
	@post
	op createQuestion(@path id: uuid, @body q: QuestionRequest): {
		@statusCode statusCode: 201;
		@body question: QuestionResponse;
	};

	@summary("Update Question")
	@doc("Update an existing question by its unique identifier.")
	@route("/sections/{sectionId}/questions/{questionId}")
	@put
	op updateQuestion(@path sectionId: uuid, @path questionId: uuid, @body q: QuestionRequest): QuestionResponse;

	@summary("Delete Question")
	@doc("Delete an existing question by its unique identifier.")
	@route("/sections/{sectionId}/questions/{questionId}")
	@delete
	op deleteQuestion(@path sectionId: uuid, @path questionId: uuid): {
		@statusCode statusCode: 204;
	};
}
