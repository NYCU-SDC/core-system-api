import { readFileSync, writeFileSync } from "fs";
import yaml from "js-yaml";

const OPENAPI_PATH = "./tsp-output/schema/openapi.1.0.0.yaml";

const spec = yaml.load(readFileSync(OPENAPI_PATH, "utf8"));

/* ------------------------------------------------------------------ */
/* 0. Patch info (TypeSpec 無法表達的部分) */
/* ------------------------------------------------------------------ */

spec.info = {
	...spec.info,
	description: `
## Pages
- [API Documentation (Redocly)](redocly/)
- [API Documentation (Swagger UI)](swagger/)
- [SDK Documentation (TypeDoc)](sdk/)
`.trim(),

	termsOfService: "https://sdc.nycu.club/terms",

	contact: {
		name: "NYCU Software Development Club",
		email: "contact@sdc.nycu.club",
		url: "https://github.com/NYCU-SDC/core-system-api"
	},

	license: {
		name: "Apache-2.0",
	}
};

/* ------------------------------------------------------------------ */
/* 1. 強制指定 requestBody 為 multipart/form-data */
/* ------------------------------------------------------------------ */

const upload = spec.paths?.["/forms/{id}/cover"]?.post;

if (upload?.requestBody?.content) {
	const original = upload.requestBody.content["application/json"] ?? upload.requestBody.content[Object.keys(upload.requestBody.content)[0]];

	upload.requestBody.content = {
		"multipart/form-data": original
	};
}

/* ------------------------------------------------------------------ */
/* 2. 強制 binary 欄位 (file upload) */
/* ------------------------------------------------------------------ */

const schema = spec.components?.schemas?.["Forms.FormCoverUploadRequest"];

if (schema?.properties?.coverImage) {
	schema.properties.coverImage = {
		type: "string",
		format: "binary"
	};
}

/* ------------------------------------------------------------------ */

writeFileSync(OPENAPI_PATH, yaml.dump(spec, { lineWidth: -1 }), "utf8");

console.log("😉 Patched OpenAPI spec successfully.");
