using Http;

@tag("Slug")
namespace CoreSystem.Slug {
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
