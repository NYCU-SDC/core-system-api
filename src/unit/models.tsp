import "@typespec/http";
import "@typespec/openapi3";

using Http;
using OpenAPI;

namespace CoreSystem.Unit {
  @doc("Base model, containing common fields for both units and organizations.")
  model Base {
    @doc("The unit's unique identifier.")
    id: uuid;

    @doc("The name of the unit or organization")
    name: string;

    @doc("A brief description of the unit or organization")
    description: string;

    @doc("Metadata for the unit or organization, can include additional information like contact details, address, etc.")
    metadata: Record<string>;

    @doc("The creation timestamp of the unit or organization")
    createdAt: utcDateTime;

    @doc("The last updated timestamp of the unit or organization")
    updatedAt: utcDateTime;
  }

  @doc("Base Request model, containing common fields for updating units and organizations.")
  @example(#{
    name: "2025 Backend",
    description: "Backend course - Updated",
    metadata: #{ year: "2025", type: "education program" },
  })
  model BaseRequest {
    @doc("The name of the unit or organization")
    name: string;

    @doc("A brief description of the unit or organization")
    description: string;

    @doc("Metadata for the unit or organization, can include additional information like contact details, address, etc.")
    metadata: Record<string>;
  }

  model Unit {
    ...Base;
  }

  model Organization {
    ...Base;

    @doc("Unique slug for the organization, used for URL routing and identification")
    slug: string;
  }

  @doc("Model representing a member of an organization, linking organization and member by their unique identifiers")
  model OrgMember {
    @doc("The unique identifier of the organization")
    orgId: uuid;

    @doc("The unique identifier of the member")
    memberId: uuid;
  }

  @doc("Response model for organization member with full user details")
  model OrgMemberResponse {
    @doc("The unique identifier of the organization")
    orgId: uuid;

    @doc("Full user details including emails")
    member: CoreSystem.User.User;
  }

  @doc("The completion status of the form for the user")
  enum UserFormStatus {
    not_started: "NOT_STARTED",
    in_progress: "IN_PROGRESS",
    completed: "COMPLETED",
  }

  @doc("Response model for listing user forms with status")
  model UserForm {
    @doc("The unique identifier of the form")
    id: uuid;

    @doc("The title of the form")
    title: string;

    @doc("The deadline of the form")
    deadline: utcDateTime;

    @doc("The completion status of the form for the current user")
    status: UserFormStatus;
  }

  @doc("Model representing a parent-child relationship between units, allowing for hierarchical structures")
  model ParentChild {
    @doc("The unique identifier of the parent unit, which can be left null if the child is root unit of the organization.")
    parentId?: uuid;

    @doc("The unique identifier of the child unit")
    childId: uuid;

    @doc("The unique identifier of the units' organization")
    orgId: uuid;
  }

  @example(#{
    name: "NYCU SDC2",
    description: "陽明交大軟體開發社",
    slug: "nycu-sdc1",
    metadata: #{ type: "club" },
  })
  model CreateOrgRequest {
    ...BaseRequest;
    slug: string; // Slug is required for organizations
  }

  @example(#{
    name: "2025 Backend",
    description: "Backend course",
    metadata: #{ year: "2025", type: "education program" },
  })
  model CreateUnitRequest {
    ...BaseRequest;
  }

  model UpdateOrgRequest {
    ...BaseRequest;
    slug: string;
  }

  model UpdateUnitRequest {
    ...BaseRequest;
  }

  @example(#{
    parentId: "3c5fa073-7b97-43a3-bc44-ddc98f390a08",
    childId: "d26e9c90-4747-496b-9953-7e7c4f97643f",
    orgId: "3c5fa073-7b97-43a3-bc44-ddc98f390a08",
  })
  model ParentChildRequest {
    parentId?: uuid; // Optional, if not provided, the child will be added to the root of the organization
    childId: uuid;
    orgId: uuid;
  }

  @example(#{ email: "123@gmail.com" })
  model OrgMemberRequest {
    email: string;
  }
}
