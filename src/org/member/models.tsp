namespace CoreSystem.Unit {
	@example(#{ email: "123@gmail.com" })
	model OrgMemberRequest {
		email: string;
	}

	@doc("Response model for organization member with full user details")
	@example(#{
		orgId: "3c5fa073-7b97-43a3-bc44-ddc98f390a08",
		member: #{
			id: "d26e9c90-4747-496b-9953-7e7c4f97643f",
			username: "alice_wang",
			name: "Alice Wang",
			avatarUrl: "https://avatars.githubusercontent.com/u/87654321",
			emails: #["alice@example.com"],
			roles: #[CoreSystem.User.Role.user],
			is_onboarded: true,
		},
	})
	model OrgMemberResponse {
		@doc("The unique identifier of the organization")
		orgId: uuid;

		@doc("Full user details including emails")
		member: CoreSystem.User.User;
	}
}
