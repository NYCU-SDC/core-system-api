using Http;

namespace CoreSystem.Forms {
	@doc("The request body for uploading a cover image. The frontend should send images in WebP format with max-width/height: 1800px and quality 80%.")
	model FormCoverUploadRequest {
		coverImage: HttpPart<bytes>;
	}

	@doc("Response after uploading a cover image.")
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
	model Section {
		@doc("Unique identifier.")
		id: uuid;

		@doc("The form this section belongs to.")
		formId: uuid;

		@doc("Section title (e.g., 'Group Info').")
		title: string;

		@doc("Section description.")
		description?: string;
	}

	@doc("The current progress of a section")
	enum SectionProgress {
		@doc("User hasn't started or not finished.")
		draft: "DRAFT",

		@doc("User has completed/passed this response.")
		submitted: "SUBMITTED",
	}

	@doc("The current status of form ")
	enum FormStatus {
		draft: "DRAFT",
		published: "PUBLISHED",
	}

	@doc("The visibility setting of a form. Public forms are visible to all logged-in users. Private forms require a direct link to access.")
	enum FormVisibility {
		@doc("Public: visible to all logged-in users")
		public: "PUBLIC",

		@doc("Private: requires a direct link to access")
		private: "PRIVATE",
	}

	@doc("The current types of question")
	enum QuestionTypes {
		@doc("Short text input field")
		shortText: "SHORT_TEXT",

		@doc("Long text textarea field")
		longText: "LONG_TEXT",

		@doc("Single choice with radio buttons")
		singleChoice: "SINGLE_CHOICE",

		@doc("Multiple choice with checkboxes")
		multipleChoice: "MULTIPLE_CHOICE",

		@doc("Single choice with dropdown select")
		dropdown: "DROPDOWN",

		@doc("Multiple choice with descriptions")
		detailedMultipleChoice: "DETAILED_MULTIPLE_CHOICE",

		@doc("Date picker")
		date: "DATE",

		@doc("File upload")
		uploadFile: "UPLOAD_FILE",

		@doc("Linear scale/rating (1-5, 1-10, etc.)")
		linearScale: "LINEAR_SCALE",

		@doc("Rating (e.g., star rating)")
		rating: "RATING",

		@doc("Ranking/ordering items by preference")
		ranking: "RANKING",

		@doc("OAuth account connection for external service authentication")
		oauthConnect: "OAUTH_CONNECT",

		@doc("Hyperlink is a type of short text question.")
		hyperlink: "HYPERLINK",
	}

	@doc("Allowed file types/extensions for file upload questions.")
	enum allowedFileTypes {
		@doc("document")
		txt: "TXT",

		md: "MD",
		doc: "DOC",
		docx: "DOCX",
		odt: "ODT",
		rtf: "RTF",

		@doc("presentation")
		ppt: "PPT",

		pptx: "PPTX",
		odp: "ODP",

		@doc("spreadsheet")
		xls: "XLS",

		xlsx: "XLSX",
		ods: "ODS",
		csv: "CSV",

		@doc("vector graphics")
		svg: "SVG",

		ai: "AI",
		eps: "EPS",

		@doc("PDF")
		pdf: "PDF",

		@doc("image")
		jpg: "JPG",

		jpeg: "JPEG",
		png: "PNG",
		webp: "WEBP",
		gif: "GIF",
		tiff: "TIFF",
		bmp: "BMP",
		heic: "HEIC",
		raw: "RAW",

		@doc("video")
		mp4: "MP4",

		webm: "WEBM",
		mov: "MOV",
		mkv: "MKV",
		avi: "AVI",

		@doc("audio")
		mp3: "MP3",

		wav: "WAV",
		m4a: "M4A",
		aac: "AAC",
		ogg: "OGG",
		flac: "FLAC",

		@doc("archive")
		zip: "ZIP",
	}

	@doc("File size limit options for file uploads.")
	enum FileSizeLimit {
		@doc("1 MB")
		oneMB: "1_MB",

		@doc("5 MB")
		fiveMB: "5_MB",

		@doc("10 MB")
		tenMB: "10_MB",

		@doc("100 MB")
		hundredMB: "100_MB",

		@doc("1 GB")
		oneGB: "1_GB",
	}

