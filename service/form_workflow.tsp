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
    @doc("Source of data for the condition (jwt or answer)")
    source: ConditionSource;

    @doc("Key to check in the source data")
    key: string;

    @doc("Regex pattern to match against")
    pattern: string;

    @doc("Regex flags (e.g., 'i' for case-insensitive)")
    flags?: string;
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

    @doc("Array of next nodes with their logic conditions (for sequential nodes, use single item without logic; for condition nodes, use items with logic true/false)")
    nextNodes?: NextNode[];

    @doc("The section reference ID for the node, only for section nodes")
    sectionRefId?: string;

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
        nextNodes: #[#{ nodeId: "uuid_choose_team" }],
      },
      #{
        id: "uuid_choose_team",
        type: NodeType.condition,
        conditionRules: #[
          #{
            source: ConditionSource.choice,
            key: "question_id",
            pattern: "8888-content-uuid",
          }
        ],
        nextNodes: #[
          #{ nodeId: "uuid_full_stack_intro", when: true },
          #{ nodeId: "uuid_choose_full_stack_advanced", when: false }
        ],
      },
      #{
        id: "uuid_full_stack_intro",
        type: NodeType.section,
        sectionRefId: "full-stack-intro-uuid",
        nextNodes: #[#{ nodeId: "uuid_end" }],
      },
      #{
        id: "uuid_choose_full_stack_advanced",
        type: NodeType.section,
        sectionRefId: "full-stack-advanced-uuid",
        nextNodes: #[#{ nodeId: "uuid_end" }],
      },
      #{ id: "uuid_end", type: NodeType.end }
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
