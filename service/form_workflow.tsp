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
    @example(ConditionSource.nonChoice)
    source: ConditionSource;

    @doc("The node ID that contains the question to check against")
    @example("engineering_dept")
    nodeId: string;

    @doc("The question ID to check against")
    @example("9a843aa0-8451-4e3b-b6a0-8c0e994e9040")
    key: uuid;

    @doc("Regex pattern to match against (required for NON_CHOICE source)")
    @example("^([6-9]|[1-9][0-9]+)$")
    pattern?: string;

    @doc("Regex flags (e.g., 'i' for case-insensitive, only for NON_CHOICE source)")
    @example("ig")
    flags?: string;

    @doc("Single choice option ID to match against (required for CHOICE source)")
    @example("f421cfc2-2b84-4da9-9629-011af609935a")
    choiceOptionId?: uuid;
  }

  @doc("Workflow node structure with linked list connections")
  model NodeStructure {
    @doc("Unique identifier for the node.")
    id: uuid;

    @doc("Type of the node")
    @example(NodeType.start)
    type: NodeType;

    @doc("The label for the node")
    @example("開始表單")
    label: string;
  }

  @doc("Request body for creating a new node for a workflow")
  @example(#{ type: NodeType.start, label: "開始表單" })
  model CreateNodeRequest {
    @doc("Type of the node")
    @example(NodeType.start)
    type: NodeType;

    @doc("The label for the node")
    @example("開始表單")
    label?: string;
  }

  @doc("Workflow node request model with linked list connections")
  model NodeRequest {
    ...NodeStructure;

    @doc("The condition rule for the node, only for condition nodes")
    conditionRule?: ConditionRule;

    @doc("Next node id for sequential flow (for start and section nodes)")
    next?: uuid;

    @doc("Next node id when condition is true (for condition nodes)")
    nextTrue?: uuid;

    @doc("Next node id when condition is false (for condition nodes)")
    nextFalse?: uuid;
  }

  @doc("Workflow node response model with linked list connections")
  model NodeResponse {
    ...NodeStructure;

    @doc("The section reference ID for the node, only for section nodes")
    @example("f421cfc2-2b84-4da9-9629-011af609935a")
    sectionRefId: uuid;

    @doc("The condition rule for the node, only for condition nodes")
    conditionRule: ConditionRule;

    @doc("Next node id for sequential flow (for start and section nodes)")
    next: uuid;

    @doc("Next node id when condition is true (for condition nodes)")
    nextTrue: uuid;

    @doc("Next node id when condition is false (for condition nodes)")
    nextFalse: uuid;
  }

  @doc("Request body for creating/updating workflow")
  @example(#{
    nodes: #[
      #{
        id: "4c299120-2122-484d-9933-01360749500e",
        label: "開始表單",
        type: NodeType.start,
        next: "32a86a6d-7735-4f17-8676-29b4724b524f",
      },
      #{
        id: "32a86a6d-7735-4f17-8676-29b4724b524f",
        label: "選擇組別",
        type: NodeType.section,
        next: "32a86a6d-7735-4f17-8676-29b4724b524f",
      },
      #{
        id: "32a86a6d-7735-4f17-8676-29b4724b524f",
        label: "如果[選擇組別][選擇你感興趣的組別]選擇[Full Stack Intro]",
        type: NodeType.condition,
        conditionRule: #{
          source: ConditionSource.choice,
          nodeId: "32a86a6d-7735-4f17-8676-29b4724b524f",
          key: "9a843aa0-8451-4e3b-b6a0-8c0e994e9040",
          choiceOptionId: "f421cfc2-2b84-4da9-9629-011af609935a",
        },
        nextTrue: "32a86a6d-7735-4f17-8676-29b4724b524f",
        nextFalse: "32a86a6d-7735-4f17-8676-29b4724b524f",
      },
      #{
        id: "32a86a6d-7735-4f17-8676-29b4724b524f",
        label: "如果[開發部][你每週願意花費的時間]符合[^([6-9]|[1-9][0-9]+)$]",
        type: NodeType.condition,
        conditionRule: #{
          source: ConditionSource.nonChoice,
          nodeId: "32a86a6d-7735-4f17-8676-29b4724b524f",
          key: "2ca86a6d-7735-4f17-8676-29b4724b524f",
          pattern: "^([6-9]|[1-9][0-9]+)$",
        },
        nextTrue: "32a86a6d-7735-4f17-8676-29b4724b524f",
        nextFalse: "32a86a6d-7735-4f17-8676-29b4724b524f",
      },
      #{
        id: "32a86a6d-7735-4f17-8676-29b4724b524f",
        label: "確認/送出",
        type: NodeType.end,
      }
    ],
  })
  model WorkflowRequest {
    @doc("Array of workflow nodes")
    nodes: NodeRequest[];
  }

  @doc("Response model for getting workflow")
  model WorkflowResponse {
    @doc("Array of workflow nodes")
    nodes: NodeResponse[];
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

  @doc("Create a new node for a workflow")
  @route("/forms/{formId}/workflow/nodes")
  @post
  op createNode(@path formId: uuid, @body request: CreateNodeRequest): {
    @statusCode statusCode: 201;
    @body response: NodeStructure;
  } | {
    @statusCode statusCode: 404;
    @body error: NotFound;
  } | {
    @statusCode statusCode: 400;
    @body error: ProblemDetail;
  };

  @doc("Get a specific node by its ID for reference section. Only for section nodes")
  @route("/forms/{formId}/workflow/nodes/{nodeId}")
  @get
  op getNodeReferenceSection(@path formId: uuid, @path nodeId: uuid): {
    @statusCode statusCode: 200;
    @body response: Forms.Section;
  } | {
    @statusCode statusCode: 404;
    @body error: NotFound;
  } | {
    @statusCode statusCode: 400;
    @body error: ProblemDetail;
  };

  @doc("Update a node for a workflow")
  @route("/forms/{formId}/workflow/nodes/{nodeId}")
  @delete
  op deleteNode(@path formId: uuid, @path nodeId: uuid): {
    @statusCode statusCode: 204;
  } | {
    @statusCode statusCode: 404;
    @body error: NotFound;
  } | {
    @statusCode statusCode: 400;
    @body error: ProblemDetail;
  };
}
