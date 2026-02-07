using Http;

@tag("Unit")
namespace CoreSystem.Unit {
	// --- CRUD Operations for Orgs and Units ---
	@summary("List Organization Sub-units")
	@get
	@route("/orgs/{slug}/units")
	@doc("List all units, optionally filtered by parent organization ID")
	op listOrgSubUnits(
		@path slug: string,

		@doc("The parent unit ID used to filter subunits by their parent-child relationship")
		@query
		parentId?: uuid,
	): Unit[];

	@summary("List Unit Sub-units")
	@get
	@route("/orgs/{slug}/units/{id}/subunits")
	@doc("List all units, optionally filtered by parent unit ID")
	op listUnitSubUnits(
		@path slug: string,
		@path id: uuid,

		@doc("The parent unit ID used to filter subunits by their parent-child relationship")
		@query
		parentId?: uuid,
	): Unit[];

	@summary("List Organization Sub-unit IDs")
	@get
	@route("/orgs/{slug}/unit-ids")
	@doc("List all unit IDs, optionally filtered by parent organization ID")
	op listOrgSubUnitIds(
		@path slug: string,

		@doc("The parent unit ID used to filter subunits by their parent-child relationship")
		@query
		parentId?: uuid,
	): uuid[];

	@summary("List Unit Sub-unit IDs")
	@get
	@route("/orgs/{slug}/units/{id}/subunit-ids")
	@doc("List all unit IDs, optionally filtered by parent unit ID")
	op listUnitSubUnitIds(
		@path slug: string,
		@path id: uuid,

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
	@doc("Get a specific unit with the slug of its organization by its unique identifier")
	op getOrgById(@path slug: string): Organization;

	@summary("Get Unit")
	@get
	@route("/orgs/{slug}/units/{id}")
	@doc("Get a specific unit with the slug of its organization by its unique identifier")
	op getUnitById(@path slug: string, @path id: uuid): Unit;

	@summary("Create Organization")
	@post
	@route("/orgs")
	@doc("Create a new organization")
	op createOrg(@body Request: CreateOrgRequest): {
		@statusCode statusCode: 201;
		@body organization: Organization;
	};

	@summary("Create Unit")
	@post
	@route("/orgs/{slug}/units")
	@doc("Create a new unit")
	op createUnit(@path slug: string, @body Request: CreateUnitRequest): {
		@statusCode statusCode: 201;
		@body unit: Unit;
	};

	@summary("Update Organization")
	@put
	@route("/orgs/{slug}")
	@doc("Update an existing unit or organization by its unique identifier")
	op updateOrg(@path slug: string, @body Request: UpdateOrgRequest): Organization;

	@summary("Update Unit")
	@put
	@route("/orgs/{slug}/units/{id}")
	@doc("Update an existing unit or organization by its unique identifier")
	op updateUnit(@path slug: string, @path id: uuid, @body Request: UpdateUnitRequest): Unit;

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

	@summary("Delete Unit")
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
	@summary("Add Parent-Child Relationship")
	@post
	@route("/orgs/relations")
	@doc("Create a new parent-child relationship between units by linking them")
	op addParentChild(@body Request: ParentChildRequest): {
		@statusCode statusCode: 201;
		@body parentChild: ParentChild;
	};

	@summary("Remove Parent-Child Relationship")
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
	@summary("Add Organization Member")
	@post
	@route("/orgs/{slug}/members")
	@doc("Add a member to an organization")
	op addOrgMember(@path slug: string, @body Request: OrgMemberRequest): {
		@statusCode statusCode: 201;
		@body orgMember: OrgMemberResponse;
	};

	@summary("List Organization Members")
	@get
	@route("/orgs/{slug}/members")
	@doc("List all members of an organization")
	op listOrgMembers(@path slug: string): CoreSystem.User.User[];

	@summary("Remove Organization Member")
	@delete
	@route("/orgs/{slug}/members/{member_id}")
	@doc("Remove an organization-member relationship")
	op removeOrgMember(@path slug: string, @path member_id: uuid): {
		@statusCode statusCode: 204;
	} | {
		@statusCode statusCode: 404;
		@body error: string;
	};

	// --- Creation and List forms under Organization ---
	@summary("Create Organization Form")
	@doc("Create a new form under an organization.")
	@route("/orgs/{slug}/forms")
	@post
	op createOrgForm(@path slug: string, @body createFormRequest: CoreSystem.Forms.FormRequest): {
		@statusCode statusCode: 201;
		@body form: CoreSystem.Forms.Form;
	};

	@summary("List Forms by Organization")
	@doc("List forms under a specific organization.")
	@route("/orgs/{slug}/forms")
	@get
	op listFormsByOrg(@path slug: string): CoreSystem.Forms.Form[];

	// --- Current User Forms ---
	@summary("List Forms of Current User")
	@doc("List all forms of current user")
	@route("/forms/me")
	@get
	op listFormsOfCurrentUser(): UserForm[];
}
