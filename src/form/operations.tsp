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
	@route("/forms/{formId}")
	@get
	op getFormById(@path formId: uuid): Form;

	@summary("Update Form")
	@doc("Update an existing form by its unique identifier.")
	@route("/forms/{formId}")
	@patch(#{ implicitOptionality: true })
	op updateForm(@path formId: uuid, @body updateFormRequest: FormRequest): Form;

	@summary("Delete Form")
	@doc("Delete an existing form by its unique identifier.")
	@route("/forms/{formId}")
	@delete
	op deleteForm(@path formId: uuid): {
		@statusCode statusCode: 204;
	};

	@summary("Publish Form")
	@doc("Publish a form. Set status to 'published'.")
	@route("/forms/{formId}/publish")
	@post
	op publishForm(@path formId: uuid): {
		@statusCode statusCode: 200;
		@body response: FormPublishResponse;
	};

	@summary("Archive Form")
	@doc("Archive a form. Set status to 'ARCHIVED'. Archived forms are hidden from default lists but can still be accessed directly by ID.")
	@route("/forms/{formId}/archive")
	@post
	op archiveForm(@path formId: uuid): {
		@statusCode statusCode: 200;
		@body response: Form;
	};

	// === Cover Image Operations ===
	@summary("Get Form Cover Image")
	@doc("Get the cover image binary data. Returns the image in WebP format.")
	@route("/forms/{formId}/cover")
	@get
	op getFormCoverImage(@path formId: uuid): {
		@header("content-type") contentType: "image/webp";
		@body body: bytes;
	};

	@summary("Upload Form Cover Image")
	@doc("Upload a cover image for a form. The frontend should send images in WebP format with max-width/height: 1800px and quality 80%.")
	@route("/forms/{formId}/cover")
	@post
	op uploadFormCoverImage(@path formId: uuid, @header("content-type") contentType: "multipart/form-data", @multipartBody body: FormCoverUploadRequest): FormCoverUploadResponse;

	// === Section Operations ===
	@summary("List Sections")
	@doc("List all the questions of the sections in the form.")
	@route("/forms/{formId}/sections")
	@get
	op listSections(@path formId: uuid): ListSectionsResponse[];

	@summary("Update Section")
	@doc("Update an existing section by its unique identifier.")
	@route("/forms/{formId}/sections/{sectionId}")
	@patch(#{ implicitOptionality: true })
	op updateSection(@path formId: uuid, @path sectionId: uuid, @body updateSectionRequest: SectionRequest): Section;

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
