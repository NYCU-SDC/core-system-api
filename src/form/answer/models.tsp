using Http;

namespace CoreSystem.Responses {
	@example(#{ questionId: "ee894524-4bd8-4a64-8fd2-a53b39ca94cd", questionType: CoreSystem.Forms.QuestionTypes.shortText, value: "John Doe" })
	model StringAnswer {
		@doc("The question being answered.")
		questionId: uuid;

		@doc("The type of the question being answered.")
		questionType: CoreSystem.Forms.QuestionTypes.shortText | CoreSystem.Forms.QuestionTypes.longText | CoreSystem.Forms.QuestionTypes.hyperlink;

		@doc("The answer value (format depends on questionType from questionId).")
		value: string;
	}

	@example(#{
		questionId: "2b2bc4f4-71c1-478b-9e36-516eac6b36c3",
		questionType: CoreSystem.Forms.QuestionTypes.multipleChoice,
		value: #["f421cfc2-2b84-4da9-9629-011af609935a", "2ca86a6d-7735-4f17-8676-29b4724b524f"],
	})
	@doc("Request model for submitting an individual answer")
	model StringArrayAnswer {
		@doc("The question being answered.")
		questionId: uuid;

		@doc("The type of the question being answered.")
		questionType:
			| CoreSystem.Forms.QuestionTypes.singleChoice
			| CoreSystem.Forms.QuestionTypes.multipleChoice
			| CoreSystem.Forms.QuestionTypes.dropdown
			| CoreSystem.Forms.QuestionTypes.detailedMultipleChoice
			| CoreSystem.Forms.QuestionTypes.ranking;

		@doc("The answer value (format depends on questionType from questionId).")
		value: string[];
	}

