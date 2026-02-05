import "@typespec/http";
import "@typespec/openapi3";

using Http;
using OpenAPI;

@tag("Form Workflow")
namespace CoreSystem.FormWorkflow {
  @doc("Get workflow for a form")
  @route("/forms/{id}/workflow")
  @get
  op getWorkflow(@path id: uuid): {
    @statusCode statusCode: 200;
    @body response: GetWorkflowResponse;
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
