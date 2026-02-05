import "@typespec/http";
import "@typespec/openapi3";

using Http;
using OpenAPI;

namespace CoreSystem.Inbox {
  @doc("The structure of a user inbox message.")
  model UserInboxMessage {
    @doc("The id of this UserInboxMessage.")
    id: uuid;

    @doc("The inbox message this user inbox message refers to.")
    message: InboxFormMessage;

    ...UserInboxMessageFilters;
  }

  @doc("The deatil structure of a user inbox message with content.")
  model UserInboxMessageDetail {
    @doc("The id of this UserInboxMessage.")
    id: uuid;

    @doc("The inbox message this user inbox message refers to.")
    message: InboxFormMessage;

    @doc("The full content of inbox_message.")
    content?: CoreSystem.Forms.Form;

    ...UserInboxMessageFilters;
  }

  @doc("The filters that can be applied by the user for their inbox messages.")
  model UserInboxMessageFilters {
    @doc("Indicates whether the user has read the inbox message.")
    isRead: boolean = false;

    @doc("User can mark the inbox message as starred.")
    isStarred: boolean = false;

    @doc("User can archive the inbox message and hide it from the inbox view.")
    isArchived: boolean = false;
  }

  alias contentType = "text" | "form";

  @doc("The structure of a full inbox message.")
  model InboxFormMessage {
    @doc("The unique identifier of an inbox message.")
    id: uuid;

    @doc("The sender's unitId. If not specified, defaults to the uuid referring to a unit with the organization's name.")
    postedBy: uuid;

    @doc("The title of the inbox message.")
    title: string;

    @doc("The organization display name of the sender.")
    org: string;

    @doc("The unit display name of the sender.")
    unit: string;

    @doc("The type of the content.")
    type: contentType;

    @doc("Preview text. For forms: uses form.previewMessage if set, otherwise first 25 chars of form.description. For text: uses provided preview message if set, otherwise first 25 chars of content.")
    previewMessage: string;

    @doc("The identifier of the content referenced by the contentType.")
    contentId: uuid;

    @doc("The create timestamp of the inbox message.")
    createdAt: utcDateTime;

    @doc("The last updated timestamp of the inbox message.")
    updatedAt: utcDateTime;
  }

  alias errorResponse = {
    @statusCode statusCode: 401;
    @body error: Unauthorized;
  } | {
    @statusCode statusCode: 404;
    @body error: NotFound;
  };
}
