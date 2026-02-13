namespace CoreSystem.Unit {
	model Unit {
		...Base;
	}

	@example(#{ name: "2025 Backend", description: "Backend course", metadata: #{ year: "2025", type: "education program" } })
	model CreateUnitRequest {
		...BaseRequest;
	}

	model UpdateUnitRequest {
		...BaseRequest;
	}
}
