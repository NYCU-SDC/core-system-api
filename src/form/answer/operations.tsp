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

	@summary("OAuth Callback for Question Binding")
	@doc("""
		OAuth provider redirects here after the user authorizes (or denies) the connection.
		The server exchanges the code for profile data, stores it as the answer for the question encoded in `state`, then redirects the user to `r`.

		The redirect URL (`r`) will always receive the following query parameters:

		| Parameter | Values | Description |
		|-----------|--------|-------------|
		| `status`  | `success` \\| `error` | Outcome of the OAuth flow. |
		| `error`   | OAuth error code (e.g. `access_denied`) | Only present when `status=error`. |

		**Example redirects:**
		- Success: `{r}?status=success`
		- Failure: `{r}?status=error&error=access_denied`
	""")
	@route("/oauth/callback/{provider}")
	@get
	op oauthAnswerCallback(
		@path
		provider: CoreSystem.Auth.OAuthProviders,

		@query
		@doc("Authorization code returned by the OAuth provider on success.")
		code?: string,

		@query
		@doc("Opaque state value created during initiation; encodes responseId, questionId, and redirect URL.")
		state?: string,

		@query
		@doc("Error code returned by the OAuth provider when the user denied authorization (e.g. `access_denied`).")
		error?: string,
	): {
		@statusCode statusCode: 302;
		@header location: string;
	} | {
		@statusCode statusCode: 400;
		@body error: BadRequest;
	};

	@summary("Upload Question Files")
	@doc("Upload files as answers for a specific question in the response. This operation automatically creates or updates the answer for this question with the uploaded file URLs.")
	@route("/responses/{responseId}/questions/{questionId}/files")
	@post
	op uploadQuestionFiles(@path responseId: uuid, @path questionId: uuid, @header("content-type") contentType: "multipart/form-data", @multipartBody body: QuestionFilesUploadRequest): {
		@statusCode statusCode: 201;
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
		@body response: {
			answers: AnswerPayload[];
		}
	};
}
