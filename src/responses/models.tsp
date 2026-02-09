using Http;

namespace CoreSystem.Responses {
	@example(#{ questionId: "ee894524-4bd8-4a64-8fd2-a53b39ca94cd", questionType: CoreSystem.Forms.QuestionTypes.shortText, value: #["John Doe"] })
	@example(#{
		questionId: "2b2bc4f4-71c1-478b-9e36-516eac6b36c3",
		questionType: CoreSystem.Forms.QuestionTypes.multipleChoice,
		value: #["f421cfc2-2b84-4da9-9629-011af609935a", "2ca86a6d-7735-4f17-8676-29b4724b524f"],
	})
	@doc("Request model for submitting an individual answer")
	model AnswerJSON {
		@doc("The question being answered.")
		questionId: uuid;

		@doc("The type of the question being answered.")
		questionType:
			| CoreSystem.Forms.QuestionTypes.shortText
			| CoreSystem.Forms.QuestionTypes.longText
			| CoreSystem.Forms.QuestionTypes.singleChoice
			| CoreSystem.Forms.QuestionTypes.multipleChoice
			| CoreSystem.Forms.QuestionTypes.dropdown
			| CoreSystem.Forms.QuestionTypes.detailedMultipleChoice
			| CoreSystem.Forms.QuestionTypes.ranking
			| CoreSystem.Forms.QuestionTypes.hyperlink;

		@doc("The answer value (format depends on questionType from questionId).")
		value: string[];
	}

	@example(#{ questionId: "2b2bc4f4-71c1-478b-9e36-516eac6b36c3", questionType: CoreSystem.Forms.QuestionTypes.linearScale, value: 4 })
	@doc("Request model for submitting an individual scale answer")
	model ScaleAnswerJSON {
		@doc("The question being answered.")
		questionId: uuid;

		@doc("The type of the scale question being answered.")
		questionType: CoreSystem.Forms.QuestionTypes.linearScale | CoreSystem.Forms.QuestionTypes.rating;

		@doc("The answer value for scale question.")
		value: int32;
	}

	@example(#{ questionId: "2b2bc4f4-71c1-478b-9e36-516eac6b36c3", questionType: CoreSystem.Forms.QuestionTypes.date, date: 1735689600, hasYear: true, hasMonth: true, hasDay: true })
	@example(#{ questionId: "2b2bc4f4-71c1-478b-9e36-516eac6b36c3", questionType: CoreSystem.Forms.QuestionTypes.date, date: 1719792000, hasYear: true, hasMonth: true, hasDay: false })
	@doc("Request model for submitting a date answer. Date is stored as Unix timestamp (seconds since epoch). For partial dates (e.g., year-month only), the day defaults to 01.")
	model DateAnswerJSON {
		@doc("The question being answered.")
		questionId: uuid;

		@doc("The type of the question being answered.")
		questionType: CoreSystem.Forms.QuestionTypes.date;

		@doc("The date value as utcDateTime (e.g., 2025-01-01T00:00:00Z for 2025/1/1 00:00:00 UTC). For partial dates, use the first day of the month/year.")
		date: utcDateTime;

		@doc("Whether the year component is included in this date answer.")
		hasYear: boolean;

		@doc("Whether the month component is included in this date answer.")
		hasMonth: boolean;

		@doc("Whether the day component is included in this date answer.")
		hasDay: boolean;
	}

	@example(#{
		questionId: "2b2bc4f4-71c1-478b-9e36-516eac6b36c3",
		questionType: CoreSystem.Forms.QuestionTypes.oauthConnect,
		provider: CoreSystem.Auth.OAuthProviders.google,
		callback: "https://example.com/oauth/callback",
	})
	@doc("Request model for initiating an OAuth answer")
	model OauthAnswerRequest {
		@doc("The question being answered.")
		questionId: uuid;

		@doc("The type of the question being answered.")
		questionType: CoreSystem.Forms.QuestionTypes.oauthConnect;

		@doc("The OAuth provider to use.")
		provider: CoreSystem.Auth.OAuthProviders;

		@doc("The callback URL for the OAuth flow.")
		callback: string;

		@doc("The redirect URL after OAuth completion.")
		redirect?: string;
	}

	@example(#{ questionId: "2b2bc4f4-71c1-478b-9e36-516eac6b36c3", avatar_url: "https://example.com/avatar.jpg", username: "JohnDoe" })
	@doc("Response model for an OAuth answer")
	model OauthAnswerJSON {
		@doc("The question being answered.")
		questionId: uuid;

		@doc("The avatar URL from the OAuth provider.")
		avatar_url: string;

		@doc("The username from the OAuth provider.")
		username: string;
	}

	@doc("Request model for update or submit the form response.")
	@example(#{
		answers: #[
			#{ questionId: "ee894524-4bd8-4a64-8fd2-a53b39ca94cd", questionType: CoreSystem.Forms.QuestionTypes.shortText, value: #["John Doe"] },
			#{ questionId: "2b2bc4f4-71c1-478b-9e36-516eac6b36c3", questionType: CoreSystem.Forms.QuestionTypes.linearScale, value: 4 },
			#{ questionId: "3c3cd5f5-82d2-589c-af47-627fbd7c47d4", questionType: CoreSystem.Forms.QuestionTypes.date, date: 1735689600, hasYear: true, hasMonth: true, hasDay: true },
			#{
				questionId: "3c3cd5f5-82d2-589c-af47-627fbd7c47d4",
				questionType: CoreSystem.Forms.QuestionTypes.oauthConnect,
				provider: CoreSystem.Auth.OAuthProviders.google,
				callback: "https://example.com/oauth/callback",
			}
		],
	})
	model AnswersRequest {
		@doc("The answers to be saved. Can contain a partial subset for drafts or the full set for submission.")
		answers: (AnswerJSON | ScaleAnswerJSON | DateAnswerJSON | OauthAnswerRequest)[];
	}

