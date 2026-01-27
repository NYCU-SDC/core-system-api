/** @type {import('orval').Config} */
module.exports = {
	api: {
		input: "./tsp-output/schema/openapi.1.0.0.yaml",
		output: {
			target: "./packages/sdk/src/index.ts",
			schemas: "./packages/sdk/src/model",
			client: "fetch",
			clean: true,
			prettier: true
		}
	}
};
