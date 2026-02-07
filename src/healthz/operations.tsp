using Http;

@tag("Healthz")
namespace CoreSystem.Healthz {
	@summary("Check Health Status")
	@route("/healthz")
	@get
	op checkHealthz(): {
		@statusCode statusCode: 200;
	} | {
		@statusCode statusCode: 404;
	};
}
