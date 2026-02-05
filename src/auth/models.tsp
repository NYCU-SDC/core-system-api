import "@typespec/http";

using Http;

namespace CoreSystem.Auth {
  enum OAuthProviders {
    google: "GOOGLE",
    github: "GITHUB",
  }

  model RefreshToken {
    @doc("The access token and formatted as JWT")
    accessToken: string;

    @doc("The expiration date of the refresh token.")
    expirationTime: integer;

    @doc("The new refresh token.")
    refreshToken: string;
  }
}