	@doc("Request model for uploading files as answers to a specific question in a response.")
	model QuestionFilesUploadRequest {
		@doc("The file(s) being uploaded.")
		files: HttpPart<bytes[]>;
	}

	@doc("Response model for the uploaded files")
	model QuestionFilesUploadResponse {
		@doc("The temporary full URLs of the uploaded files.")
		fileUrls: string[];
	}

	@doc("Response model for creating a form response")
	model CreateResponse {
		@doc("The response's unique identifier.")
		id: uuid;
	}

	@doc("Response model for a single response in list view")
	model ResponseJSON {
		@doc("The response's unique identifier.")
		id: uuid;

		@doc("The user who submitted this response.")
		submittedBy: uuid;

		@doc("The creation timestamp of the response.")
		createdAt: utcDateTime;

		@doc("The last updated timestamp of the response.")
		updatedAt: utcDateTime;
	}

	@doc("Response model for listing all responses of a form")
	model ListResponse {
		@doc("The form ID.")
		formId: uuid;

		@doc("All responses for this form.")
		responses: ResponseJSON[];
	}

	@doc("Model for a question with its answer in preview view")
	model PreviewQuestion {
		@doc("The question details.")
		question: CoreSystem.Forms.QuestionResponse;

		@doc("The formatted answer value for display.")
		displayValue: string;

		@doc("The structured answer data for submission. Null if not answered yet.")
		answerData?: AnswerJSON | ScaleAnswerJSON | DateAnswerJSON | OauthAnswerJSON;
	}

	@doc("Model for a single section in preview view")
	model PreviewSection {
		@doc("The section title.")
		sectionTitle: string;

		@doc("The answering progress of this section.")
		progress: SectionProgress;

		@doc("All questions with their answers in this section.")
		questionAnswerPairs: PreviewQuestion[];
	}

	@doc("Response model for getting a specific form response")
	model GetFormResponse {
		@doc("The response's unique identifier.")
		id: uuid;

		@doc("The current answering progress of the response.")
		progress: ResponseProgress;

		@doc("The form that this response belongs to.")
		formId: uuid;

		@doc("All questions with their answers for this response.")
		questionAnswerPairs: PreviewSection[];
	}

	@example(#{
		id: "a269d06a-5f41-4d1f-a0a1-3d4007ffd633",
		questionAnswerPair: #{
			questionId: "2b2bc4f4-71c1-478b-9e36-516eac6b36c3",
			questionType: CoreSystem.Forms.QuestionTypes.ranking,
			value: #["Full Stack Intro Training", "Full Stack Advanced Training"],
		},
	})
	@doc("Response model for getting an answer of a specific question.")
	model GetQuestionResponse {
		@doc("The response's unique identifier.")
		id: uuid;

		@doc("A question with its answer for this response..")
		questionAnswerPair: AnswerJSON | ScaleAnswerJSON | DateAnswerJSON;
	}

	@doc("The current progress of the response.")
	enum ResponseProgress {
		@doc("User hasn't started or not finished.")
		draft: "DRAFT",

		@doc("User has completed/passed this response.")
		submitted: "SUBMITTED",
	}

	@doc("Response model for a single answer in question answers view")
	model AnswerResponse {
		@doc("The answer's unique identifier.")
		id: uuid;

		@doc("The response this answer belongs to.")
		responseId: uuid;

		@doc("The user who submitted this answer.")
		submittedBy: uuid;

		@doc("The answer data. Type depends on the question type.")
		answer: AnswerJSON | ScaleAnswerJSON | DateAnswerJSON | OauthAnswerJSON;

		@doc("The creation timestamp of the answer.")
		createdAt: utcDateTime;

		@doc("The last updated timestamp of the answer.")
		updatedAt: utcDateTime;
	}

	@doc("Response model for getting all answers for a specific question")
	model AnswersResponse {
		@doc("The question details.")
		question: CoreSystem.Forms.QuestionResponse;

		@doc("All answers for this question.")
		answers: AnswerResponse[];
	}

	@doc("Response model for a single section in response sections view")
	model ResponseSections {
		@doc("Unique identifier.")
		id: uuid;

		@doc("Section title (e.g., 'Group Info').")
		title: string;

		@doc("The answering progress of this section.")
		progress: SectionProgress;
	}

	@doc("The current progress of a section")
	enum SectionProgress {
		@doc("User hasn't started or not finished.")
		draft: "DRAFT",

		@doc("User has completed/passed this response.")
		submitted: "SUBMITTED",
	}

	@example(#{
		sections: #[
			#{ id: "a1b2c3d4-e5f6-7890-abcd-ef1234567890", title: "Group Info", progress: SectionProgress.submitted },
			#{ id: "0f9e8d7c-6b5a-4321-0fed-cba987654321", title: "Self Introduction", progress: SectionProgress.draft }
		],
	})
	@doc("Response model for listing all sections of a response")
	model ListSectionResponse {
		@doc("The section list of the response.")
		sections: ResponseSections[];
	}
}
