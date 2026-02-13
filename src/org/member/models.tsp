namespace CoreSystem.Unit {
	@example(#{ email: "123@gmail.com" })
	model OrgMemberRequest {
		email: string;
	}

	@doc("Response model for organization member with full user details")
	model OrgMemberResponse {
		@doc("The unique identifier of the organization")
		orgId: uuid;

		@doc("Full user details including emails")
		member: CoreSystem.User.User;
	}
}
