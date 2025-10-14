import "@typespec/http";
import "@typespec/openapi3";

using Http;

@tag("Slug")
namespace CoreSystem.Slug {
  @doc("The current state of the slug.")
  model Status {
    @doc("Indicates whether the slug is available.")
    available: boolean;

    @doc("The organization currently using the slug, if any.")
    orgId: uuid | null;
  }

  @doc("The usage history of the slug.")
  model History {
    @doc("The unique identifier of the organization that used the slug.")
    orgId: uuid;

    @doc("The name of the organization that used the slug.")
    orgName: string;

    @doc("The timestamp when the organization started using the slug.")
    startedAt: utcDateTime;

    @doc("The timestamp when the organization stopped using the slug, if applicable.")
    endedAt: utcDateTime | null;
  }

  @doc("Get the availability of the slug.")
  @route("/orgs/{slug}/status")
  @get
  op getSlugStatus(@path slug: string): {
    @statusCode statusCode: 200;
    @body current: Status;
  } | {
    @statusCode statusCode: 404;
    @body error: NotFound;
  };

  @doc("List the complete usage history of a given slug")
  @route("/orgs/{slug}/history")
  @get
  op getSlugHistory(@path slug: string): {
    @statusCode statusCode: 200;
    @body body: {
      current: Status;
      history: History[];
    };
  } | {
    @statusCode statusCode: 404;
    @body error: NotFound;
  };
}
