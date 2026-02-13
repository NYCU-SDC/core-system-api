using Http;

@tag("Forms")
namespace CoreSystem.Forms {
	@summary("List Forms")
	@doc("List all existing forms. Archived forms are excluded by default.")
	@route("/forms")
	@get
	op listForms(): Form[];

	@summary("Get Form")
	@doc("Get a specific form by its unique identifier.")
	@route("/forms/{id}")
	@get
	op getFormById(@path id: uuid): Form;

	@summary("Update Form")
	@doc("Update an existing form by its unique identifier.")
	@route("/forms/{id}")
	@put
	op updateForm(@path id: uuid, @body updateFormRequest: FormRequest): Form;

	@summary("Delete Form")
	@doc("Delete an existing form by its unique identifier.")
	@route("/forms/{id}")
	@delete
	op deleteForm(@path id: uuid): {
		@statusCode statusCode: 204;
	};

	@summary("Publish Form")
	@doc("Publish a form. Set status to 'published'.")
	@route("/forms/{id}/publish")
	@post
	op publishForm(@path id: uuid): {
		@statusCode statusCode: 200;
		@body response: FormPublishResponse;
	};

	@summary("Archive Form")
	@doc("Archive a form. Set status to 'ARCHIVED'. Archived forms are hidden from default lists but can still be accessed directly by ID.")
	@route("/forms/{id}/archive")
	@post
	op archiveForm(@path id: uuid): {
		@statusCode statusCode: 200;
		@body response: Form;
	};

	// === Cover Image Operations ===
	@summary("Get Form Cover Image")
	@doc("Get the cover image binary data. Returns the image in WebP format.")
	@route("/forms/{id}/cover")
	@get
	op getFormCoverImage(@path id: uuid): {
		@header("content-type") contentType: "image/webp";
		@body body: bytes;
	};

	@summary("Upload Form Cover Image")
	@doc("Upload a cover image for a form. The frontend should send images in WebP format with max-width/height: 1800px and quality 80%.")
	@route("/forms/{id}/cover")
	@post
	op uploadFormCoverImage(@path id: uuid, @header("content-type") contentType: "multipart/form-data", @multipartBody body: FormCoverUploadRequest): FormCoverUploadResponse;

	// === Section Operations ===
	@summary("List Sections")
	@doc("List all the questions of the sections in the form.")
	@route("/forms/{id}/sections")
	@get
	op listSections(@path id: uuid): ListSectionsResponse[];

	// === Google Sheet Operations ===
	@summary("Get Google Sheet Email")
	@doc("Get the Gmail address that should be added to Google Sheet permissions. This address needs to be granted access to the Google Sheet so the system can modify the form.")
	@route("/forms/google-sheet-email")
	@get
	op getGoogleSheetEmail(): GoogleSheetEmailResponse;

	@summary("Verify Google Sheet")
	@doc("Verify the Google Sheet URL and whether the system can access it.")
	@route("/forms/google-sheet/verify")
	@post
	op verifyGoogleSheet(@body req: GoogleSheetVerifyRequest): GoogleSheetVerifyResponse;

	@summary("Get Form Fonts")
	@doc("Get available fonts list for forms dressing.")
	@route("/forms/fonts")
	@get
	op getFormFonts(): Font[];

	// Deprecated
	// @summary("Preview Recipients")
	// @doc("Preview recipients by orgIds/unitIds (no duplicated).")
	// @route("/forms/recipients/preview")
	// @post
	// op previewRecipients(@body req: RecipientSelectionRequest): RecipientSelectionResponse;

}
