import "@typespec/http";

using Http;

@tag("Unit")
namespace CoreSystem.Unit {
  @doc("Currently, there are 2 types of units: `unit` and `organization`.")
  enum UnitType {
    unit: 0,
    organization: 1,
  }

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

    @doc("The type of the unit, either 'unit' or 'organization'")
    type: UnitType;

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
    @doc("The unique identifier of the parent unit")
    parentId: uuid;

    @doc("The unique identifier of the child unit")
    childId: uuid;
  }

  model CreateUnitRequest {
    ...BaseRequest;
    type: UnitType.unit;
  }

  model CreateOrgRequest {
    ...BaseRequest;
    type: UnitType.organization; // Type is fixed to organization for org creation
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
    parentId: uuid;
    childId: uuid;
  }

  // --- CRUD Operations for Orgs and Units ---
  @get
  @route("/orgs/{slug}/units")
  @doc("List all units, optionally filtered by parent unit ID")
  op listOrgSubUnits(
    @path slug: string,
    @doc("The parent unit ID used to filter subunits by their parent-child relationship")
    @query
    parentId?: uuid,
  ): Unit[];

  @get
  @route("/orgs/{slug}/units/{id}/subunits")
  @doc("List all units, optionally filtered by parent unit ID")
  op listSubUnits(
    @path slug: string,
    @path id: uuid,
    @doc("The parent unit ID used to filter subunits by their parent-child relationship")
    @query
    parentId?: uuid,
  ): Unit[];

  @get
  @route("/orgs/{slug}")
  @doc("Get a specific unit with the slug of its organization by its unique identifier")
  op getOrgBySlug(
    @path slug: string,
  ): Organization;

  @get
  @route("/orgs/{slug}/units/{id}")
  @doc("Get a specific unit with the slug of its organization by its unique identifier")
  op getUnitById(
    @path slug: string,
    @path id: uuid
  ): Unit;

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
  op updateOrg(@path slug: string, @body Request: UpdateOrgRequest): Organization;

  @put
  @route("/orgs/{slug}/units/{id}")
  @doc("Update an existing unit or organization by its unique identifier")
  op updateUnit(@path slug: string, @path id: uuid, @body Request: UpdateUnitRequest): Unit;

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
  @get
  @route("/orgs/relations/{parentId}")
  @doc("List all child units under a specified parent unit")
  op listChildUnits(@path parentId: uuid): uuid[];

  @post
  @route("/orgs/relations")
  @doc("Create a new parent-child relationship between units by linking them")
  op addParentChild(@body Request: ParentChildRequest): ParentChild;

  @delete
  @route("/orgs/relations")
  @doc("Remove a parent-child relationship between units by unlinking them")
  op removeParentChild(@body Request: ParentChildRequest): {
    @statusCode statusCode: 204;
  } | {
    @statusCode statusCode: 404;
    @body error: string;
  };
}
