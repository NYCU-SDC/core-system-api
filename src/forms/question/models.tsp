using Http;

namespace CoreSystem.Forms {
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

		@doc("Linear scale/rating (0-10 or 1-10, etc.)")
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

		@doc("Minimum value of the linear scale, can be 0 or 1.")
		minVal: int32;

		@doc("Maximum value of the linear scale, can be between 2 and 10.")
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
	@example(#{ required: true, type: QuestionTypes.date, title: "When will you graduate?", description: "Please select your graduation date", order: 7 })
	@example(#{
		required: false,
		type: QuestionTypes.uploadFile,
		title: "Upload your resume",
		description: "Please upload your resume in PDF format",
		order: 8,
		uploadFile: #{ allowedFileTypes: #[allowedFileTypes.pdf, allowedFileTypes.doc, allowedFileTypes.docx], maxFileAmount: 1, maxFileSizeLimit: FileSizeLimit.tenMB },
	})
	@example(#{
		required: true,
		type: QuestionTypes.linearScale,
		title: "Rate your experience level (1-5)",
		description: "How experienced are you?",
		order: 9,
		scale: #{ minVal: 1, maxVal: 5, minValueLabel: "No experience", maxValueLabel: "Very experienced" },
	})
	@example(#{ required: true, type: QuestionTypes.rating, title: "How satisfied are you?", description: "Rate your satisfaction level", order: 10, scale: #{ icon: "star", minVal: 1, maxVal: 5 } })
	@example(#{
		required: true,
		type: QuestionTypes.ranking,
		title: "Program Match",
		description: "Sort the following programs based on your preference.",
		order: 11,
		sourceId: "d290f1ee-6c54-4b01-90e6-d701748f0851",
	})
	@example(#{
		required: true,
		type: QuestionTypes.oauthConnect,
		title: "Connect your GitHub account",
		description: "Link your GitHub account to verify your identity",
		order: 12,
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

		@doc("Available options for OAuth connect questions.")
		oauthConnect?: CoreSystem.Auth.OAuthProviders;

		@doc("If set, choices are dynamically generated from answers to this question.")
		sourceId?: uuid;
	}
}
