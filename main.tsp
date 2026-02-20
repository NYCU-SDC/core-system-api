import "@typespec/http";
import "@typespec/versioning";

// ═════════════════════════════════════════════════
// === Basic Models ===
// ═════════════════════════════════════════════════
// --- Common ---
import "./src/models.tsp";
import "./src/error/models.tsp";

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
// --- Organization ---
import "./src/org/models.tsp";
import "./src/org/operations.tsp";

// --- Unit ---
import "./src/org/unit/models.tsp";
import "./src/org/unit/operations.tsp";

// --- Parent-Child Relationship ---
import "./src/org/relationship/models.tsp";
import "./src/org/relationship/operations.tsp";

// --- Member ---
import "./src/org/member/models.tsp";
import "./src/org/member/operations.tsp";

// --- Slug ---
import "./src/slug/models.tsp";
import "./src/slug/operations.tsp";

// --- Resource ---
// ## Form ##
import "./src/org/form/models.tsp";
import "./src/org/form/operations.tsp";

// ═════════════════════════════════════════════════
// === Forms ===
// ═════════════════════════════════════════════════
// --- Forms, Sections, Questions ---
import "./src/form/models.tsp";
import "./src/form/operations.tsp";

// --- Question ---
import "./src/form/question/models.tsp";
import "./src/form/question/operations.tsp";

// --- Workflow ---
import "./src/form/workflow/models.tsp";
import "./src/form/workflow/operations.tsp";

// --- Response ---
import "./src/form/response/models.tsp";
import "./src/form/response/operations.tsp";

// --- Answer ---
import "./src/form/answer/models.tsp";
import "./src/form/answer/operations.tsp";

// ═════════════════════════════════════════════════
// === File ===
// ═════════════════════════════════════════════════
// --- File ---
import "./src/file/models.tsp";
import "./src/file/operations.tsp";

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
