import "@typespec/http";
import "@typespec/openapi";

using Http;

@tag("Responses")
namespace CoreSystem.Responses {
  @doc("Request model for submitting an individual answer")
  model AnswerRequest {
    @doc("The question being answered.")
    questionId: uuid;

    @doc("The answer value (format depends on questionType from questionId).")
    value: string;
  }

  @doc("Request model for submitting a complete form response")
  model SubmitRequest {
    @doc("All answers for this form submission.")
    answers: AnswerRequest[];
  }

  @doc("Response model for a submitted form response")
  model SubmitResponse {
    @doc("The response's unique identifier.")
    id: uuid;

    @doc("The form that this response belongs to.")
    formId: uuid;

    @doc("The creation timestamp of the response.")
    createdAt: utcDateTime;

    @doc("The last updated timestamp of the response.")
    updatedAt: utcDateTime;
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

    @doc("The form that this response belongs to.")
    formId: uuid;

    @doc("The user who submitted this response.")
    submittedBy: uuid;

    @doc("All questions with their answers for this response.")
    questionAnswerPairs: QuestionAnswerForGetResponse[];

    @doc("The creation timestamp of the response.")
    createdAt: utcDateTime;

    @doc("The last updated timestamp of the response.")
    updatedAt: utcDateTime;
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

  // API Endpoints

  @doc("Submit a new response to a form.")
  @route("/forms/{formId}/responses")
  @post
  op submitFormResponse(
    @path formId: uuid,
    @body request: SubmitRequest,
  ): {
    @statusCode statusCode: 200;
    @body response: SubmitResponse;
  } | {
    @statusCode statusCode: 404;
    @body error: NotFound;
  } | {
    @statusCode statusCode: 400;
    @body error: ProblemDetail;
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
    @statusCode statusCode: 200;
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
}