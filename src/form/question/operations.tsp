using Http;

@tag("Forms")
namespace CoreSystem.Forms {
	// for form edit - question management
	@summary("Create Question")
	@doc("""
		Create a new question for a specific section. Description fields in the request body should be sent as ProseMirror JSON from the Tiptap editor.

		The `order` field specifies where to insert the question within the section. The value is clamped to the valid range `[1, currentCount + 1]`. If the question is inserted in the middle (i.e., not appended at the end), all existing questions at or after the specified position are shifted down by one to make room for the new question.
		""")
	@route("/sections/{sectionId}/questions")
	@post
	op createQuestion(@path sectionId: uuid, @body q: QuestionRequest): {
		@statusCode statusCode: 201;
		@body question: QuestionResponse;
	};

	@summary("Update Question")
	@doc("""
		Update an existing question by its unique identifier. Description fields in the request body should be sent as ProseMirror JSON from the Tiptap editor.

		If the `order` field differs from the question's current position, the question is moved to the new position (clamped to `[1, totalCount]`). All questions between the old and new positions are shifted accordingly to maintain a contiguous order sequence.
		""")
	@route("/sections/{sectionId}/questions/{questionId}")
	@put
	op updateQuestion(@path sectionId: uuid, @path questionId: uuid, @body q: QuestionRequest): QuestionResponse;

	@summary("Delete Question")
	@doc("""
		Delete an existing question by its unique identifier.

		After deletion, all remaining questions in the same section with a higher order value are shifted up by one to maintain a contiguous order sequence without gaps.
		""")
	@route("/sections/{sectionId}/questions/{questionId}")
	@delete
	op deleteQuestion(@path sectionId: uuid, @path questionId: uuid): {
		@statusCode statusCode: 204;
	};
}
