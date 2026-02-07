using Http;

@tag("User")
namespace CoreSystem.User {
  @summary("Get Current User")
  @get
  @route("/users/me")
  @doc("Get the current user's information.")
  op getMe(): {
    @statusCode statusCode: 200;
    @body user: User;
  } | {
    @statusCode
    statusCode: 401;

    @body error: Unauthorized;
  };

  @summary("Onboard User")
  @put
  @route("/users/onboarding")
  @doc("Onboard the current user by updating their username and other details.")
  op updateUsername(...OnboardingRequest): {
    @statusCode statusCode: 200;
    @body user: User;
  } | {
    @statusCode statusCode: 401;
    @body err: Unauthorized;
  } | {
    @statusCode statusCode: 400;
    @body err: BadRequest;
  };
}
