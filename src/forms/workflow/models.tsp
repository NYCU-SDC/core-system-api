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

		@doc("The question ID to check against")
		@example("9a843aa0-8451-4e3b-b6a0-8c0e994e9040")
		question: uuid;

		@doc("Regex pattern to match against. If source is NON_CHOICE, the regex is matched against the answer value. If source is CHOICE, the answer is an array of selected choice option IDs, and this regex is matched against each element; the condition passes if any element matches (e.g. use an exact-match UUID regex like ^<uuid>$).")
		@format("regex")
		@example("^([6-9]|[1-9][0-9]+)$") // non-choice source
		@example("^f421cfc2-2b84-4da9-9629-011af609935a$") // choice source (any selected option ID equals this UUID)
		pattern: string;
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

	@doc("Validation info type enum for workflow validation errors")
	enum ValidationInfoType {
		@doc("Workflow-level validation failed")
		workflowValidationFailed: "workflow_validation_failed",

		@doc("Graph structure validation failed")
		graphValidationFailed: "graph_validation_failed",

		@doc("Individual node validation failed")
		nodeValidationFailed: "node_validation_failed",

		@doc("Unknown validation error")
		unknownError: "unknown",
	}

	@doc("Validation information for workflow validation errors")
	model ValidationInfo {
		@doc("The type/category of validation error")
		@example(ValidationInfoType.graphValidationFailed)
		type: ValidationInfoType;

		@doc("The ID of the node that caused the validation error")
		@example("b23f2668-c2dc-4213-88fe-eceedff46398")
		nodeId: uuid;

		@doc("Human-readable description of the validation error")
		@example("section node 'b23f2668-c2dc-4213-88fe-eceedff46398' must have a 'next' field")
		message: string;
	}

	@doc("Response model for getting a workflow, includes workflow nodes and validation info")
	model GetWorkflowResponse {
		@doc("Array of workflow nodes")
		workflow: NodeResponse[];

		@doc("Array of validation information/errors for the workflow")
		info: ValidationInfo[];
	}
}