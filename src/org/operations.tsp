using Http;

@tag("Unit")
namespace CoreSystem.Unit {
	@summary("List Organization Sub-units")
	@get
	@route("/orgs/{slug}/units")
	@doc("List all units, optionally filtered by parent organization ID")
	op listOrgSubUnits(
		@path 
		slug: string,

		@doc("The parent unit ID used to filter subunits by their parent-child relationship")
		@query
		parentId?: uuid,
	): Unit[];

	@summary("List Organization Sub-unit IDs")
	@get
	@route("/orgs/{slug}/unit-ids")
	@doc("List all unit IDs, optionally filtered by parent organization ID")
	op listOrgSubUnitIds(
		@path
		slug: string,

		@doc("The parent unit ID used to filter subunits by their parent-child relationship")
		@query
		parentId?: uuid,
	): uuid[];

	@summary("Get All Organizations")
	@get
	@route("/orgs")
	@doc("Get all organizations")
	op getAllOrganizations(): Organization[];

	@summary("List Organizations of Current User")
	@get
	@route("/orgs/me")
	@doc("List all organizations of current user")
	op listOrganizationsOfCurrentUser(): Organization[];

	@summary("Get Organization")
	@get
	@route("/orgs/{slug}")
	@doc("Get a specific organization by its unique identifier")
	op getOrgById(@path slug: string): Organization;

	@summary("Create Organization")
	@post
	@route("/orgs")
	@doc("Create a new organization")
	op createOrg(@body request: CreateOrgRequest): {
		@statusCode statusCode: 201;
		@body organization: Organization;
	};

	@summary("Update Organization")
	@put
	@route("/orgs/{slug}")
	@doc("Update an existing organization by its unique identifier")
	op updateOrg(@path slug: string, @body request: UpdateOrgRequest): Organization;

	@summary("Delete Organization")
	@delete
	@route("/orgs/{slug}")
	@doc("Delete a specific organization by its unique identifier")
	op deleteOrg(@path slug: string): {
		@statusCode statusCode: 204;
	} | {
		@statusCode statusCode: 404;
		@body error: string;
	};

	// --- Current User Forms ---
	@summary("List Forms of Current User")
	@doc("List all forms of current user")
	@route("/forms/me")
	@get
	op listFormsOfCurrentUser(): UserForm[];
}
