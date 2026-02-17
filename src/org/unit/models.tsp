namespace CoreSystem.Unit {
	@example(#{
		id: "d26e9c90-4747-496b-9953-7e7c4f97643f",
		name: "Backend Team",
		description: "Backend development team",
		metadata: #{ tech: "Go, Node.js" },
		createdAt: utcDateTime.fromISO("2024-03-01T09:00:00Z"),
		updatedAt: utcDateTime.fromISO("2024-11-15T14:20:00Z"),
	})
	model Unit {
		...Base;
	}

	@example(#{ name: "2025 Backend", description: "Backend course", metadata: #{ year: "2025", type: "education program" } })
	model CreateUnitRequest {
		...BaseRequest;
	}

	@example(#{ name: "Updated Backend Team", description: "Backend and Infrastructure team", metadata: #{ tech: "Go, Node.js, Kubernetes" } })
	model UpdateUnitRequest {
		...BaseRequest;
	}
}
