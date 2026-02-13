namespace CoreSystem.Auth {
	enum OAuthProviders {
		google: "GOOGLE",
		github: "GITHUB",
	}

	enum OAuthLoginProviders {
		google: "GOOGLE",
		nycu: "NYCU",
	}

	model RefreshToken {
		@doc("The access token and formatted as JWT")
		accessToken: string;

		@doc("The expiration date of the refresh token.")
		expirationTime: integer;

		@doc("The new refresh token.")
		refreshToken: string;
	}

	model InternalLoginRequest {
		@doc("The user ID to login as.")
		uid: string;
	}

	model InternalLoginResponse {
		@doc("Login status message.")
		message: string;
	}
}
