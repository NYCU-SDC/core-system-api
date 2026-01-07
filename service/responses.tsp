import "@typespec/http";
import "@typespec/openapi3";

using Http;
using OpenAPI;

@tag("Responses")
namespace CoreSystem.Responses {
  @doc("Request model for submitting an individual answer")
  @example(#{
    questionId: "ee894524-4bd8-4a64-8fd2-a53b39ca94cd",
    value: "John Doe",
  })
  @example(#{
    questionId: "2b2bc4f4-71c1-478b-9e36-516eac6b36c3",
    value: "f421cfc2-2b84-4da9-9629-011af609935a;2ca86a6d-7735-4f17-8676-29b4724b524f",
  })
  model AnswerRequest {
    @doc("The question being answered.")
    questionId: uuid;

    @doc("The answer value (format depends on questionType from questionId).")
    value: string;
  }

  @doc("Request model for updating the form response")
  @example(#{
    answers: #[
      #{
        questionId: "ee894524-4bd8-4a64-8fd2-a53b39ca94cd",
        value: "John Doe",
      },
      #{
        questionId: "2b2bc4f4-71c1-478b-9e36-516eac6b36c3",
        value: "f421cfc2-2b84-4da9-9629-011af609935a;2ca86a6d-7735-4f17-8676-29b4724b524f",
      }
    ],
  })
  model UpdateRequest {
    @doc("Only the answers that are new or have been modified.")
    answers: AnswerRequest[];
  }

  @doc("Response model for creating a form response")
  model CreateResponse {
    @doc("The response's unique identifier.")
    id: uuid;
  }

  @doc("Response model for a single response in list view")
  model ResponseJSON {
    @doc("The response's unique identifier.")
    id: uuid;

    @doc("The user who submitted this response.")
    submittedBy: uuid;

    @doc("The creation timestamp of the response.")
    createdAt: utcDateTime;

    @doc("The last updated timestamp of the response.")
    updatedAt: utcDateTime;
  }

  @doc("Response model for listing all responses of a form")
  model ListResponse {
    @doc("The form ID.")
    formId: uuid;

    @doc("All responses for this form.")
    responses: ResponseJSON[];
  }

  @doc("Response model for a question with its answer")
  model QuestionAnswerForGetResponse {
    @doc("The question details.")
    questionId: uuid;

    @doc("The answer value.")
    answer: string;
  }

  @doc("Response model for getting a specific form response")
  model GetResponse {
    @doc("The response's unique identifier.")
    id: uuid;

    @doc("The current answering progress of the response.")
    progress: ResponseProgress;

    @doc("The form that this response belongs to.")
    formId: uuid;

    @doc("The current section ID.")
    sectionId: uuid;

    @doc("The user who submitted this response.")
    submittedBy: uuid;

    @doc("All questions with their answers for this response.")
    questionAnswerPairs: QuestionAnswerForGetResponse[];

    @doc("The creation timestamp of the response.")
    createdAt: utcDateTime;

    @doc("The last updated timestamp of the response.")
    updatedAt: utcDateTime;
  }

  @doc("The current progress of the response.")
  enum ResponseProgress {
    @doc("User hasn't started or not finished.")
    DRAFT: "draft",

    @doc("User has completed/passed this response.")
    SUBMITTED: "submitted"
  }

  @doc("Response model for a single answer in question answers view")
  model AnswerForQuestionResponse {
    @doc("The answer's unique identifier.")
    id: uuid;

    @doc("The response this answer belongs to.")
    responseId: uuid;

    @doc("The user who submitted this answer.")
    submittedBy: uuid;

    @doc("The answer value.")
    value: string;

    @doc("The creation timestamp of the answer.")
    createdAt: utcDateTime;

    @doc("The last updated timestamp of the answer.")
    updatedAt: utcDateTime;
  }

  @doc("Response model for getting all answers for a specific question")
  model AnswersForQuestionResponse {
    @doc("The question details.")
    question: CoreSystem.Forms.Question;

    @doc("All answers for this question.")
    answers: AnswerForQuestionResponse[];
  }

  model ResponseSections {
    @doc("Unique identifier.")
    id: uuid;

    @doc("Section title (e.g., 'Group Info').")
    title: string;
  }

  // API Endpoints

  @doc("Create a new response of a form.")
  @route("/forms/{formId}/responses")
  @post
  op createFormResponse(@path formId: uuid): {
    @statusCode statusCode: 201;
    @body response: CreateResponse;
  } | {
    @statusCode statusCode: 404;
    @body error: NotFound;
  } | {
    @statusCode statusCode: 400;
    @body error: ProblemDetail;
  };

  @doc("Update answers for the response.")
  @route("/responses/{responseId}/answers")
  @patch(#{implicitOptionality: true})
  op updateFormResponse(
    @path responseId: uuid, 
    @body req: UpdateRequest
  ): {
    @statusCode statusCode: 200;
  };

  @doc("List all responses for a specific form.")
  @route("/forms/{formId}/responses")
  @get
  op listFormResponses(@path formId: uuid): {
    @statusCode statusCode: 200;
    @body response: ListResponse;
  } | {
    @statusCode statusCode: 404;
    @body error: NotFound;
  };

  @doc("Get a specific response by ID.")
  @route("/forms/{formId}/responses/{responseId}")
  @get
  op getFormResponse(@path formId: uuid, @path responseId: uuid): {
    @statusCode statusCode: 200;
    @body response: GetResponse;
  } | {
    @statusCode statusCode: 404;
    @body error: NotFound;
  };

  @doc("Delete a response and all its associated data.")
  @route("/forms/{formId}/responses/{responseId}")
  @delete
  op deleteFormResponse(@path formId: uuid, @path responseId: uuid): {
    @statusCode statusCode: 204;
  } | {
    @statusCode statusCode: 404;
    @body error: NotFound;
  };

  @doc("Get all answers for a specific question across all form responses.")
  @route("/forms/{formId}/questions/{questionId}")
  @get
  op getQuestionAnswers(@path formId: uuid, @path questionId: uuid): {
    @statusCode statusCode: 200;
    @body response: AnswersForQuestionResponse[];
  } | {
    @statusCode statusCode: 404;
    @body error: NotFound;
  };

  @doc("List the form structure of the response.")
  @route("/responses/{responseId}/sections")
  @get
  op listResponseSections(@path responseId: uuid): {
    @statusCode statusCode: 200;
    @body response: ResponseSections[];
  } | {
    @statusCode statusCode: 404;
    @body error: NotFound;
  };
}