	@example(#{ questionId: "2b2bc4f4-71c1-478b-9e36-516eac6b36c3", questionType: CoreSystem.Forms.QuestionTypes.date, value: utcDateTime.fromISO("2024-05-06T12:20-12Z") })
	model DateAnswer {
		@doc("The question being answered.")
		questionId: uuid;

		@doc("The type of the question being answered.")
		questionType: CoreSystem.Forms.QuestionTypes.date;

		@doc("The answer value for date question in ISO format (e.g., '2024-12-31').")
		value: utcDateTime;
	}

	@example(#{ questionId: "2b2bc4f4-71c1-478b-9e36-516eac6b36c3", questionType: CoreSystem.Forms.QuestionTypes.linearScale, value: 4 })
	@doc("Request model for submitting an individual scale answer")
	model ScaleAnswer {
		@doc("The question being answered.")
		questionId: uuid;

		@doc("The type of the scale question being answered.")
		questionType: CoreSystem.Forms.QuestionTypes.linearScale | CoreSystem.Forms.QuestionTypes.rating;

		@doc("The answer value for scale question.")
		value: int32;
	}

	@example(#{
		questionId: "2b2bc4f4-71c1-478b-9e36-516eac6b36c3",
		questionType: CoreSystem.Forms.QuestionTypes.oauthConnect,
		value: #{ username: "johndoe", email: "johndoe@example.com", avatarUrl: "https://example.com/avatar.jpg", provider: "google", providerId: "1234567890" },
	})
	@doc("Response model for an OAuth answer")
	model OauthAnswer {
		@doc("The question being answered.")
		questionId: uuid;

		@doc("The type of the question being answered.")
		questionType: CoreSystem.Forms.QuestionTypes.oauthConnect;

		value: {
			@doc("The OAuth provider, e.g., 'google', 'github'.")
			provider: string;

			@doc("The unique identifier from the OAuth provider for the connected account.")
			providerId: string;

			@doc("The avatar URL from the OAuth provider.")
			avatarUrl: string;

			@doc("The email from the OAuth provider.")
			email: string;

			@doc("The username from the OAuth provider.")
			username: string;
		};
	}

	@doc("Request model for update or submit the form response.")
	@example(#{
		answers: #[
			#{ questionId: "ee894524-4bd8-4a64-8fd2-a53b39ca94cd", questionType: CoreSystem.Forms.QuestionTypes.shortText, value: "John Doe" },
			#{ questionId: "2b2bc4f4-71c1-478b-9e36-516eac6b36c3", questionType: CoreSystem.Forms.QuestionTypes.linearScale, value: 4 }
		],
	})
	model AnswersRequest {
		@doc("The answers to be saved. Can contain a partial subset for drafts or the full set for submission.")
		answers: (StringAnswer | StringArrayAnswer | ScaleAnswer | DateAnswer)[];
	}

	@doc("Request model for uploading files as answers to a specific question in a response.")
	model QuestionFilesUploadRequest {
		@doc("The file(s) being uploaded.")
		files: HttpPart<bytes[]>;
	}

	@doc("Response model for the uploaded files and auto-created answer")
	@example(#{
		id: "a12b3c4d-5e6f-7a8b-9c0d-e1f2a3b4c5d6",
		answer: #{
			createdAt: utcDateTime.fromISO("2025-02-15T10:00:00Z"),
			updatedAt: utcDateTime.fromISO("2025-02-17T16:45:00Z"),
			responseId: "a12b3c4d-5e6f-7a8b-9c0d-e1f2a3b4c5d6",
			answer: #{ questionId: "ee894524-4bd8-4a64-8fd2-a53b39ca94cd", questionType: CoreSystem.Forms.QuestionTypes.shortText, value: "John Doe" },
			displayValue: "John Doe",
		},
	})
	model QuestionFilesUploadResponse {
		@doc("The response's unique identifier.")
		id: uuid;

		@doc("The auto-created/updated answer with file URLs.")
		answer: AnswerPayload;
	}

	@example(#{
		id: "a12b3c4d-5e6f-7a8b-9c0d-e1f2a3b4c5d6",
		answer: #{
			createdAt: utcDateTime.fromISO("2025-02-15T10:00:00Z"),
			updatedAt: utcDateTime.fromISO("2025-02-17T16:45:00Z"),
			responseId: "a12b3c4d-5e6f-7a8b-9c0d-e1f2a3b4c5d6",
			answer: #{ questionId: "ee894524-4bd8-4a64-8fd2-a53b39ca94cd", questionType: CoreSystem.Forms.QuestionTypes.shortText, value: "John Doe" },
			displayValue: "John Doe",
		},
	})
	model GetQuestionResponse {
		@doc("Response ID that this question answer belongs to.")
		id: uuid;

		answer: AnswerPayload;
	}

	@doc("Contains the question details and the corresponding answer for a specific question in a response")
	@example(#{
		question: #{
			id: "ee894524-4bd8-4a64-8fd2-a53b39ca94cd",
			sectionId: "b23f2668-c2dc-4213-88fe-eceedff46398",
			required: true,
			type: CoreSystem.Forms.QuestionTypes.shortText,
			title: "What's your name?",
			description: "Please enter your full name",
			createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
			updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
		},
		payload: #{
			createdAt: utcDateTime.fromISO("2025-02-15T10:00:00Z"),
			updatedAt: utcDateTime.fromISO("2025-02-17T16:45:00Z"),
			responseId: "a12b3c4d-5e6f-7a8b-9c0d-e1f2a3b4c5d6",
			answer: #{ questionId: "ee894524-4bd8-4a64-8fd2-a53b39ca94cd", questionType: CoreSystem.Forms.QuestionTypes.shortText, value: "John Doe" },
			displayValue: "John Doe",
		},
	})
	model AnswersDetail {
		@doc("The question details.")
		question: CoreSystem.Forms.QuestionResponse;

		@doc("All answers for this question, if user has not filled this question, this field will be null.")
		payload: AnswerPayload;
	}

	@doc("Contains the details of an answer for a specific question in a response")
	@example(#{
		createdAt: utcDateTime.fromISO("2025-02-15T10:00:00Z"),
		updatedAt: utcDateTime.fromISO("2025-02-17T16:45:00Z"),
		responseId: "a12b3c4d-5e6f-7a8b-9c0d-e1f2a3b4c5d6",
		answer: #{ questionId: "ee894524-4bd8-4a64-8fd2-a53b39ca94cd", questionType: CoreSystem.Forms.QuestionTypes.shortText, value: "John Doe" },
		displayValue: "John Doe",
	})
	model AnswerPayload {
		@doc("The creation timestamp of the answer.")
		createdAt: utcDateTime;

		@doc("The last updated timestamp of the answer.")
		updatedAt: utcDateTime;

		@doc("The response this answer belongs to.")
		responseId: uuid;

		@doc("The answer data. Type depends on the question type.")
		answer: StringAnswer | StringArrayAnswer | ScaleAnswer | DateAnswer | OauthAnswer;

		@doc("The formatted answer value for display.")
		displayValue: string;
	}
}
