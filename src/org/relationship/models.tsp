namespace CoreSystem.Unit {
	@doc("Model representing a parent-child relationship between units, allowing for hierarchical structures")
	model ParentChild {
		@doc("The unique identifier of the parent unit, which can be left null if the child is root unit of the organization.")
		parentId?: uuid;

		@doc("The unique identifier of the child unit")
		childId: uuid;

		@doc("The unique identifier of the units' organization")
		orgId: uuid;
	}

	@example(#{ parentId: "3c5fa073-7b97-43a3-bc44-ddc98f390a08", childId: "d26e9c90-4747-496b-9953-7e7c4f97643f", orgId: "3c5fa073-7b97-43a3-bc44-ddc98f390a08" })
	model ParentChildRequest {
		parentId?: uuid; // Optional, if not provided, the child will be added to the root of the organization
		childId: uuid;
		orgId: uuid;
	}
}
