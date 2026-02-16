using Http;

@tag("Responses")
namespace CoreSystem.Responses {
	@summary("Connect OAuth Account")
	@doc("Initiate OAuth flow for connecting an account to answer a question. This endpoint redirects (302) to the OAuth provider's authorization page. After authorization, the OAuth profile data (username, avatar_url) is stored as the answer and can be fetched via GET /responses/{responseId}/questions/{questionId}.")
	@route("/oauth/questions/{provider}")
	@get
	op connectOauthAccount(
		@path
		@doc("The OAuth provider to connect with (github or google).")
		provider: CoreSystem.Auth.OAuthProviders,

		@query
		@doc("The response ID to associate this OAuth answer with.")
		responseId: uuid,

		@query
		@doc("The question ID being answered.")
		questionId: uuid,

		@query
		@doc("Optional redirect URL after OAuth completion.")
		r?: string,
	): {
		@statusCode statusCode: 302;
	} | {
		@statusCode statusCode: 404;
	};

	@summary("Upload Question Files")
	@doc("Upload files as answers for a specific question in the response. This operation automatically creates or updates the answer for this question with the uploaded file URLs.")
	@route("/responses/{responseId}/questions/{questionId}/files")
	@post
	op uploadQuestionFiles(@path responseId: uuid, @path questionId: uuid, @header("content-type") contentType: "multipart/form-data", @multipartBody body: QuestionFilesUploadRequest): {
		@statusCode statusCode: 200;
		@body response: QuestionFilesUploadResponse;
	} | {
		@statusCode statusCode: 404;
		@body error: NotFound;
	};

	@summary("Get Question Response")
	@doc("Get a specific answer by question ID in the response.")
	@route("/responses/{responseId}/questions/{questionId}")
	@get
	op getQuestionResponse(@path responseId: uuid, @path questionId: uuid): {
		@statusCode statusCode: 200;
		@body response: GetQuestionResponse;
	} | {
		@statusCode statusCode: 404;
		@body error: NotFound;
	};

	@summary("Update Form Response")
	@doc("Update answers for the response.")
	@route("/responses/{responseId}/answers")
	@patch(#{ implicitOptionality: true })
	op updateFormResponse(@path responseId: uuid, @body req: AnswersRequest): {
		@statusCode statusCode: 200;
		@body response: UpdateResponse;
	};
}
