namespace CoreSystem {
	@format("uuid")
	scalar uuid extends string;

	@doc("A ProseMirror document JSON payload used by Tiptap editors.")
	model ProseMirrorDocument {
		@doc("The root node type. Always `doc` for a ProseMirror document.")
		type: "doc";

		@doc("Child nodes in the ProseMirror document.")
		content?: ProseMirrorNode[];
	}

	@doc("A ProseMirror node.")
	model ProseMirrorNode {
		@doc("The node type, such as `paragraph`, `heading`, or `text`.")
		type: string;

		@doc("Text content for text nodes.")
		text?: string;

		@doc("Node attributes.")
		attrs?: Record<unknown>;

		@doc("Child nodes of this node.")
		content?: ProseMirrorNode[];

		@doc("Marks applied to this node, such as bold or italic.")
		marks?: ProseMirrorMark[];
	}

	@doc("A ProseMirror mark.")
	model ProseMirrorMark {
		@doc("The mark type, such as `bold`, `italic`, or `link`.")
		type: string;

		@doc("Mark attributes.")
		attrs?: Record<unknown>;
	}

	@doc("HTML rendered from ProseMirror content for frontend display.")
	@format("html")
	scalar HtmlContent extends string;
}
