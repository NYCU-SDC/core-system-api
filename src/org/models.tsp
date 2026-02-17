namespace CoreSystem.Unit {
	@doc("Base model, containing common fields for both units and organizations.")
	model Base {
		@doc("The unit's unique identifier.")
		id: uuid;

		@doc("The name of the unit or organization")
		name: string;

		@doc("A brief description of the unit or organization")
		description: string;

		@doc("Metadata for the unit or organization, can include additional information like contact details, address, etc.")
		metadata: Record<string>;

		@doc("The creation timestamp of the unit or organization")
		createdAt: utcDateTime;

		@doc("The last updated timestamp of the unit or organization")
		updatedAt: utcDateTime;
	}

	@doc("Base Request model, containing common fields for updating units and organizations.")
	@example(#{ name: "2025 Backend", description: "Backend course - Updated", metadata: #{ year: "2025", type: "education program" } })
	model BaseRequest {
		@doc("The name of the unit or organization")
		name: string;

		@doc("A brief description of the unit or organization")
		description: string;

		@doc("Metadata for the unit or organization, can include additional information like contact details, address, etc.")
		metadata: Record<string>;
	}

	@example(#{
		id: "3c5fa073-7b97-43a3-bc44-ddc98f390a08",
		name: "NYCU SDC",
		description: "National Yang Ming Chiao Tung University Software Development Club",
		metadata: #{ type: "club", founded: "2020" },
		createdAt: utcDateTime.fromISO("2024-01-15T08:00:00Z"),
		updatedAt: utcDateTime.fromISO("2024-12-20T10:30:00Z"),
		slug: "nycu-sdc",
	})
	model Organization {
		...Base;

		@doc("Unique slug for the organization, used for URL routing and identification")
		slug: string;
	}

	@doc("Model representing a member of an organization, linking organization and member by their unique identifiers")
	@example(#{ orgId: "3c5fa073-7b97-43a3-bc44-ddc98f390a08", memberId: "d26e9c90-4747-496b-9953-7e7c4f97643f" })
	model OrgMember {
		@doc("The unique identifier of the organization")
		orgId: uuid;

		@doc("The unique identifier of the member")
		memberId: uuid;
	}

	@example(#{ name: "NYCU SDC2", description: "陽明交大軟體開發社", slug: "nycu-sdc1", metadata: #{ type: "club" } })
	model CreateOrgRequest {
		...BaseRequest;
		slug: string; // Slug is required for organizations
	}

	@example(#{ name: "NYCU SDC 2025", description: "Updated organization description", slug: "nycu-sdc", metadata: #{ type: "club", members: "150" } })
	model UpdateOrgRequest {
		...BaseRequest;
		slug: string;
	}
}
