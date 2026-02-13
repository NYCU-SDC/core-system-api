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

	model Organization {
		...Base;

		@doc("Unique slug for the organization, used for URL routing and identification")
		slug: string;
	}

	@doc("Model representing a member of an organization, linking organization and member by their unique identifiers")
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

	model UpdateOrgRequest {
		...BaseRequest;
		slug: string;
	}
}
