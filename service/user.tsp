import "@typespec/http";

using Http;

@tag("User")
namespace CoreSystem.User {
  enum Role {
    user: "user",
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
    @statusCode statusCode: 409;
    @body err: Conflict;
  };
}
