namespace CoreSystem.User {
	enum Role {
		user: "USER",
	}

	model User {
		@doc("The user's unique identifier.")
		id: uuid;

		@doc("The user's username, can change, but must be unique across the system.")
		username: string;

		@minLength(4)
		@maxLength(15)
		@pattern("^\\w+$")
		@doc("The user's nickname.")
		name: string;

		@doc("Avatar URL of the user.")
		avatarUrl: string;

		@doc("Email addresses associated with the user.")
		emails: string[];

		@doc("Global role of the user.")
		roles: Role[];
	}

	model OnboardingRequest {
		@doc("The user's username, can change, but must be unique across the system.")
		username: string;

		@minLength(4)
		@maxLength(15)
		@pattern("^\\w+$")
		@doc("The user's nickname.")
		name: string;
	}
}