	@doc("Options for file upload questions.")
	model UploadFileOption {
		@doc("Allowed file types/extensions.")
		allowedFileTypes: allowedFileTypes[];

		@doc("Maximum number of files that can be uploaded. Range: 1-10.")
		@minValue(1)
		@maxValue(10)
		maxFileAmount: int32;

		@doc("Maximum file size limit.")
		maxFileSizeLimit: FileSizeLimit;
	}

	@doc("Options for linear scale and rating questions.")
	model ScaleOption {
		@doc("Background icon for the linear scale option.")
		icon?: string;

		@doc("Minimum value of the linear scale.")
		minVal: int32;

		@doc("Maximum value of the linear scale.")
		maxVal: int32;

		@doc("Label for the minimum value.")
		minValueLabel?: string;

		@doc("Label for the maximum value.")
		maxValueLabel?: string;
	}

	@doc("A choice option for creating/updating choice-based questions.")
	model ChoiceOption {
		@doc("The name/text of the choice option.")
		name: string;

		@doc("Optional description for the choice.")
		description?: string;
	}

	@doc("Options for date questions.")
	model DateOption {
		@doc("Whether the year component is required for the date.")
		hasYear: boolean;

		@doc("Whether the month component is required for the date.")
		hasMonth: boolean;

		@doc("Whether the day component is required for the date.")
		hasDay: boolean;

		@doc("Minimum date range in milliseconds timestamp (e.g., 1735660800000 for 2025/1/1 00:00:00 UTC). If specified, use the first day of the month/year for the minimum value.")
		minDate?: int64;

		@doc("Maximum date range in milliseconds timestamp (e.g., 1748649599999 for 2025/5/31 23:59:59.999 UTC). If specified, use the last day of the month/year for the maximum value.")
		maxDate?: int64;
	}

	@doc("A choice with ID and name for choice-based questions.")
	model Choice {
		@doc("The unique identifier of the choice.")
		id: uuid;

		@doc("The name/text of the choice.")
		name: string;

		@doc("Optional description for the choice.")
		description?: string;
	}

	@doc("Response model for the detailed structure of a question.")
	model QuestionResponse {
		@doc("The question's unique identifier.")
		id: uuid;

		@doc("The section's id that the question belongs to.")
		sectionId: uuid;

		@doc("Whether the question is required to answer or not.")
		required: boolean;

		@doc("The type of the question.")
		type: QuestionTypes;

		@doc("What is the question.")
		title: string;

		@doc("More details of this question.")
		description: string;

		@doc("Available choice options for single_choice, multiple_choice, dropdown, and ranking questions.")
		choices?: Choice[];

		@doc("Available options for linear scale and rating questions.")
		scale?: ScaleOption;

		@doc("Available options for file upload questions.")
		uploadFile?: UploadFileOption;

		@doc("Available options for date questions.")
		date?: DateOption;

		@doc("Available options for OAuth connect questions.")
		oauthConnect?: CoreSystem.Auth.OAuthProviders;

		@doc("If set, choices are dynamically generated from answers to this question.")
		sourceId?: uuid;

		@doc("The creation timestamp of the question.")
		createdAt: utcDateTime;

		@doc("The updated timestamp of the question.")
		updatedAt: utcDateTime;
	}

