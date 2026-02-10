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
	@route("/responses/{id}/submit")
	@post
	op submitFormResponse(@path id: uuid, @body req: AnswersRequest): {
		@statusCode statusCode: 200;
	} | {
		@statusCode statusCode: 404;
		@body error: NotFound;
	};

	@summary("Update Form Response")
	@doc("Update answers for the response.")
	@route("/responses/{id}/answers")
	@patch(#{ implicitOptionality: true })
	op updateFormResponse(@path id: uuid, @body req: AnswersRequest): {
		@statusCode statusCode: 200;
	};

	@summary("Connect OAuth Account")
	@doc("Initiate OAuth flow for connecting an account to answer the question. Similar to the auth login flow, this endpoint will redirect (302) to the OAuth provider's authorization page. [See Auth Flow Reference](https://clustron.atlassian.net/wiki/spaces/CS/pages/41320449/Authentication+Process)")
	@route("/responses/{responseId}/questions/{questionId}/oauth/{provider}")
	@get
	op connectOauthAccount(
		@path responseId: uuid,
		@path questionId: uuid,
		@path provider: Auth.OAuthLoginProviders,
		
		@doc("The callback URL of the OAuth2 login. [See details](https://clustron.atlassian.net/wiki/spaces/CS/pages/41320449/Authentication+Process)")
		@query
		c: string,

		@doc("The redirect URL for login callback.")
		@query
		r?: string,
	): {
		@statusCode statusCode: 302;
	} | {
		@statusCode statusCode: 404;
		@body error: NotFound;
	};

	@summary("Upload Question Files")
	@doc("Upload files as answers for a specific question in the response.")
	@route("/responses/{responseId}/questions/{questionId}/files")
	@post
	op uploadQuestionFiles(
		@path responseId: uuid,
		@path questionId: uuid,
		@header("content-type") contentType: "multipart/form-data",
		@multipartBody body: QuestionFilesUploadRequest,
	): QuestionFilesUploadResponse;

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

	@summary("List Response Sections")
	@doc("List the form structure of the response.")
	@route("/responses/{id}/sections")
	@get
	op listResponseSections(@path id: uuid): {
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
