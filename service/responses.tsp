import "@typespec/http";
import "@typespec/openapi3";

using Http;
using OpenAPI;

@tag("Responses")
namespace CoreSystem.Responses {
  @example(#{
    questionId: "ee894524-4bd8-4a64-8fd2-a53b39ca94cd",
    value: "John Doe",
  })
  @example(#{
    questionId: "2b2bc4f4-71c1-478b-9e36-516eac6b36c3",
    value: "f421cfc2-2b84-4da9-9629-011af609935a;2ca86a6d-7735-4f17-8676-29b4724b524f",
  })
  @doc("Request model for submitting an individual answer")
  model AnswerJSON {
    @doc("The question being answered.")
    questionId: uuid;

    @doc("The answer value (format depends on questionType from questionId).")
    value: string;
  }

  @doc("Request model for update or submit the form response.")
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
  model AnswersRequest {
    @doc("The answers to be saved. Can contain a partial subset for drafts or the full set for submission.")
    answers: AnswerJSON[];
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

  @doc("Model for a question with its answer in preview view")
  model PreviewQuestion {
    @doc("The question details.")
    question: CoreSystem.Forms.QuestionResponse;

    @doc("The answer value.")
    answer: string;
  }

  @doc("Model for a single section in preview view")
  model PreviewSection {
    @doc("The section title.")
    sectionTitle: string;

    @doc("All questions with their answers in this section.")
    questionAnswerPairs: PreviewQuestion[];
  }

  @doc("Response model for getting a specific form response")
  model GetResponse {
    @doc("The response's unique identifier.")
    id: uuid;

    @doc("The current answering progress of the response.")
    progress: ResponseProgress;

    @doc("The form that this response belongs to.")
    formId: uuid;

    @doc("The user who submitted this response.")
    submittedBy: uuid;

    @doc("All questions with their answers for this response.")
    questionAnswerPairs: PreviewSection[];
  }

  @doc("The current progress of the response.")
  enum ResponseProgress {
    @doc("User hasn't started or not finished.")
    draft: "DRAFT",

    @doc("User has completed/passed this response.")
    submitted: "SUBMITTED",
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
    question: CoreSystem.Forms.QuestionResponse;

    @doc("All answers for this question.")
    answers: AnswerForQuestionResponse[];
  }

  @doc("Response model for a single section in response sections view")
  model ResponseSections {
    @doc("Unique identifier.")
    id: uuid;

    @doc("Section title (e.g., 'Group Info').")
    title: string;
  }

  @example(#{
    sections: #[
      #{ id: "a1b2c3d4-e5f6-7890-abcd-ef1234567890", title: "Group Info" },
      #{
        id: "0f9e8d7c-6b5a-4321-0fed-cba987654321",
        title: "Self Introduction",
      }
    ],
  })
  @doc("Response model for listing all sections of a response")
  model ListSectionResponse {
    @doc("The section list of the response.")
    sections: ResponseSections[];
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
  };

  @doc("Submit all the answer in the form response.")
  @route("/responses/{responseId}/submit")
  @post
  op submitFormResponse(@path responseId: uuid): {
    @statusCode statusCode: 200;
    @body req: AnswersRequest;
  };

  @doc("Update answers for the response.")
  @route("/responses/{responseId}/answers")
  @patch(#{ implicitOptionality: true })
  op updateFormResponse(@path responseId: uuid, @body req: AnswersRequest): {
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

  @doc("List the form structure of the response.")
  @route("/responses/{responseId}/sections")
  @get
  op listResponseSections(@path responseId: uuid): {
    @statusCode statusCode: 200;
    @body response: ListSectionResponse;
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
}
