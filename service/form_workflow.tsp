import "@typespec/http";
import "@typespec/openapi3";
import "./forms.tsp";

using Http;
using OpenAPI;
using CoreSystem.Forms;

@tag("Form Workflow")
namespace CoreSystem.FormWorkflow {
  @doc("Node type enum for workflow nodes")
  enum NodeType {
    @doc("Section node - represents a form section/page")
    section: "section",

    @doc("End node - represents the end of the workflow (thank you page and redirect)")
    end: "end",

    @doc("Start node - represents the workflow entry point")
    start: "start",

    @doc("Condition node - represents a logic/condition check node")
    condition: "condition",
  }

  @doc("Data source for condition rules")
  enum ConditionSource {
    @doc("Source from JWT token (user context)")
    jwt: "jwt",

    @doc("Source from form answers")
    answer: "answer",
  }

  @doc("Start node data payload")
  model StartNodeData {
    @doc("Callback URL for the workflow entry")
    callback_url: string;
  }

  @doc("End node data payload")
  model EndNodeData {
    @doc("Title for the end page")
    title: string;

    @doc("Content/message for the end page")
    content: string;

    @doc("Redirect URL after form completion")
    redirect_url: string;
  }

  @doc("Condition rule for condition nodes")
  model ConditionRule {
    @doc("Source of data for the condition (jwt or answer)")
    source: ConditionSource;

    @doc("Key to check in the source data")
    key: string;

    @doc("Regex pattern to match against")
    pattern: string;

    @doc("Regex flags (e.g., 'i' for case-insensitive)")
    flags?: string;
  }

  @doc("Condition node data payload")
  model ConditionNodeData {
    @doc("Array of condition rules to evaluate")
    rules: ConditionRule[];
  }

  @doc("Workflow node structure")
  model Node {
    @doc("Unique identifier for the node")
    id: string;

    @doc("Type of the node")
    type: NodeType;

    @doc("Data payload for the node (structure depends on node type, stored as JSONB)")
    data: unknown;

    @doc("Frontend payload stored in JSONB")
    frontend_payload: unknown;
  }

  @doc("Workflow edge structure (connection between nodes)")
  model Edge {
    @doc("Source node ID")
    source: string;

    @doc("Target node ID")
    target: string;

    @doc("Source handle for conditional edges (true/false for condition nodes)")
    sourceHandle?: "true" | "false";
  }

  @doc("Complete workflow structure stored as JSONB")
  model WorkflowStructure {
    @doc("Array of workflow nodes")
    nodes: Node[];

    @doc("Array of workflow edges (connections)")
    edges: Edge[];
  }

  @doc("Request body for creating/updating workflow")
  @example(#{
    nodes: #[
      #{
        id: "uuid_node_start",
        type: NodeType.start,
        data: #{
          callback_url: "https://core-system.sdc.nycu.club/register-form",
        },
        frontend_payload: #{},
      },
      #{
        id: "uuid_choose_team",
        type: NodeType.section,
        data: #{ section_ref_id: "8888-content-uuid" },
        frontend_payload: #{},
      },
      #{
        id: "uuid_check_role",
        type: NodeType.condition,
        data: #{
          rules: #[
            #{
              source: ConditionSource.jwt,
              key: "role",
              pattern: "admin",
              flags: "i",
            }
          ],
        },
        frontend_payload: #{},
      }
    ],
    edges: #[
      #{ source: "uuid_node_start", target: "uuid_choose_team" },
      #{
        source: "uuid_choose_full_stack_intro",
        target: "uuid_full_stack_intro",
        sourceHandle: "true",
      },
      #{
        source: "uuid_choose_full_stack_intro",
        target: "uuid_choose_full_stack_advanced",
        sourceHandle: "false",
      }
    ],
  })
  model WorkflowRequest {
    @doc("Workflow structure with nodes and edges")
    nodes: Node[];

    @doc("Workflow edges connecting nodes")
    edges: Edge[];
  }

  @doc("Workflow response model")
  model WorkflowResponse {
    @doc("The form ID this workflow belongs to")
    formId: uuid;

    @doc("The complete workflow structure")
    workflow: WorkflowStructure;
  }

  @doc("Section node data payload for workflow preview")
  model SectionNodeDataForPreview {
    @doc("The section ID")
    id: uuid;

    @doc("The section title")
    title: string;
  }

  @doc("Response model for workflow preview")
  model WorkflowPreviewResponse {
    @doc("The sections to display in the workflow")
    sections: SectionNodeDataForPreview[];
  }

  // API Endpoints

  @doc("Preview workflow - get initial workflow state and first section")
  @route("/forms/{id}/workflow/preview")
  @post
  op previewWorkflow(@path id: uuid): {
    @statusCode statusCode: 200;
    @body response: WorkflowPreviewResponse;
  } | {
    @statusCode statusCode: 404;
    @body error: NotFound;
  } | {
    @statusCode statusCode: 400;
    @body error: ProblemDetail;
  };

  @doc("Create a new workflow for a form (backend/admin)")
  @route("/forms/{id}/workflow")
  @post
  op createWorkflow(@path id: uuid, @body request: WorkflowRequest): {
    @statusCode statusCode: 201;
    @body response: WorkflowResponse;
  } | {
    @statusCode statusCode: 404;
    @body error: NotFound;
  } | {
    @statusCode statusCode: 400;
    @body error: ProblemDetail;
  };

  @doc("Get workflow for a form (backend/admin)")
  @route("/forms/{id}/workflow")
  @get
  op getWorkflow(@path id: uuid): {
    @statusCode statusCode: 200;
    @body response: WorkflowResponse;
  } | {
    @statusCode statusCode: 404;
    @body error: NotFound;
  };

  @doc("Update workflow for a form (backend/admin)")
  @route("/forms/{id}/workflow")
  @put
  op updateWorkflow(@path id: uuid, @body request: WorkflowRequest): {
    @statusCode statusCode: 200;
    @body response: WorkflowResponse;
  } | {
    @statusCode statusCode: 404;
    @body error: NotFound;
  } | {
    @statusCode statusCode: 400;
    @body error: ProblemDetail;
  };
}
