using Http;

namespace CoreSystem.Views {
	@doc("Response model for a single form view.")
	@example(#{
		id: "f1a2b3c4-5d6e-7f8a-9b0c-1d2e3f4a5b6c",
		title: "Core System",
		locked: false,
        order: 0,
		createdAt: utcDateTime.fromISO("2025-01-15T10:00:00Z"),
		updatedAt: utcDateTime.fromISO("2025-02-10T14:30:00Z"),
	})
	model ViewResponse  {
		@doc("The view's unique identifier.")
		id: uuid;

		@doc("The display title of the view.")
		title: string;

		@doc("Whether this view is locked from editing.")
		locked: boolean;

        @doc("The order of the current view among all views. Views are ordered in ascending order based on this field.")
        order: integer;

		@doc("The creation timestamp of the view.")
		createdAt: utcDateTime;

		@doc("The last updated timestamp of the view.")
		updatedAt: utcDateTime;
	}

	@doc("Request model for updating a view. Only provided fields will be updated.")
	@example(#{ title: "React" })
	model UpdateViewRequest {
		@doc("The new display title of the view.")
		title?: string;

        @doc("The new order of the current view among all views.")
        order?: integer;
	}
}
