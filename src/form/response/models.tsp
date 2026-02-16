using Http;

namespace CoreSystem.Responses {
	@doc("Response model for creating a form response")
	model CreateResponse {
		@doc("The response's unique identifier.")
		id: uuid;
	}

	@doc("Response model for updating a form response")
	model UpdateResponse {
		@doc("The response's unique identifier.")
		id: uuid;

		@doc("The last updated timestamp of the response.")
		updatedAt: utcDateTime;

		@doc("The updated answer data.")
		answers: (StringArrayAnswer | ScaleAnswer | OauthAnswer)[];
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

	@doc("The current progress of the response.")
	enum ResponseProgress {
		@doc("User hasn't started or not finished.")
		draft: "DRAFT",

		@doc("User has completed/passed this response.")
		submitted: "SUBMITTED",
	}

	@doc("Response model for a single section in response sections view")
	model ResponseSections {
		@doc("Unique identifier.")
		id: uuid;

		@doc("Section title (e.g., 'Group Info').")
		title: string;

		@doc("The answering progress of this section.")
		progress: SectionProgress;

		@doc("The questions of the section.")
		questions: CoreSystem.Forms.QuestionResponse[];
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
			#{ id: "a1b2c3d4-e5f6-7890-abcd-ef1234567890", title: "Group Info", progress: SectionProgress.submitted, questions: #[] },
			#{ id: "0f9e8d7c-6b5a-4321-0fed-cba987654321", title: "Self Introduction", progress: SectionProgress.draft, questions: #[] }
		],
	})
	@doc("Response model for listing all sections of a response")
	model ListSectionResponse {
		@doc("The section list of the response.")
		sections: ResponseSections[];
	}
}
