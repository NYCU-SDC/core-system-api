import "@typespec/http";
import "./forms.tsp";

using Http;
using CoreSystem.Forms;

@tag("Unit")
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

  @doc("Model representing a member of a unit, linking unit and member by their unique identifiers")
  model UnitMember {
    @doc("The unique identifier of the unit")
    unitId: uuid;

    @doc("The unique identifier of the member")
    memberId: uuid;
  }

  @doc("Model representing a member of an organization, linking organization and member by their unique identifiers")
  model OrgMember {
    @doc("The unique identifier of the organization")
    orgId: uuid;

    @doc("The unique identifier of the member")
    memberId: uuid;
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

  model CreateUnitRequest {
    ...BaseRequest;
  }

  model CreateOrgRequest {
    ...BaseRequest;
    slug: string; // Slug is required for organizations
  }

  model UpdateOrgRequest {
    ...BaseRequest;
    slug: string;
  }

  model UpdateUnitRequest {
    ...BaseRequest;
  }

  model ParentChildRequest {
    parentId?: uuid; // Optional, if not provided, the child will be added to the root of the organization
    childId: uuid;
    orgId: uuid;
  }

  model OrgMemberRequest {
    memberId: uuid;
  }

  model UnitMemberRequest {
    memberId: uuid;
  }

  // --- CRUD Operations for Orgs and Units ---
  @get
  @route("/orgs/{slug}/units")
  @doc("List all units, optionally filtered by parent organization ID")
  op listOrgSubUnits(
    @path slug: string,
  ): Unit[];

  @get
  @route("/orgs/{slug}/units/{id}/subunits")
  @doc("List all units, optionally filtered by parent unit ID")
  op listUnitSubUnits(
    @path slug: string,
    @path id: uuid,
  ): Unit[];

  @get
  @route("/orgs/{slug}/unit-ids")
  @doc("List all unit IDs, optionally filtered by parent organization ID")
  op listOrgSubUnitIds(
    @path slug: string,
  ): uuid[];

  @get
  @route("/orgs/{slug}/units/{id}/subunit-ids")
  @doc("List all unit IDs, optionally filtered by parent unit ID")
  op listUnitSubUnitIds(
    @path slug: string,
    @path id: uuid,
  ): uuid[];

  @get
  @route("/orgs")
  @doc("Get all organizations")
  op getAllOrganizations(): Organization[];

  @get
  @route("/orgs/{slug}")
  @doc("Get a specific unit with the slug of its organization by its unique identifier")
  op getOrgById(@path slug: string): Organization;

  @get
  @route("/orgs/{slug}/units/{id}")
  @doc("Get a specific unit with the slug of its organization by its unique identifier")
  op getUnitById(@path slug: string, @path id: uuid): Unit;

  @post
  @route("/orgs")
  @doc("Create a new unit or organization")
  op createOrg(@body Request: CreateOrgRequest): Organization;

  @post
  @route("/orgs/{slug}/units")
  @doc("Create a new unit or organization")
  op createUnit(@path slug: string, @body Request: CreateUnitRequest): Unit;

  @put
  @route("/orgs/{slug}")
  @doc("Update an existing unit or organization by its unique identifier")
  op updateOrg(
    @path slug: string,
    @body Request: UpdateOrgRequest,
  ): Organization;

  @put
  @route("/orgs/{slug}/units/{id}")
  @doc("Update an existing unit or organization by its unique identifier")
  op updateUnit(
    @path slug: string,
    @path id: uuid,
    @body Request: UpdateUnitRequest,
  ): Unit;

  @delete
  @route("/orgs/{slug}")
  @doc("Delete a specific organization by its unique identifier")
  op deleteOrg(@path slug: string): {
    @statusCode statusCode: 204;
  } | {
    @statusCode statusCode: 404;
    @body error: string;
  };

  @delete
  @route("/orgs/{slug}/units/{id}")
  @doc("Delete a specific unit of an organization by its unique identifier")
  op deleteUnit(@path slug: string, @path id: uuid): {
    @statusCode statusCode: 204;
  } | {
    @statusCode statusCode: 404;
    @body error: string;
  };

  // --- Parent-Child CRUD ---
  @post
  @route("/orgs/relations")
  @doc("Create a new parent-child relationship between units by linking them")
  op addParentChild(@body Request: ParentChildRequest): ParentChild;

  @delete
  @route("/orgs/relations/child-id/{child_id}")
  @doc("Remove a parent-child relationship between units by unlinking them")
  op removeParentChild(@path child_id: uuid): {
    @statusCode statusCode: 204;
  } | {
    @statusCode statusCode: 404;
    @body error: string;
  };

  // --- Member CRUD ---
  @post
  @route("/orgs/{slug}/members")
  @doc("Add a member to an organization")
  op addOrgMember(@path slug: string, @body Request: OrgMemberRequest): OrgMember;

  @get
  @route("/orgs/{slug}/members")
  @doc("List all members of an organization")
  op listOrgMembers(@path slug: string): User[];

  @delete
  @route("/orgs/{slug}/members/{member_id}")
  @doc("Remove an organization-member relationship")
  op removeOrgMember(@path slug: string, @path member_id: uuid): {
    @statusCode statusCode: 204;
  } | {
    @statusCode statusCode: 404;
    @body error: string;
  };

  @post
  @route("/orgs/{slug}/units/{id}/members")
  @doc("Add a member to an unit")
  op addUnitMember(@path slug: string, @path id: uuid, @body Request: UnitMemberRequest): UnitMember;

  @get
  @route("/orgs/{slug}/units/{id}/members")
  @doc("List all members of a specific unit")
  op listUnitMembers(@path slug: string, @path id: uuid): User[];


  @delete
  @route("/orgs/{slug}/units/{id}/members/{member_id}")
  @doc("Remove an unit-member relationship")
  op removeUnitMember(@path slug: string, @path id: uuid, @path member_id: uuid): {
    @statusCode statusCode: 204;
  } | {
    @statusCode statusCode: 404;
    @body error: string;
  };

  // --- Creation and List forms under Unit ---
  @doc("Create a new form under a unit.")
  @route("/orgs/{slug}/units/{unitId}/forms")
  @post
  op createUnitForm(
    @path slug: string,
    @path unitId: uuid,
    @body createFormRequest: FormRequest,
  ): Form;

  @doc("List forms under a specific unit.")
  @route("/orgs/{slug}/units/{unitId}/forms")
  @get
  op listFormsByUnit(@path slug: string, @path unitId: uuid): Form[];
}
