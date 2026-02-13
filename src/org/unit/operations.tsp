using Http;

@tag("Unit")
namespace CoreSystem.Unit {
	@summary("List Unit Sub-units")
	@get
	@route("/orgs/{slug}/units/{unitId}/subunits")
	@doc("List all units, optionally filtered by parent unit ID")
	op listUnitSubUnits(
		@path slug: string,
		@path unitId: uuid,

		@doc("The parent unit ID used to filter subunits by their parent-child relationship")
		@query
		parentId?: uuid,
	): Unit[];

	@summary("List Unit Sub-unit IDs")
	@get
	@route("/orgs/{slug}/units/{unitId}/subunit-ids")
	@doc("List all unit IDs, optionally filtered by parent unit ID")
	op listUnitSubUnitIds(
		@path slug: string,
		@path unitId: uuid,

		@doc("The parent unit ID used to filter subunits by their parent-child relationship")
		@query
		parentId?: uuid,
	): uuid[];

	@summary("Get Unit")
	@get
	@route("/orgs/{slug}/units/{unitId}")
	@doc("Get a specific unit with the slug of its organization by its unique identifier")
	op getUnitById(@path slug: string, @path unitId: uuid): Unit;

	@summary("Create Unit")
	@post
	@route("/orgs/{slug}/units")
	@doc("Create a new unit")
	op createUnit(@path slug: string, @body request: CreateUnitRequest): {
		@statusCode statusCode: 201;
		@body unit: Unit;
	};

	@summary("Update Unit")
	@put
	@route("/orgs/{slug}/units/{unitId}")
	@doc("Update an existing unit or organization by its unique identifier")
	op updateUnit(@path slug: string, @path unitId: uuid, @body request: UpdateUnitRequest): Unit;

	@summary("Delete Unit")
	@delete
	@route("/orgs/{slug}/units/{unitId}")
	@doc("Delete a specific unit of an organization by its unique identifier")
	op deleteUnit(@path slug: string, @path unitId: uuid): {
		@statusCode statusCode: 204;
	} | {
		@statusCode statusCode: 404;
		@body error: string;
	};
}
