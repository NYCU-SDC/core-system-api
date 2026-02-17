using Http;

namespace CoreSystem.Responses {
	@doc("Response model for creating a form response")
	@example(#{ id: "a12b3c4d-5e6f-7a8b-9c0d-e1f2a3b4c5d6" })
	model CreateResponse {
		@doc("The response's unique identifier.")
		id: uuid;
	}

	@doc("Response model for updating a form response")
	@example(#{
		id: "a12b3c4d-5e6f-7a8b-9c0d-e1f2a3b4c5d6",
		updatedAt: utcDateTime.fromISO("2025-02-17T16:45:00Z"),
		answers: #[],
	})
	model UpdateResponse {
		@doc("The response's unique identifier.")
		id: uuid;

		@doc("The last updated timestamp of the response.")
		updatedAt: utcDateTime;

		@doc("The updated answer data.")
		answers: (StringAnswer | StringArrayAnswer | ScaleAnswer | DateAnswer)[];
	}

	@doc("Response model for a single response in list view")
	@example(#{
		id: "a12b3c4d-5e6f-7a8b-9c0d-e1f2a3b4c5d6",
		submittedBy: "3c5fa073-7b97-43a3-bc44-ddc98f390a08",
		createdAt: utcDateTime.fromISO("2025-02-15T10:00:00Z"),
		updatedAt: utcDateTime.fromISO("2025-02-17T16:45:00Z"),
	})
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
	@example(#{ formId: "9a843aa0-8451-4e3b-b6a0-8c0e994e9040", responses: #[] })
	model ListResponse {
		@doc("The form ID.")
		formId: uuid;

		@doc("All responses for this form.")
		responses: Response[];
	}

	@doc("Response model for getting a specific form response")
	@example(#{
		id: "a12b3c4d-5e6f-7a8b-9c0d-e1f2a3b4c5d6",
		formId: "9a843aa0-8451-4e3b-b6a0-8c0e994e9040",
		progress: ResponseProgress.draft,
		sections: #[],
	})
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
	@example(#{
		id: "b23f2668-c2dc-4213-88fe-eceedff46398",
		title: "Personal Information",
		progress: SectionProgress.draft,
		answerDetails: #[],
	})
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
