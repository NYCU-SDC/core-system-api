namespace CoreSystem.Unit {
	@doc("The completion status of the form for the user")
	enum UserFormStatus {
		not_started: "NOT_STARTED",
		in_progress: "IN_PROGRESS",
		completed: "COMPLETED",
	}

	@doc("Response model for listing user forms with status")
	@example(#{
		id: "5a1b2c3d-4e5f-6789-0abc-def123456789",
		title: "Annual Survey 2026",
		deadline: utcDateTime.fromISO("2026-03-31T23:59:59Z"),
		status: UserFormStatus.not_started,
	})
	@example(#{
		id: "9a843aa0-8451-4e3b-b6a0-8c0e994e9040",
		title: "SDC 2025 Recruitment Form",
		deadline: utcDateTime.fromISO("2025-03-31T23:59:59Z"),
		status: UserFormStatus.in_progress,
		responseIds: #["a12b3c4d-5e6f-7a8b-9c0d-e1f2a3b4c5d6"],
	})
	@example(#{
		id: "7f6e5d4c-3b2a-1098-7654-321fedcba098",
		title: "Member Information Update 2025",
		deadline: utcDateTime.fromISO("2025-02-15T23:59:59Z"),
		status: UserFormStatus.completed,
		responseIds: #["b23c4d5e-6f7a-8b9c-0d1e-f2a3b4c5d6e7", "c34d5e6f-7a8b-9c0d-1e2f-a3b4c5d6e7f8"],
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

	@doc("Response model for listing all forms of current user")
	@example(#[
		#{
			id: "5a1b2c3d-4e5f-6789-0abc-def123456789",
			title: "Annual Survey 2026",
			deadline: utcDateTime.fromISO("2026-03-31T23:59:59Z"),
			status: UserFormStatus.not_started,
		},
		#{
			id: "9a843aa0-8451-4e3b-b6a0-8c0e994e9040",
			title: "SDC 2025 Recruitment Form",
			deadline: utcDateTime.fromISO("2025-03-31T23:59:59Z"),
			status: UserFormStatus.in_progress,
			responseIds: #["a12b3c4d-5e6f-7a8b-9c0d-e1f2a3b4c5d6"],
		},
		#{
			id: "7f6e5d4c-3b2a-1098-7654-321fedcba098",
			title: "Member Information Update 2025",
			deadline: utcDateTime.fromISO("2025-02-15T23:59:59Z"),
			status: UserFormStatus.completed,
			responseIds: #["b23c4d5e-6f7a-8b9c-0d1e-f2a3b4c5d6e7", "c34d5e6f-7a8b-9c0d-1e2f-a3b4c5d6e7f8"],
		},
	])
	model UserFormListResponse is UserForm[];
}
