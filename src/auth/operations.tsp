using Http;

@tag("Auth")
namespace CoreSystem.Auth {
	@summary("Login with OAuth Provider")
	@route("/auth/login/oauth/{provider}")
	@get
	op loginGoogle(
		@doc("The OAuth2 provider to use for login.")
		@path
		provider: OAuthLoginProviders,

		@doc("The callback URL of the OAuth2 login. [See details](https://clustron.atlassian.net/wiki/spaces/CS/pages/41320449/Authentication+Process)")
		@query
		c: string,

		@doc("The redirect URL for login callback.")
		@query
		r?: string,
	): {
		@statusCode statusCode: 302;
	} | {
		@statusCode statusCode: 404;
	};

	@summary("Refresh Access Token")
	@route("/auth/refresh/{refreshToken}")
	@post
	op refreshToken(
		@doc("The refresh token to use for refreshing the access token.")
		@path
		refreshToken: string,
	): {
		@statusCode statusCode: 200;
		@body refreshToken: RefreshToken;
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
}
