namespace CoreSystem.Slug {
	@doc("The current state of the slug.")
	@example(#{ available: false, orgId: "3c5fa073-7b97-43a3-bc44-ddc98f390a08" })
	model Status {
		@doc("Indicates whether the slug is available.")
		available: boolean;

		@doc("The organization currently using the slug, if any.")
		orgId: uuid | null;
	}

	@doc("The usage history of the slug.")
	@example(#{
		orgId: "3c5fa073-7b97-43a3-bc44-ddc98f390a08",
		orgName: "NYCU SDC",
		startedAt: utcDateTime.fromISO("2024-01-15T08:00:00Z"),
		endedAt: null,
	})
	model History {
		@doc("The unique identifier of the organization that used the slug.")
		orgId: uuid;

		@doc("The name of the organization that used the slug.")
		orgName: string;

		@doc("The timestamp when the organization started using the slug.")
		startedAt: utcDateTime;

		@doc("The timestamp when the organization stopped using the slug, if applicable.")
		endedAt: utcDateTime | null;
	}
}
