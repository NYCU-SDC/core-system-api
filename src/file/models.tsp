namespace CoreSystem.Files {
	@example(#{
		id: "a12b3c4d-5e6f-7a8b-9c0d-e1f2a3b4c5d6",
		originalFilename: "resume.pdf",
		contentType: "application/pdf",
		size: 204800,
		uploadedBy: "3c5fa073-7b97-43a3-bc44-ddc98f390a08",
		createdAt: "2025-01-20T10:00:00Z",
	})
	@doc("File metadata response.")
	model FileResponse {
		@doc("The unique identifier of the file.")
		id: uuid;

		@doc("The original filename as provided by the client.")
		originalFilename: string;

		@doc("The MIME content type of the file.")
		contentType: string;

		@doc("The size of the file in bytes.")
		size: int64;

		@doc("The ID of the user who uploaded the file. Null if uploaded anonymously.")
		uploadedBy?: uuid;

		@doc("The creation timestamp of the file in RFC 3339 format.")
		createdAt: string;
	}

	@example(#{
		files: #[
			#{
				id: "a12b3c4d-5e6f-7a8b-9c0d-e1f2a3b4c5d6",
				originalFilename: "resume.pdf",
				contentType: "application/pdf",
				size: 204800,
				uploadedBy: "3c5fa073-7b97-43a3-bc44-ddc98f390a08",
				createdAt: "2025-01-20T10:00:00Z",
			},
		],
		total: 1,
		limit: 20,
		offset: 0,
	})
	@doc("Paginated list of file metadata.")
	model ListFilesResponse {
		@doc("The list of files.")
		files: FileResponse[];

		@doc("Total number of files matching the query.")
		total: int64;

		@doc("Maximum number of files returned per page.")
		limit: int32;

		@doc("Number of files skipped.")
		offset: int32;
	}
}
