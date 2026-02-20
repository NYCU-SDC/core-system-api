using Http;

@tag("Files")
namespace CoreSystem.Files {
	@summary("Download File")
	@doc("Download a file by its ID. Returns the raw file content with appropriate Content-Type and Content-Disposition headers.")
	@get
	@route("/files/{id}")
	op downloadFile(@path id: uuid): {
		@statusCode statusCode: 200;
		@header("Content-Type") contentType: string;
		@header("Content-Disposition") contentDisposition: string;
		@body data: bytes;
	} | {
		@statusCode statusCode: 404;
		@body error: NotFound;
	};

	@summary("Get File Info")
	@doc("Get metadata of a file by its ID, without downloading the binary content.")
	@get
	@route("/files/{id}/info")
	op getFileInfo(@path id: uuid): {
		@statusCode statusCode: 200;
		@body file: FileResponse;
	} | {
		@statusCode statusCode: 401;
		@body error: Unauthorized;
	} | {
		@statusCode statusCode: 404;
		@body error: NotFound;
	};

	@summary("List All Files")
	@doc("List all files with pagination. Requires authentication.")
	@get
	@route("/files")
	op listFiles(
		@query
		@doc("Maximum number of files to return. Defaults to 20.")
		limit?: int32,

		@query
		@doc("Number of files to skip. Defaults to 0.")
		offset?: int32,
	): {
		@statusCode statusCode: 200;
		@body response: ListFilesResponse;
	} | {
		@statusCode statusCode: 400;
		@body error: BadRequest;
	} | {
		@statusCode statusCode: 401;
		@body error: Unauthorized;
	};

	@summary("List My Files")
	@doc("List files uploaded by the currently authenticated user.")
	@get
	@route("/files/me")
	op listMyFiles(): {
		@statusCode statusCode: 200;
		@body files: FileResponse[];
	} | {
		@statusCode statusCode: 401;
		@body error: Unauthorized;
	};
}
