using Http;

@tag("Forms")
namespace CoreSystem.Forms {
	@doc("Update an existing form by its unique identifier.")
	@route("/forms/{id}")
	@put
	op updateForm(@path id: uuid, @body updateFormRequest: FormRequest): Form;

	@doc("Delete an existing form by its unique identifier.")
	@route("/forms/{id}")
	@delete
	op deleteForm(@path id: uuid): {
		@statusCode statusCode: 204;
	};

	@doc("Get a specific form by its unique identifier.")
	@route("/forms/{id}")
	@get
	op getFormById(@path id: uuid): Form;

	@doc("List all existing forms.")
	@route("/forms")
	@get
	op listForms(): Form[];

	// for form edit - question management
	@doc("Create a new question for a specific section.")
	@route("/sections/{id}/questions")
	@post
	op createQuestion(@path id: uuid, @body q: QuestionRequest): {
		@statusCode statusCode: 201;
		@body question: QuestionResponse;
	};

	@doc("Update an existing question by its unique identifier.")
	@route("/sections/{sectionId}/questions/{questionId}")
	@put
	op updateQuestion(@path sectionId: uuid, @path questionId: uuid, @body q: QuestionRequest): QuestionResponse;

	@doc("Delete an existing question by its unique identifier.")
	@route("/sections/{sectionId}/questions/{questionId}")
	@delete
	op deleteQuestion(@path sectionId: uuid, @path questionId: uuid): {
		@statusCode statusCode: 204;
	};

	@doc("List all the questions of the sections in the form.")
	@route("/forms/{id}/sections")
	@get
	op listSections(@path id: uuid): ListSectionsResponse[];

	@doc("Upload a cover image for a form. The frontend should send images in WebP format with max-width/height: 1800px and quality 80%.")
	@route("/forms/{id}/cover")
	@post
	op uploadFormCoverImage(@path id: uuid, @header("content-type") contentType: "multipart/form-data", @multipartBody body: FormCoverUploadRequest): FormCoverUploadResponse;

	@doc("Get the cover image binary data. Returns the image in WebP format.")
	@route("/forms/{id}/cover")
	@get
	op getFormCoverImage(@path id: uuid): {
		@header("content-type") contentType: "image/webp";
		@body body: bytes;
	};

	// for form publish
	@doc("Preview recipients by orgIds/unitIds (no duplicated).")
	@route("/forms/recipients/preview")
	@post
	op previewRecipients(@body req: RecipientSelectionRequest): RecipientSelectionResponse;

	@doc("Publish a form. Set status to 'published'.")
	@route("/forms/{id}/publish")
	@post
	op publishForm(@path id: uuid): {
		@statusCode statusCode: 200;
		@body response: FormPublishResponse;
	};

	@doc("Get the Gmail address that should be added to Google Sheet permissions. This address needs to be granted access to the Google Sheet so the system can modify the form.")
	@route("/forms/google-sheet-email")
	@get
	op getGoogleSheetEmail(): GoogleSheetEmailResponse;

	@doc("Verify the Google Sheet URL and whether the system can access it.")
	@route("/forms/google-sheet/verify")
	@post
	op verifyGoogleSheet(@body req: GoogleSheetVerifyRequest): GoogleSheetVerifyResponse;

	@doc("Get available fonts list for forms dressing.")
	@route("/forms/fonts")
	@get
	op getFormFonts(): Font[];
}
