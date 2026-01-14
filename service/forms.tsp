import "@typespec/http";
import "@typespec/openapi3";

using Http;
using OpenAPI;

@tag("Forms")
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
  @example(#{
    title: "Enter SDC Form",
    description: "If you want to join us, just fill in this form!",
    messageAfterSubmission: "Thank you for your submission!",
  })
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

    @doc("The google sheet url this from's responses will be sent to.")
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

    @doc("The google sheet url this from's responses will be sent to.")
    googleSheetUrl?: string;

    @doc("The visibility setting of the form. Public forms are visible to all logged-in users. Private forms require a direct link to access.")
    visibility: FormVisibility;

    @doc("The creation timestamp of the form.")
    createdAt: utcDateTime;

    @doc("The last updated timestamp of the form")
    updatedAt: utcDateTime;
  }

  @doc("The appearance/dressing configuration for a form.")
  @example(#{
    color: "#0066cc",
    headerFont: "LINESeedTW",
    questionFont: "LINESeedTW",
    textFont: "LINESeedTW",
  })
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

    @doc("The progress of this section.")
    progress: SectionProgress;

    @doc("Section description.")
    description?: string;
  }

  @doc("The current progress of a section")
  enum SectionProgress {
    @doc("User hasn't started or not finished.")
    draft: "DRAFT",

    @doc("User has completed/passed this response.")
    submitted: "SUBMITTED"
  }

  @doc("The current status of form ")
  enum FormStatus {
    draft: "DRAFT",
    published: "PUBLISHED",
  }

  @doc("The visibility setting of a form. Public forms are visible to all logged-in users. Private forms require a direct link to access.")
  enum FormVisibility {
    @doc("Public: visible to all logged-in users")
    public: "public",

    @doc("Private: requires a direct link to access")
    private: "private",
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
    
    @doc("Multiple choice with detailed checkboxes (more spacing/styling)")
    detailedMultipleChoice: "DETAILED_MULTIPLE_CHOICE",
    
    @doc("Date picker")
    date: "DATE",
    
    @doc("File upload")
    uploadFile: "UPLOAD_FILE",
    
    @doc("Linear scale/rating (1-5, 1-10, etc.)")
    linearScale: "LINEAR_SCALE",
    
    @doc("Ranking/ordering items by preference")
    ranking: "RANKING",

    @doc("OAuth account connection for external service authentication")
    oauthConnect: "OAUTH_CONNECT",
  }

  @doc("A choice for creating/updating OAuth connect questions.")
  model OauthConnectOption {
    @doc("The external service name (e.g., 'Google', 'GitHub').")
    serviceName: string;
  }

  @doc("A choice with ID for OAuth connect questions.")
  model OauthConnect {
    @doc("The unique identifier of the choice.")
    id: uuid;

    ...OauthConnectOption;
  }

  @doc("A choice for creating/updating file upload questions.")
  model UploadFileOption {
    @doc("Allowed file types/extensions (e.g., ['pdf', 'docx']).")
    allowedFileTypes: string[];

    @doc("Maximum number of files that can be uploaded.")
    maxFileAmount: int32;

    @doc("Maximum file size in megabytes.")
    maxFileSizeMB: int32;
  }

  @doc("A choice with ID for file upload questions.")
  model UploadFile {
    @doc("The unique identifier of the choice.")
    id: uuid;

    ...UploadFileOption;
  }
  
  @doc("A choice for creating/updating linear scale questions.")
  model LinearScaleOption {
    @doc("Background icon for the linear scale option.")
    icon: string;

    @doc("Minimum value of the linear scale.")
    min: int32;

    @doc("Maximum value of the linear scale.")
    max: int32;

    @doc("Label for the minimum value.")
    minValueLabel?: string;

    @doc("Label for the maximum value.")
    maxValueLabel?: string;
  }

  @doc("A choice with ID for linear scale questions.")
  model LinearScale {
    @doc("The unique identifier of the choice.")
    id: uuid;

    ...LinearScaleOption;
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

    ...ChoiceOption;
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
    
    @doc("Available choice options for linear scale questions.")
    linearScale?: LinearScale;
    
    @doc("Available options for file upload questions.")
    uploadFile?: UploadFile;

    @doc("Available options for OAuth connect questions.")
    oauthConnect?: OauthConnect;

    @doc("If set, choices are dynamically generated from answers to this question.")
    sourceQuestionId?: uuid;

    @doc("The creation timestamp of the question.")
    createdAt: utcDateTime;

    @doc("The updated timestamp of the question.")
    updatedAt: utcDateTime;
  }

  @doc("The request body for creating/updating a question.")
  @example(#{
    required: true,
    type: QuestionTypes.shortText,
    title: "What's your name?",
    description: "Please enter your name",
    order: 1,
  })
  @example(#{
    required: true,
    type: QuestionTypes.detailedMultipleChoice,
    title: "Which team you want to join???",
    description: "Pick one of your favorite!!!",
    order: 2,
    choices: #[
      #{ name: "Core System Team" },
      #{ name: "Clustron Team" },
      #{ name: "HPC Team" }
    ],
  })
  @example(#{
    required: true,
    type: QuestionTypes.multipleChoice,
    title: "Program Match",
    description: "Sort the following programs based on your preference.",
    order: 3,
    sourceQuestionId: "d290f1ee-6c54-4b01-90e6-d701748f0851",
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
    
    @doc("Available choice options for linear scale questions.")
    linearScale?: LinearScaleOption;

    @doc("Available options for file upload questions.")
    uploadFile?: UploadFileOption; 

    @doc("Available options for OAuth connect questions.")
    oauthConnect?: OauthConnectOption;

    @doc("If set, choices are dynamically generated from answers to this question.")
    sourceQuestionId?: uuid;
  }

  @doc("Response model for listing all sections and questions in a form.")
  @example(#{
    section: #{
      id: "eff59c94-cb72-45c9-9431-c0778613b806",
      formId: "ee0741d2-17bb-49b8-ab8c-d11726390000",
      title: "Group Info",
      progress: SectionProgress.draft,
      description: "Welcome to SDC, the Software Development Club!",
    },
    questions: #[
      #{
        id: "0f9e8d7c-6b5a-4321-0fed-cba987654321",
        sectionId: "eff59c94-cb72-45c9-9431-c0778613b806",
        required: true,
        type: QuestionTypes.detailedMultipleChoice,
        title: "Which team you want to join???",
        description: "Pick one of your favorite!!!",
        choices: #[
          #{ id: "11111111-2222-3333-4444-555555555555", name: "Core System Team" },
          #{ id: "66666666-7777-8888-9999-000000000000", name: "Clustron Team" },
          #{ id: "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee", name: "HPC Team" }
        ],
        createdAt: utcDateTime.fromISO("2024-01-01T12:00:00Z"),
        updatedAt: utcDateTime.fromISO("2024-01-01T12:00:00Z"),
      }
    ],
  })
  model ListSectionsResponse {
    section: Section;
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
  op updateQuestion(
    @path sectionId: uuid,
    @path questionId: uuid,
    @body q: QuestionRequest,
  ): QuestionResponse;

  @doc("Delete an existing question by its unique identifier.")
  @route("/sections/{sectionId}/questions/{questionId}")
  @delete
  op deleteQuestion(@path sectionId: uuid, @path questionId: uuid): {
    @statusCode statusCode: 204;
  };

  @doc("List all the questions of the sections in the form.")
  @route("/forms/{id}/sections")
  @get
  op listQuestions(@path id: uuid): ListSectionsResponse[];

  @doc("Upload a cover image for a form. The frontend should send images in WebP format with max-width/height: 1800px and quality 80%.")
  @route("/forms/{id}/cover")
  @post
  op uploadFormCoverImage(
    @path id: uuid,
    @header("content-type") contentType: "multipart/form-data",
    @multipartBody body: FormCoverUploadRequest,
  ): FormCoverUploadResponse;

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
  op previewRecipients(
    @body req: RecipientSelectionRequest,
  ): RecipientSelectionResponse;

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
}
