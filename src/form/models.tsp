using Http;

namespace CoreSystem.Forms {
	@doc("The request body for uploading a cover image. The frontend should send images in WebP format with max-width/height: 1800px and quality 80%.")
	model FormCoverUploadRequest {
		coverImage: HttpPart<bytes>;
	}

	@doc("Response after uploading a cover image.")
	@example(#{ imageUrl: "https://example.com/images/form-cover-123.webp" })
	model FormCoverUploadResponse {
		@doc("The temporary full URL of the uploaded image.")
		imageUrl: string;
	}

	@doc("The request body for creating/updating a form.")
	@example(#{ title: "Enter SDC Form", description: "If you want to join us, just fill in this form!", messageAfterSubmission: "Thank you for your submission!" })
	model FormRequest {
		@doc("The title of the form.")
		title: string;

		@doc("The description of the form.")
		description: string;

		@doc("(Optional) Preview text for the form. If not provided, fallback to first 25 characters of description.")
		previewMessage?: string;

		@doc("(Optional) Deadline for form completion.")
		deadline?: utcDateTime;

		@doc("When the form is available to be filled.")
		publishTime?: utcDateTime;

		@doc("The message to show after user's submission.")
		messageAfterSubmission: string;

		@doc("The dressing of the form.")
		dressing?: FormDressing;

		@doc("The image path returned by the upload API.")
		coverImage?: string;

		@doc("The google sheet url this form's responses will be sent to.")
		googleSheetUrl?: string;

		@doc("The visibility setting of the form. Public forms are visible to all logged-in users. Private forms require a direct link to access.")
		visibility?: FormVisibility;
	}

	@doc("The structure of a form.")
	@example(#{
		id: "9a843aa0-8451-4e3b-b6a0-8c0e994e9040",
		title: "SDC 2025 Recruitment Form",
		description: "Join us for an exciting journey in software development!",
		previewMessage: "Join us for an exciting journey",
		status: FormStatus.published,
		unitId: "d26e9c90-4747-496b-9953-7e7c4f97643f",
		lastEditor: "3c5fa073-7b97-43a3-bc44-ddc98f390a08",
		deadline: utcDateTime.fromISO("2025-03-31T23:59:59Z"),
		publishTime: utcDateTime.fromISO("2025-02-01T00:00:00Z"),
		messageAfterSubmission: "Thank you for your application! We'll get back to you soon.",
		dressing: #{ color: "#0066cc", headerFont: "LINESeedTW", questionFont: "LINESeedTW", textFont: "LINESeedTW" },
		coverImage: "https://example.com/images/form-cover.webp",
		googleSheetUrl: "https://docs.google.com/spreadsheets/d/1ABC123/edit",
		visibility: FormVisibility.public,
		createdAt: utcDateTime.fromISO("2025-01-15T10:00:00Z"),
		updatedAt: utcDateTime.fromISO("2025-02-10T14:30:00Z"),
	})
	model Form {
		@doc("The form's unique identifier.")
		id: uuid;

		@doc("The title of the form.")
		title: string;

		@doc("The description written in the form to show user info.")
		description: string;

		@doc("Preview text. If not provided, fallback to first 25 characters of description.")
		previewMessage: string;

		@doc("The status of this form.")
		status: FormStatus;

		@doc("The unit this form belongs to.")
		unitId: uuid;

		@doc("The user who last editted the form.")
		lastEditor: uuid;

		@doc("(Optional) Deadline for form completion. If not specified, returns null.")
		deadline?: utcDateTime;

		@doc("When the form is available to be filled.")
		publishTime?: utcDateTime;

		@doc("The message to show after user's submission.")
		messageAfterSubmission: string;

		@doc("The dressing of the form.")
		dressing?: FormDressing;

		@doc("The full URL to access the cover image.")
		coverImage?: string;

		@doc("The google sheet url this form's responses will be sent to.")
		googleSheetUrl?: string;

		@doc("The visibility setting of the form. Public forms are visible to all logged-in users. Private forms require a direct link to access.")
		visibility: FormVisibility;

		@doc("The creation timestamp of the form.")
		createdAt: utcDateTime;

		@doc("The last updated timestamp of the form")
		updatedAt: utcDateTime;
	}

	@doc("The appearance/dressing configuration for a form.")
	@example(#{ color: "#0066cc", headerFont: "LINESeedTW", questionFont: "LINESeedTW", textFont: "LINESeedTW" })
	model FormDressing {
		@doc("Color in hex format (e.g., #0066cc)")
		color?: string;

		@doc("Header font id from https://font.emtech.cc/list")
		headerFont?: string;

		@doc("Question font id from https://font.emtech.cc/list")
		questionFont?: string;

		@doc("Text font id from https://font.emtech.cc/list")
		textFont?: string;
	}

	@doc("A section within a form, grouping questions together.")
	@example(#{
		id: "b23f2668-c2dc-4213-88fe-eceedff46398",
		formId: "9a843aa0-8451-4e3b-b6a0-8c0e994e9040",
		title: "Personal Information",
		description: "Please provide your basic information",
		questions: #[],
	})
	model Section {
		@doc("Unique identifier.")
		id: uuid;

		@doc("The form this section belongs to.")
		formId: uuid;

		@doc("Section title (e.g., 'Group Info').")
		title: string;

		@doc("Section description.")
		description?: string;

		@doc("The questions of the section.")
		questions: QuestionResponse[];
	}

	@doc("The current progress of a section")
	enum SectionProgress {
		@doc("User hasn't started or not finished.")
		draft: "DRAFT",

		@doc("User has completed/passed this response.")
		submitted: "SUBMITTED",
	}

	@doc("The current status of a form.")
	enum FormStatus {
		draft: "DRAFT",
		published: "PUBLISHED",

		@doc("Archived: form is hidden from default listings but is still stored and can be accessed directly.")
		archived: "ARCHIVED",
	}

	@doc("The visibility setting of a form. Public forms are visible to all logged-in users. Private forms require a direct link to access.")
	enum FormVisibility {
		@doc("Public: visible to all logged-in users")
		public: "PUBLIC",

		@doc("Private: requires a direct link to access")
		private: "PRIVATE",
	}

	@doc("Response model for listing all sections and questions in a form.")
	@example(#{ sections: #[] })
	model ListSectionsResponse {
		sections: Section[];
	}

	// form recipientUser
	@doc("The basic info of a user that can receive the form.")
	@example(#{ id: "3c5fa073-7b97-43a3-bc44-ddc98f390a08", name: "John Doe" })
	model RecipientUser {
		id: uuid;
		name: string;
	}

	@doc("Select recipients by organizations and/or units.(remove duplicates).")
	@example(#{ unitIds: #["9a843aa0-8451-4e3b-b6a0-8c0e994e9040"] })
	model RecipientSelectionRequest {
		@doc("Target organization ID to collect users from.")
		orgId?: uuid;

		@doc("Target unit IDs to collect users from.")
		unitIds?: uuid[];
	}

	@doc("The result of recipients selection (no duplicated).")
	@example(#{ recipients: #[#{ id: "3c5fa073-7b97-43a3-bc44-ddc98f390a08", name: "John Doe" }] })
	model RecipientSelectionResponse {
		recipients: RecipientUser[];
	}

	@doc("Response after publishing a form.")
	@example(#{ visibility: FormVisibility.public })
	model FormPublishResponse {
		@doc("The visibility setting of the form. Public forms are visible to all logged-in users. Private forms require a direct link to access.")
		visibility: FormVisibility;
	}

	@doc("Response containing the Gmail address for Google Sheet permissions.")
	@example(#{ email: "core-system-bot@example.com" })
	model GoogleSheetEmailResponse {
		@doc("The Gmail address that should be added to Google Sheet permissions so the system can modify the form.")
		email: string;
	}

	@doc("Request body for verifying a Google Sheet URL.")
	@example(#{ googleSheetUrl: "https://docs.google.com/spreadsheets/d/1ABC123XYZ/edit" })
	model GoogleSheetVerifyRequest {
		@doc("The Google Sheet URL provided by user.")
		googleSheetUrl: string;
	}

	@doc("Verification result for the given Google Sheet URL.")
	@example(#{ isValid: true })
	model GoogleSheetVerifyResponse {
		@doc("Indicates whether the Google Sheet URL is valid and accessible.")
		isValid: boolean;
	}

	@doc("A font definition used in form dressing.")
	@example(#{ id: "LINESeedTW", name: "LINE Seed TW" })
	model Font {
		@doc("The unique identifier of the font.")
		id: string;

		@doc("The display name of the font.")
		name: string;
	}
}
