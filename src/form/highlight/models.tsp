namespace CoreSystem.Forms {
	@doc("A choice with its response count for highlight statistics.")
	@example(#{ choiceId: "f421cfc2-2b84-4da9-9629-011af609935a", name: "大一", count: 42 })
	model HighlightChoice {
		@doc("The unique identifier of the choice.")
		choiceId: uuid;

		@doc("The name/text of the choice.")
		name: string;

		@doc("Number of responses (draft + submitted) that selected this choice.")
		count: int32;
	}

	@doc("Response model for a form's highlight question statistics. When no highlight is configured, questionId is null and all other fields are null or empty.")
	@example(#{
		questionId: "ee894524-4bd8-4a64-8fd2-a53b39ca94cd",
		questionTitle: "你的年級是？",
		displayTitle: "年級分佈統計",
		choices: #[
			#{ choiceId: "f421cfc2-2b84-4da9-9629-011af609935a", name: "大一", count: 42 },
			#{ choiceId: "a1b2c3d4-e5f6-7890-abcd-ef1234567890", name: "大二", count: 30 },
		],
	})
	@example(#{ questionId: null, questionTitle: null, displayTitle: null, choices: #[] })
	model HighlightResponse {
		@doc("The highlighted question's unique identifier. Null if no highlight is configured.")
		questionId: uuid | null;

		@doc("The current title of the highlighted question, fetched from the question. Null if no highlight is configured.")
		questionTitle: string | null;

		@doc("The display title shown on the dashboard. Equals stored custom title if set, otherwise falls back to questionTitle. Null if no highlight is configured.")
		displayTitle: string | null;

		@doc("Response counts per choice option. Empty array if no highlight is configured.")
		choices: HighlightChoice[];
	}

	@doc("Request body for setting or clearing a form's highlight question.")
	@example(#{ questionId: "ee894524-4bd8-4a64-8fd2-a53b39ca94cd", displayTitle: "年級分佈統計" })
	@example(#{ questionId: "ee894524-4bd8-4a64-8fd2-a53b39ca94cd" })
	@example(#{ questionId: null })
	model HighlightRequest {
		@doc("The question ID to highlight. Must be a choice-based question (singleChoice, multipleChoice, dropdown, detailedMultipleChoice). Set to null to clear the entire highlight.")
		questionId: uuid | null;

		@doc("Custom display title for the highlight. If omitted or null, the backend falls back to the question's current title. Ignored when questionId is null.")
		displayTitle?: string | null;
	}
}
