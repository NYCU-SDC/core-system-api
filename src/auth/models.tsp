namespace CoreSystem.Auth {
	enum OAuthProviders {
		google: "GOOGLE",
		github: "GITHUB",
	}

	enum OAuthLoginProviders {
		google: "GOOGLE",
		nycu: "NYCU",
	}

	@example(#{ accessToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...", expirationTime: 1735689600, refreshToken: "d290f1ee-6c54-4b01-90e6-d701748f0851" })
	model RefreshToken {
		@doc("The access token and formatted as JWT")
		accessToken: string;

		@doc("The expiration date of the refresh token.")
		expirationTime: integer;

		@doc("The new refresh token.")
		refreshToken: string;
	}

	@example(#{ uid: "3c5fa073-7b97-43a3-bc44-ddc98f390a08" })
	model InternalLoginRequest {
		@doc("The user ID to login as.")
		uid: string;
	}

	@example(#{ message: "Login successful" })
	model InternalLoginResponse {
		@doc("Login status message.")
		message: string;
	}
}
