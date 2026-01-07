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

  @doc("Next node connection with optional condition result")
  model NextNode {
    @doc("The ID of the next node")
    nodeId: string;

    @doc("When condition evaluates to this value, go to this node (for condition nodes only)")
    when?: boolean;
  }

  @doc("Workflow node structure with linked list connections")
  model Node {
    @doc("Unique identifier for the node")
    id: string;

    @doc("Type of the node")
    type: NodeType;

    @doc("Data payload for the node (structure depends on node type, stored as JSONB)")
    data: unknown;

    @doc("Frontend payload stored in JSONB")
    frontend_payload: unknown;

    @doc("Array of next nodes with their logic conditions (for sequential nodes, use single item without logic; for condition nodes, use items with logic true/false)")
    nextNodes?: NextNode[];
  }

  @doc("Complete workflow structure stored as JSONB")
  model WorkflowStructure {
    @doc("Array of workflow nodes (connections are stored within each node)")
    nodes: Node[];
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
        nextNodes: #[#{ nodeId: "uuid_choose_team" }],
      },
      #{
        id: "uuid_choose_team",
        type: NodeType.section,
        data: #{ section_ref_id: "8888-content-uuid" },
        frontend_payload: #{},
        nextNodes: #[
          #{ nodeId: "uuid_full_stack_intro", when: true },
          #{ nodeId: "uuid_choose_full_stack_advanced", when: false }
        ],
      },
      #{
        id: "uuid_full_stack_intro",
        type: NodeType.section,
        data: #{ section_ref_id: "full-stack-intro-uuid" },
        frontend_payload: #{},
        nextNodes: #[#{ nodeId: "uuid_end" }],
      },
      #{
        id: "uuid_choose_full_stack_advanced",
        type: NodeType.section,
        data: #{ section_ref_id: "full-stack-advanced-uuid" },
        frontend_payload: #{},
        nextNodes: #[#{ nodeId: "uuid_end" }],
      },
      #{
        id: "uuid_end",
        type: NodeType.end,
        data: #{
          title: "Thank you!",
          content: "Your form has been submitted successfully.",
          redirect_url: "https://example.com",
        },
        frontend_payload: #{},
      }
    ],
  })
  model WorkflowRequest {
    @doc("Workflow structure with nodes (linked list connections stored in each node)")
    nodes: Node[];
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
