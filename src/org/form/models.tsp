namespace CoreSystem.Unit {
	@doc("The completion status of the form for the user")
	enum UserFormStatus {
		not_started: "NOT_STARTED",
		in_progress: "IN_PROGRESS",
		completed: "COMPLETED",
	}

	@doc("Response model for listing user forms with status")
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
