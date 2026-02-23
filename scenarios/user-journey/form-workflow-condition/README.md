# Form Workflow Condition Test Scenarios

This directory contains automated QA tests for **workflow condition nodes with branching** in the Core System API. It extends the basic linear workflow from `../form-lifecycle/03-workflow-basic.http` to validate condition nodes, CHOICE-based rules, nextTrue/nextFalse branches, and (in a create-then-delete test) `conditionRule.nodeId` and rule cleanup when a section is deleted.

## Overview

This journey covers the **full form lifecycle** with a **condition workflow** (branching):

1. **Workflow condition** – Add a DETAILED_MULTIPLE_CHOICE question in Section A (2 choices: Team B, Team C). Create Section B and Section C nodes and two CONDITION nodes. Wire workflow: Condition1 (pattern = choice B) → nextTrue Section B, nextFalse Condition2; Condition2 (pattern = choice C) → nextTrue Section C, nextFalse END. Section B → Condition2 so a user can visit both B and C. Condition rules use `source: CHOICE`, `question`, and `pattern`. Then: create a temporary section, a question on it, and a condition node whose rule references that question with `nodeId`; PUT workflow including temp nodes; **delete the section first**; GET workflow and verify the temp condition’s rule has `question` nil; delete the temp condition node.
2. **Question management** – Section A: 1 question (condition from 01). Section B: 1 SHORT_TEXT (required). Section C: 1 LONG_TEXT (required). Verification asserts question counts and that all are required.
3. **Form publishing** – Confirm form is DRAFT and workflow has 7 nodes with no validation errors; publish; verify PUBLISHED and form listings.
4. **Response creation** – Create response; verify initial progress (Section A NOT_STARTED, B/C SKIPPED). Save draft with Section A answer choosing both B and C; verify DRAFT and section progress (A COMPLETED, B/C NOT_STARTED). Patch Section A to C only; verify section progress (A COMPLETED, B SKIPPED, C NOT_STARTED). PATCH Section B (expect 400 – skipped section); PATCH Section C (200). Verify section progress; submit with Section A (C) + Section C answer; get response; list form responses.

**Flow:** START → Section A → Condition1 → [match B → Section B / else → Condition2] → Condition2 → [match C → Section C / else → END]. Section A is DETAILED_MULTIPLE_CHOICE with 2 options (Team B, Team C). Pattern is include-style (value contains choice id). Section B’s next is Condition2 so choosing both B and C visits both sections. No match at Condition2 goes to END.

## Prerequisite

Run the form-lifecycle up to and including **Phase 3** so the basic workflow exists:

- `../form-lifecycle/01-setup.http`
- `../form-lifecycle/02-form-creation.http`
- `../form-lifecycle/03-workflow-basic.http`

This journey imports `../form-lifecycle/03-workflow-basic.http` to obtain `formId`, `startNodeId`, `endNodeId`, `sectionNodeId`, `sectionNodeLabel`, and `getFinalWorkflow`.

## Test Files

Execute in order:

1. **`01-workflow-condition.http`** – Condition nodes and branches
   - Imports `../form-lifecycle/03-workflow-basic.http`
   - Create DETAILED_MULTIPLE_CHOICE question in Section A (2 choices: Team B, Team C)
   - Create Section B and Section C nodes; create two CONDITION nodes
   - PUT workflow: conditionRule (CHOICE, question, pattern); Section B → Condition2 so both branches can be visited; GET and verify 7-node structure
   - **Create-then-delete:** Create temp section, question on it, temp condition node with rule (question, pattern, nodeId = temp section); PUT workflow including temp nodes; **delete section first**; GET workflow and verify temp condition’s rule has `question` nil; delete temp condition node

2. **`02-question-management.http`** – Question management
   - Imports `./01-workflow-condition.http` (uses `getFinalWorkflowWithCondition`)
   - Section A: 1 question from 01. Section B: 1 SHORT_TEXT (required). Section C: 1 LONG_TEXT (required).
   - Verifies each section has expected question count and that Section A, B, C questions are required (`verifyQuestionDeletion`)

3. **`03-form-publishing.http`** – Publishing and lifecycle
   - Imports `./02-question-management.http`
   - Get form (DRAFT), verify workflow has 7 nodes and no validation errors; publish; verify PUBLISHED; verify form in listings; exports `getFormFinalState` for 04

4. **`04-response-creation.http`** – Response and answer submission (user path: choose C only)
   - Imports `./03-form-publishing.http` (uses `getFormFinalState`)
   - Create response; verify progress (Section A NOT_STARTED, B/C SKIPPED)
   - Save draft with Section A answer choosing both B and C; verify DRAFT and section progress (A COMPLETED, B/C NOT_STARTED)
   - Patch Section A to C only; verify section progress (A COMPLETED, B SKIPPED, C NOT_STARTED)
   - PATCH Section B (expect 400); PATCH Section C (200); verify section progress
   - Submit with Section A (C) + Section C answer; get response; list form responses

## Setup

1. Copy the environment file:

   ```bash
   cp .env.example .env
   ```

2. Edit `.env` with your configuration:

   ```env
   BASE_URL=http://127.0.0.1:4010
   LOGIN_USER_ID=<your-user-uuid>
   ```

3. Ensure the API server is running at the specified `BASE_URL`.

4. Ensure form-lifecycle 01–03 have been run (same env) so the imported workflow exists.

## Running Tests

### Run single test file

```bash
httpyac send scenarios/user-journey/form-workflow-condition/01-workflow-condition.http
```

### Run with specific environment

```bash
httpyac send scenarios/user-journey/form-workflow-condition/*.http --env dev
```

## Dependencies

- **form-lifecycle** – `../form-lifecycle/03-workflow-basic.http` (which in turn uses 01-setup, 02-form-creation)
- **httpyac** – HTTP test runner
- **Node.js** – For assertions in `??` blocks
- Running Core System API instance

## Relationship to other scenarios

- **form-lifecycle** – Provides the base form and linear workflow (01–03). This journey extends it with condition branching, then runs question management, publishing, and response creation in one self-contained flow.

## Troubleshooting

### Variable not found / import errors

- Run form-lifecycle 01, 02, and 03 first so `formId`, `sectionNodeId`, `startNodeId`, `endNodeId`, etc. are set.

### Authentication failures

- Same as form-lifecycle: verify `LOGIN_USER_ID` in `.env` and that internal login is enabled.

## Contributing

When adding or changing test files:

1. Follow the naming convention: `NN-description.http`.
2. Use `@import ../form-lifecycle/03-workflow-basic.http` (or the appropriate form-lifecycle file) for variables.
3. Update this README with new steps and descriptions.
