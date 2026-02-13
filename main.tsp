import "@typespec/http";
import "@typespec/versioning";

// ═════════════════════════════════════════════════
// === Basic Models ===
// ═════════════════════════════════════════════════
// --- Common ---
import "./src/models.tsp";
import "./src/errors/models.tsp";

// --- Health Check ---
import "./src/healthz/models.tsp";
import "./src/healthz/operations.tsp";

// --- Auth ---
import "./src/auth/models.tsp";
import "./src/auth/operations.tsp";

// ═════════════════════════════════════════════════
// === User ===
// ═════════════════════════════════════════════════
// --- User ---
import "./src/user/models.tsp";
import "./src/user/operations.tsp";

// ═════════════════════════════════════════════════
// === Unit ===
// ═════════════════════════════════════════════════
// --- Organization, Unit, Membership ---
import "./src/unit/models.tsp";
import "./src/unit/operations.tsp";

// --- Slug ---
import "./src/slug/models.tsp";
import "./src/slug/operations.tsp";

// ═════════════════════════════════════════════════
// === Forms ===
// ═════════════════════════════════════════════════
// --- Forms, Sections, Questions ---
import "./src/forms/models.tsp";
import "./src/forms/operations.tsp";

// --- Question ---
import "./src/forms/question/models.tsp";
import "./src/forms/question/operations.tsp";

// --- Workflow ---
import "./src/forms/workflow/models.tsp";
import "./src/forms/workflow/operations.tsp";

// --- Response ---
import "./src/forms/response/models.tsp";
import "./src/forms/response/operations.tsp";

// --- Answer ---
import "./src/forms/answer/models.tsp";
import "./src/forms/answer/operations.tsp";

// ═════════════════════════════════════════════════
// === Inbox ===
// ═════════════════════════════════════════════════
// import "./src/inbox/models.tsp";
// import "./src/inbox/operations.tsp";

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
