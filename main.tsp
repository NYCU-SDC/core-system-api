import "@typespec/http";
import "@typespec/versioning";
import "./service/healthz.tsp";
import "./service/auth.tsp";
import "./service/user.tsp";
import "./service/unit.tsp";
import "./service/forms.tsp";
import "./service/responses.tsp";
import "./service/inbox.tsp";
import "./service/slug.tsp";
import "./service/form_workflow.tsp";

using Http;
using Versioning;

@service(#{ title: "Core System API" })

@server("https://dev.core-system.sdc.nycu.club", "Dev server")
@server("https://mock.core-system.sdc.nycu.club", "Mock server")
@server("http://127.0.0.1:4010", "Local Prism mock")

@versioned(Versions)
@route("/api")
namespace CoreSystem;

enum Versions {
  v1: "1.0.0",
}

@format("uuid")
scalar uuid extends string;

@error
@doc("Problem represents a problem detail as defined in RFC 7807")
model ProblemDetail {
  @doc("The problem's title.")
  title: string;

  @doc("The problem's status code.")
  status: integer;

  @doc("Type indicates the URI that identifies the problem type, we use an MDN URI here.")
  type: string;

  @doc("The problem's detail.")
  detail: string;
}

@error
model Unauthorized {
  title: "Unauthorized";
  status: 401;
  type: "https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/401";
  detail: string;
}

@error
model NotFound {
  title: "Not Found";
  status: 404;
  type: "https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/404";
  detail: string;
}

@error
model BadRequest {
    title: "Bad Request";
    status: 400;
    type: "https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/400";
    detail: string;
}
