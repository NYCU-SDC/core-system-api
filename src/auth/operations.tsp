using Http;

@tag("Auth")
namespace CoreSystem.Auth {
	@summary("Login with OAuth Provider")
	@route("/auth/login/oauth/{oauthProvider}")
	@get
	op loginGoogle(
		@doc("The OAuth2 provider to use for login.")
		@path
		oauthProvider: OAuthLoginProviders,

		@doc("The callback URL of the OAuth2 login. [See details](https://clustron.atlassian.net/wiki/spaces/CS/pages/41320449/Authentication+Process)")
		@query
		c: string,

		@doc("The redirect URL for login callback.")
		@query
		r?: string,

		@doc("Custom base URL for OAuth callback (only used in dev mode).")
		@query
		base?: string,
	): {
		@statusCode statusCode: 302;
	} | {
		@statusCode statusCode: 404;
	};

	@summary("Refresh Access Token")
	@route("/auth/refresh")
	@post
	op refreshToken(): {
		@statusCode statusCode: 200;
	} | {
		@statusCode statusCode: 404;
	};

	@summary("Logout User")
	@route("/auth/logout")
	@post
	op logout(): {
		@statusCode statusCode: 200;
	} | {
		@statusCode statusCode: 401;
	};

	@summary("Link different OAuth accounts to the same user")
	@route("/auth/link")
	@post
	op link( 
		@doc("The name of the existing user.")
		@query
		name: string,

		@doc("The OAuth2 provider of the existing user.")
		@query
		oauthProvider: OAuthLoginProviders,
		
		@doc("The email of the existing user.")
		@query
		email: string
	): {
		@statusCode statusCode: 200;
 	} | {
		@statusCode statusCode: 401;
	};

	@summary("Abort the account linking process")
	@route("/auth/link/abort")
	@post
	op abortLink(): {
		@statusCode statusCode: 200;
 	} | {
		@statusCode statusCode: 401;
	};

	@summary("Internal Login (Debug)")
	@route("/auth/login/internal")
	@post
	op internalLogin(
		@doc("Login request with user ID.")
		@body
		request: InternalLoginRequest,
	): {
		@statusCode statusCode: 200;
		@body response: InternalLoginResponse;
	};
}
