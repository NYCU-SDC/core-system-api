import "@typespec/http";

using Http;

@tag("Healthz")
namespace CoreSystem.Healthz {
  @route("/healthz")
  @get
  op checkHealthz(): {
    @statusCode statusCode: 200;
  } | {
    @statusCode statusCode: 404;
  };
}
