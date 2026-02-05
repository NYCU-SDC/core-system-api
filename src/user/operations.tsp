using Http;

@tag("User")
namespace CoreSystem.User {
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

  @put
  @route("/users/onboarding")
  @doc("Update the current user's name.")
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
