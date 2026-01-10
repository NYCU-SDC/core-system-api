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
    section: "SECTION",

    @doc("End node - represents the end of the workflow (thank you page and redirect)")
    end: "END",

    @doc("Start node - represents the workflow entry point")
    start: "START",

    @doc("Condition node - represents a logic/condition check node")
    condition: "CONDITION",
  }

  @doc("Data source for condition rules")
  enum ConditionSource {
    @doc("Source from choice answer")
    choice: "CHOICE",

    @doc("Source from non-choice answer")
    nonChoice: "NON_CHOICE",
  }

  @doc("Condition rule for condition nodes")
  model ConditionRule {
    @doc("Source of data for the condition")
    source: ConditionSource;

    @doc("The question ID to check against")
    key: uuid;

    @doc("Regex pattern to match against (required for NON_CHOICE source)")
    pattern?: string;

    @doc("Regex flags (e.g., 'i' for case-insensitive, only for NON_CHOICE source)")
    flags?: string;

    @doc("Array of choice option IDs to match against (required for CHOICE source)")
    choiceOptionIds?: uuid[];
  }

  @doc("Workflow node structure with linked list connections")
  model Node {
    @doc("Unique identifier for the node")
    id: uuid;

    @doc("Type of the node")
    type: NodeType;

    @doc("Next node ID for sequential flow (for start and section nodes)")
    next?: uuid;

    @doc("Next node ID when condition is true (for condition nodes)")
    nextTrue?: uuid;

    @doc("Next node ID when condition is false (for condition nodes)")
    nextFalse?: uuid;

    @doc("The section reference ID for the node, only for section nodes")
    sectionRefId?: uuid;

    @doc("The condition rules for the node, only for condition nodes")
    conditionRules?: ConditionRule[];
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
        next: "uuid_choose_team",
      },
      #{
        id: "uuid_choose_team",
        type: NodeType.section,
        sectionRefId: "8888-content-uuid",
        next: "uuid_check_role",
      },
      #{
        id: "uuid_check_role",
        type: NodeType.condition,
        conditionRules: #[
          #{
            source: ConditionSource.choice,
            key: "question_id",
            choiceOptionIds: #[
              "f421cfc2-2b84-4da9-9629-011af609935a",
              "2ca86a6d-7735-4f17-8676-29b4724b524f"
            ],
          },
          #{
            source: ConditionSource.nonChoice,
            key: "name_question_id",
            pattern: "^[A-Z]",
            flags: "i",
          }
        ],
        nextTrue: "uuid_full_stack_intro",
        nextFalse: "uuid_choose_full_stack_advanced",
      },
      #{
        id: "uuid_full_stack_intro",
        type: NodeType.section,
        sectionRefId: "full-stack-intro-uuid",
        next: "uuid_end",
      },
      #{
        id: "uuid_choose_full_stack_advanced",
        type: NodeType.section,
        sectionRefId: "full-stack-advanced-uuid",
        next: "uuid_end",
      },
      #{ id: "uuid_end", type: NodeType.end }
    ],
  })
  model WorkflowRequest {
    ...WorkflowStructure;
  }

  @doc("Workflow response model")
  model WorkflowResponse {
    @doc("The form ID this workflow belongs to")
    formId: uuid;

    @doc("The complete workflow structure")
    workflow: WorkflowStructure;
  }

  // API Endpoints

  @doc("Create a new workflow for a form (backend/admin). Request body is optional - if provided, creates workflow with initial nodes; if omitted, creates empty workflow with only start and end nodes.")
  @route("/forms/{id}/workflow")
  @post
  op createWorkflow(@path id: uuid, @body request?: WorkflowRequest): {
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
