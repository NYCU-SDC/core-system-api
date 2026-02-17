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
		answers: (StringAnswer | StringArrayAnswer | ScaleAnswer | DateAnswer)[];
	}

	@doc("Response model for a single response in list view")
	model Response {
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
		responses: Response[];
	}

	@doc("Response model for getting a specific form response")
	model GetFormResponse {
		@doc("The response's unique identifier.")
		id: uuid;

		@doc("The form that this response belongs to.")
		formId: uuid;

		@doc("The current answering progress of the response.")
		progress: ResponseProgress;

		@doc("The section list of the response, order by the form workflow.")
		sections: ResponseSections[];
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
		answerDetails: AnswersDetail[];
	}

	@doc("The current progress of a section, notStarted -> draft -> completed, or skipped if user doesn't need to answer this section.")
	enum SectionProgress {
		@doc("User doesn't need to answer this section.")
		skipped: "SKIPPED",

		@doc("User is not started to answer this section, no one question in this section is answered.")
		notStarted: "NOT_STARTED",

		@doc("User hasn't started or not finished.")
		draft: "DRAFT",

		@doc("User has passed all validations in this section.")
		completed: "COMPLETED",
	}
}
