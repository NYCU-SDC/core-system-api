import "@typespec/http";
import "@typespec/openapi3";

using Http;
using OpenAPI;

@tag("Auth")
namespace CoreSystem.Auth {
  enum OAuthProviders {
    google: "google",
  }

  model RefreshToken {
    @doc("The access token and formatted as JWT")
    accessToken: string;

    @doc("The expiration date of the refresh token.")
    expirationTime: integer;

    @doc("The new refresh token.")
    refreshToken: string;
  }

  @route("/auth/login/oauth/{provider}")
  @get
  op loginGoogle(
    @doc("The OAuth2 provider to use for login.")
    @path
    provider: OAuthProviders,

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
}
