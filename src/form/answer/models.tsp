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
		value: #{ username: "johndoe", avatarUrl: "https://example.com/avatar.jpg" },
	})
	@doc("Response model for an OAuth answer")
	model OauthAnswer {
		@doc("The question being answered.")
		questionId: uuid;

		@doc("The type of the question being answered.")
		questionType: CoreSystem.Forms.QuestionTypes.oauthConnect;

		value: {
			@doc("The avatar URL from the OAuth provider.")
			avatarUrl: string;

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
		answers: (StringAnswer | StringArrayAnswer | ScaleAnswer)[];
	}

	@doc("Request model for uploading files as answers to a specific question in a response.")
	model QuestionFilesUploadRequest {
		@doc("The file(s) being uploaded.")
		files: HttpPart<bytes[]>;
	}

	@doc("Response model for the uploaded files and auto-created answer")
	model QuestionFilesUploadResponse {
		@doc("The response's unique identifier.")
		id: uuid;

		@doc("The auto-created/updated answer with file URLs.")
		questionAnswerPair: StringArrayAnswer;
	}

	@doc("Model for a question with its answer in preview view")
	model PreviewQuestion {
		@doc("The question details.")
		question: CoreSystem.Forms.QuestionResponse;

		@doc("The formatted answer value for display.")
		displayValue: string;

		@doc("The structured answer data for submission. Null if not answered yet.")
		answerData?: StringArrayAnswer | ScaleAnswer | OauthAnswer;
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
		questionAnswerPair: StringArrayAnswer;
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
		answer: StringArrayAnswer | ScaleAnswer | OauthAnswer;

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
}
