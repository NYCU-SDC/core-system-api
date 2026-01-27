/** @type {import('orval').Config} */
module.exports = {
	api: {
		input: "./tsp-output/schema/openapi.1.0.0.yaml",
		output: {
			target: "./packages/sdk/src/generated/index.ts",
			schemas: "./packages/sdk/src/generated/model",
			client: "fetch",
			enumGenerationType: "enum",
			clean: true,
			prettier: true
		}
	}
};
