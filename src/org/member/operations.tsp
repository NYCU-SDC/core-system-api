using Http;

@tag("Unit")
namespace CoreSystem.Unit {
	@summary("Add Organization Member")
	@post
	@route("/orgs/{slug}/members")
	@doc("Add a member to an organization")
	op addOrgMember(@path slug: string, @body request: OrgMemberRequest): {
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
	@route("/orgs/{slug}/members/{memberId}")
	@doc("Remove an organization-member relationship")
	op removeOrgMember(@path slug: string, @path memberId: uuid): {
		@statusCode statusCode: 204;
	} | {
		@statusCode statusCode: 404;
		@body error: string;
	};
}
