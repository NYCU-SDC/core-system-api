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

    @doc("Condition node - represents a condition check node")
    condition: "CONDITION",
  }

  enum CreateNodeRequestType {
    @doc("Create a section node - represents a form section")
    section: "SECTION",

    @doc("Create a condition node - represents a condition check node")
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
  @example(#{ type: CreateNodeRequestType.section })
  model CreateNodeRequest {
    @doc("Type of the node")
    @example(CreateNodeRequestType.section)
    type: CreateNodeRequestType;
  }

  @doc("Workflow node request model with linked list connections")
  model NodeRequest {
    @doc("Unique identifier for the node.")
    id: uuid;

    @doc("The label for the node")
    @example("開始表單")
    label: string;

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

    @doc("The condition rule for the node, only for condition nodes")
    conditionRule: ConditionRule;

    @doc("Next node id for sequential flow (for start and section nodes)")
    next: uuid;

    @doc("Next node id when condition is true (for condition nodes)")
    nextTrue: uuid;

    @doc("Next node id when condition is false (for condition nodes)")
    nextFalse: uuid;
  }

  // API Endpoints

  @doc("Get workflow for a form")
  @route("/forms/{id}/workflow")
  @get
  op getWorkflow(@path id: uuid): {
    @statusCode statusCode: 200;
    @body response: NodeResponse[];
  } | {
    @statusCode statusCode: 404;
    @body error: NotFound;
  };

  @doc("Update workflow for a form")
  @route("/forms/{id}/workflow")
  @put
  op updateWorkflow(@path id: uuid, @body request: NodeRequest[]): {
    @statusCode statusCode: 200;
    @body response: NodeResponse[];
  } | {
    @statusCode statusCode: 404;
    @body error: NotFound;
  } | {
    @statusCode statusCode: 400;
    @body error: ProblemDetail;
  };

  @doc("Activate workflow for a form")
  @route("/forms/{id}/workflow/activate")
  @post
  op activateWorkflow(@path id: uuid, @body request: NodeRequest[]): {
    @statusCode statusCode: 200;
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

  @doc("Delete a node for a workflow")
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
