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
  model Node {
    @doc("Unique identifier for the node. This would use a custom name for the node in the workflow.")
    @example("start")
    @pattern("^[a-zA-Z0-9_]+$")
    @minLength(1)
    @maxLength(255)
    id: string;

    @doc("Type of the node")
    @example(NodeType.start)
    type: NodeType;

    @doc("The label for the node")
    @example("開始表單")
    label?: string;

    @doc("The section reference ID for the node, only for section nodes")
    @example("4c299120-2122-484d-9933-01360749500e")
    sectionRefId?: uuid;

    @doc("The condition rule for the node, only for condition nodes")
    conditionRule?: ConditionRule;

    @doc("Next node id for sequential flow (for start and section nodes)")
    @example("choose_team")
    next?: string;

    @doc("Next node id when condition is true (for condition nodes)")
    @example("full_stack_intro")
    nextTrue?: string;

    @doc("Next node id when condition is false (for condition nodes)")
    @example("choose_full_stack_advanced")
    nextFalse?: string;
  }

  @doc("Complete workflow structure stored as JSONB")
  model Workflow {
    @doc("Array of workflow nodes (connections are stored within each node)")
    nodes: Node[];
  }

  @doc("Request body for creating/updating workflow")
  @example(#{
    nodes: #[
      #{
        id: "node_start",
        label: "開始表單",
        type: NodeType.start,
        next: "uuid_choose_team",
      },
      #{
        id: "choose_team",
        label: "選擇組別",
        type: NodeType.section,
        sectionRefId: "uuid_choose_team_section",
        next: "uuid_choose_full_stack_intro",
      },
      #{
        id: "choose_full_stack_intro",
        label: "如果[選擇組別][選擇你感興趣的組別]選擇[Full Stack Intro]",
        type: NodeType.condition,
        conditionRule: #{
          source: ConditionSource.choice,
          nodeId: "choose_team",
          key: "9a843aa0-8451-4e3b-b6a0-8c0e994e9040",
          choiceOptionId: "f421cfc2-2b84-4da9-9629-011af609935a",
        },
        nextTrue: "full_stack_intro",
        nextFalse: "choose_full_stack_advanced",
      },
      #{
        id: "engineering_dept_spend_time",
        label: "如果[開發部][你每週願意花費的時間]符合[^([6-9]|[1-9][0-9]+)$]",
        type: NodeType.condition,
        conditionRule: #{
          source: ConditionSource.nonChoice,
          nodeId: "engineering_dept",
          key: "2ca86a6d-7735-4f17-8676-29b4724b524f",
          pattern: "^([6-9]|[1-9][0-9]+)$",
        },
        nextTrue: "full_stack_intro",
        nextFalse: "choose_full_stack_advanced",
      },
      #{ id: "end", label: "確認/送出", type: NodeType.end }
    ],
  })
  model WorkflowRequest {
    ...Workflow;
  }

  @doc("Workflow response model")
  model WorkflowResponse {
    @doc("The form ID this workflow belongs to")
    formId: uuid;

    @doc("The complete workflow structure")
    workflow: Workflow;
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
