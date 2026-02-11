import "@typespec/http";
import "@typespec/versioning";

// ═════════════════════════════════════════════════
// === Basic Models ===
// ═════════════════════════════════════════════════
import "./src/models.tsp";
import "./src/errors/models.tsp";

// ═════════════════════════════════════════════════
// === Auth ===
// ═════════════════════════════════════════════════
import "./src/auth/models.tsp";
import "./src/auth/operations.tsp";

// ═════════════════════════════════════════════════
// === User ===
// ═════════════════════════════════════════════════
import "./src/user/models.tsp";
import "./src/user/operations.tsp";

// ═════════════════════════════════════════════════
// === Forms ===
// ═════════════════════════════════════════════════
import "./src/forms/models.tsp";
import "./src/forms/operations.tsp";

// ═════════════════════════════════════════════════
// === Unit ===
// ═════════════════════════════════════════════════
import "./src/unit/models.tsp";
import "./src/unit/operations.tsp";

// ═════════════════════════════════════════════════
// === Responses ===
// ═════════════════════════════════════════════════
import "./src/responses/models.tsp";
import "./src/responses/operations.tsp";

// ═════════════════════════════════════════════════
// === Inbox ===
// ═════════════════════════════════════════════════
// import "./src/inbox/models.tsp";
// import "./src/inbox/operations.tsp";

// ═════════════════════════════════════════════════
// === Slug ===
// ═════════════════════════════════════════════════
import "./src/slug/models.tsp";
import "./src/slug/operations.tsp";

// ═════════════════════════════════════════════════
// === Form Workflow ===
// ═════════════════════════════════════════════════
import "./src/form_workflow/models.tsp";
import "./src/form_workflow/operations.tsp";

// ═════════════════════════════════════════════════
// === Healthz ===
// ═════════════════════════════════════════════════
import "./src/healthz/models.tsp";
import "./src/healthz/operations.tsp";

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