	@doc("The request body for creating/updating a question.")
	@example(#{ required: true, type: QuestionTypes.shortText, title: "What's your name?", description: "Please enter your name", order: 1 })
	@example(#{ required: true, type: QuestionTypes.longText, title: "Tell us about yourself", description: "Please share your background and experience", order: 2 })
	@example(#{
		required: true,
		type: QuestionTypes.singleChoice,
		title: "What's your preferred work location?",
		description: "Choose one option",
		order: 3,
		choices: #[#{ name: "Remote" }, #{ name: "On-site" }, #{ name: "Hybrid" }],
	})
	@example(#{
		required: true,
		type: QuestionTypes.multipleChoice,
		title: "Which team you want to join???",
		description: "Pick one of your favorite!!!",
		order: 4,
		choices: #[#{ name: "Core System Team" }, #{ name: "Clustron Team" }, #{ name: "HPC Team" }],
	})
	@example(#{
		required: false,
		type: QuestionTypes.dropdown,
		title: "Select your experience level",
		description: "Choose from the dropdown",
		order: 5,
		choices: #[#{ name: "Beginner" }, #{ name: "Intermediate" }, #{ name: "Advanced" }, #{ name: "Expert" }],
	})
	@example(#{
		required: true,
		type: QuestionTypes.detailedMultipleChoice,
		title: "Which technologies are you familiar with?",
		description: "Select all that apply",
		order: 6,
		choices: #[#{ name: "TypeScript", description: "Modern programming language" }, #{ name: "React", description: "Frontend library" }, #{ name: "Node.js", description: "Backend runtime" }],
	})
	@example(#{ required: true, type: QuestionTypes.date, title: "When will you graduate?", description: "Please select your graduation date", order: 7, date: #{ hasYear: true, hasMonth: true, hasDay: true } })
	@example(#{ required: true, type: QuestionTypes.date, title: "Which year did you join?", description: "Select year and month only", order: 8, date: #{ hasYear: true, hasMonth: true, hasDay: false } })
	@example(#{
		required: false,
		type: QuestionTypes.uploadFile,
		title: "Upload your resume",
		description: "Please upload your resume in PDF format",
		order: 9,
		uploadFile: #{ allowedFileTypes: #[allowedFileTypes.pdf, allowedFileTypes.doc, allowedFileTypes.docx], maxFileAmount: 1, maxFileSizeLimit: FileSizeLimit.tenMB },
	})
	@example(#{
		required: true,
		type: QuestionTypes.linearScale,
		title: "Rate your experience level (1-5)",
		description: "How experienced are you?",
		order: 10,
		scale: #{ minVal: 1, maxVal: 5, minValueLabel: "No experience", maxValueLabel: "Very experienced" },
	})
	@example(#{ required: true, type: QuestionTypes.rating, title: "How satisfied are you?", description: "Rate your satisfaction level", order: 11, scale: #{ icon: "star", minVal: 1, maxVal: 5 } })
	@example(#{
		required: true,
		type: QuestionTypes.ranking,
		title: "Program Match",
		description: "Sort the following programs based on your preference.",
		order: 12,
		sourceId: "d290f1ee-6c54-4b01-90e6-d701748f0851",
	})
	@example(#{
		required: true,
		type: QuestionTypes.oauthConnect,
		title: "Connect your GitHub account",
		description: "Link your GitHub account to verify your identity",
		order: 13,
		oauthConnect: CoreSystem.Auth.OAuthProviders.github,
	})
	model QuestionRequest {
		@doc("Whether the question is required to answer or not.")
		required: boolean;

		@doc("The type of the question.")
		type: QuestionTypes;

		@doc("What is the question.")
		title: string;

		@doc("More details of this question.")
		description: string;

		@doc("What is the number of this question in the form.")
		order: int32;

		@doc("Available choice options for single_choice, multiple_choice, dropdown, and ranking questions.")
		choices?: ChoiceOption[];

		@doc("Available options for linear scale and rating questions.")
		scale?: ScaleOption;

		@doc("Available options for file upload questions.")
		uploadFile?: UploadFileOption;

		@doc("Available options for date questions.")
		date?: DateOption;

		@doc("Available options for OAuth connect questions.")
		oauthConnect?: CoreSystem.Auth.OAuthProviders;

		@doc("If set, choices are dynamically generated from answers to this question.")
		sourceId?: uuid;
	}

	@doc("Response model for listing all sections and questions in a form.")
	model ListSectionsResponse {
		sections: Section;
		questions: QuestionResponse[];
	}

	// form recipientUser
	@doc("The basic info of a user that can receive the form.")
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
	model RecipientSelectionResponse {
		recipients: RecipientUser[];
	}

	@doc("Response after publishing a form.")
	model FormPublishResponse {
		@doc("The URL to access the published form.")
		url: string;

		@doc("The visibility setting of the form. Public forms are visible to all logged-in users. Private forms require a direct link to access.")
		visibility: FormVisibility;
	}

	@doc("Response containing the Gmail address for Google Sheet permissions.")
	model GoogleSheetEmailResponse {
		@doc("The Gmail address that should be added to Google Sheet permissions so the system can modify the form.")
		email: string;
	}

	@doc("Request body for verifying a Google Sheet URL.")
	model GoogleSheetVerifyRequest {
		@doc("The Google Sheet URL provided by user.")
		googleSheetUrl: string;
	}

	@doc("Verification result for the given Google Sheet URL.")
	model GoogleSheetVerifyResponse {
		@doc("Indicates whether the Google Sheet URL is valid and accessible.")
		isValid: boolean;
	}

	@doc("A font definition used in form dressing.")
	model Font {
		@doc("The unique identifier of the font.")
		id: string;

		@doc("The display name of the font.")
		name: string;
	}
}
