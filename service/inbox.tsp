import "@typespec/http";
import "@typespec/openapi";

using Http;

@tag("Inbox")
namespace CoreSystem.Inbox {
  @doc("The structure of a user inbox message with customized flag.")
  model UserInboxMessage {
    @doc("The userId of the inbox owner.")
    id: uuid;

    @doc("The inbox message this user inbox message refers to.")
    message: InboxMessage;

    @doc("The type of the user inbox message.")
    type: UserInboxMessageFilters;
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
  model InboxMessage {
    @doc("The unique identifier of an inbox message.")
    id: uuid;

    @doc("The sender's unitId. If not specified, defaults to the uuid referring to a unit with the organization's name.")
    postedBy: uuid;

    @doc("The title of the inbox message.")
    title: string;

    @doc("The subtitle of the inbox message.")
    subtitle?: string;

    @doc("The type of the content.")
    type: contentType;

    @doc("(Optional) The identifier of the content referenced by the contentType.")
    contentId?: uuid;

    @doc("The create timestamp of the inbox message.")
    createdAt: utcDateTime;

    @doc("The last updated timestamp of the inbox message.")
    updatedAt: utcDateTime;
  }

  @doc("Get all the preview of the inbox messages with pagination.")
  @route("/inbox")
  @get
  @list
  op getInboxMessages(
    @query isRead?: boolean = false,
    @query isStarred?: boolean = false,
    @query isArchived?: boolean = false,
    @query @pageIndex page?: int32 = 1,
    @query @pageSize size?: int32 = 10,
  ): {
    @statusCode statusCode: 200;
    @body body: {
      @pageItems items: UserInboxMessage[];
      totalPages: int32;
      totalItems: int32;
      currentPage: int32;
      pageSize: int32;
      hasNextPage: boolean;
    };
  } | errorResponse;

  @doc("Get the full content of a inbox message.")
  @route("/inbox/{id}")
  @get
  op getInboxMessage(@path id: uuid): {
    @statusCode statusCode: 200;
    @body message: UserInboxMessage;
  } | errorResponse;

  @doc("Update flags for the user inbox message.")
  @route("/inbox/{id}")
  @put
  op updateInboxMessageFlag(
    @path id: uuid,
    @body body:{
      isRead?: boolean = false,
      isStarred?: boolean = false,
      isArchived?: boolean = false
    }
    ): {
    @statusCode statusCode: 200;
    @body message: UserInboxMessage;
  } | errorResponse;

  alias errorResponse = {
    @statusCode statusCode: 401;
    @body error: Unauthorized;
  } | {
    @statusCode statusCode: 404;
    @body error: NotFound;
  };
}
