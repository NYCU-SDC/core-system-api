namespace CoreSystem {
	@format("uuid")
	scalar uuid extends string;

	@doc("Markdown source text edited and stored by the admin interface.")
	@format("markdown")
	scalar MarkdownContent extends string;

	@doc("HTML rendered from Markdown for frontend display.")
	@format("html")
	scalar HtmlContent extends string;
}
