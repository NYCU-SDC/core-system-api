namespace CoreSystem.Unit {
	@doc("The completion status of the form for the user")
	enum UserFormStatus {
		not_started: "NOT_STARTED",
		in_progress: "IN_PROGRESS",
		completed: "COMPLETED",
	}

	@doc("Response model for listing user forms with status")
	@example(#{
		id: "9a843aa0-8451-4e3b-b6a0-8c0e994e9040",
		title: "SDC 2025 Recruitment Form",
		deadline: utcDateTime.fromISO("2025-03-31T23:59:59Z"),
		status: UserFormStatus.in_progress,
		responseIds: #["a12b3c4d-5e6f-7g8h-9i0j-k1l2m3n4o5p6"],
	})
	model UserForm {
		@doc("The unique identifier of the form")
		id: uuid;

		@doc("The title of the form")
		title: string;

		@doc("The deadline of the form")
		deadline: utcDateTime;

		@doc("The completion status of the form for the current user")
		status: UserFormStatus;

		@doc("The unique identifiers of the user's responses to the form, if they exist")
		responseIds?: uuid[];
	}
}
