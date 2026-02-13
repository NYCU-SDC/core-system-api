using Http;

@tag("Unit")
namespace CoreSystem.Unit {
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
}
