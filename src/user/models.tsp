namespace CoreSystem.User {
	enum Role {
		user: "USER",
	}

	@doc("Profile shape returned when embedding a user in other resources.")
	@example(#{
		id: "3c5fa073-7b97-43a3-bc44-ddc98f390a08",
		name: "John Doe",
		username: "john_doe",
		avatarUrl: "https://avatars.githubusercontent.com/u/12345678",
		emails: #["john.doe@example.com", "john@gmail.com"],
	})
	model ProfileResponse {
		@doc("The user's unique identifier.")
		id: uuid;

		@doc("The user's nickname.")
		name: string;

		@doc("The user's username, can change, but must be unique across the system.")
		username: string;

		@doc("Avatar URL of the user.")
		avatarUrl: string;

		@doc("Email addresses associated with the user.")
		emails: string[];
	}

	@example(#{
		id: "3c5fa073-7b97-43a3-bc44-ddc98f390a08",
		username: "john_doe",
		name: "John Doe",
		avatarUrl: "https://avatars.githubusercontent.com/u/12345678",
		emails: #["john.doe@example.com", "john@gmail.com"],
		roles: #[Role.user],
		require_onboarding: true,
	})
	model User {
		@doc("The user's unique identifier.")
		id: uuid;

		@minLength(4)
		@maxLength(15)
		@pattern("^\\w+$")
		@doc("The user's username, can change, but must be unique across the system.")
		username: string;

		@maxLength(15)
		@doc("The user's nickname.")
		name: string;

		@doc("Avatar URL of the user.")
		avatarUrl: string;

		@doc("Email addresses associated with the user.")
		emails: string[];

		@doc("Global role of the user.")
		roles: Role[];

		@doc("The user needs to onboard and has not completed onboarding yet.")
		require_onboarding: boolean;
	}

	@example(#{ username: "jane_smith", name: "Jane Smith" })
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
