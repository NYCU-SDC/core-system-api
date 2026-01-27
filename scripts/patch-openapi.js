import { readFileSync, writeFileSync } from "fs";
import yaml from "js-yaml";

const OPENAPI_PATH = "./tsp-output/schema/openapi.1.0.0.yaml";

const spec = yaml.load(readFileSync(OPENAPI_PATH, "utf8"));

// 1. 強制指定 requestBody 是 multipart
const upload = spec.paths?.["/forms/{id}/cover"]?.post;

if (upload?.requestBody) {
	upload.requestBody.content = {
		"multipart/form-data": upload.requestBody.content?.["application/json"] ?? upload.requestBody.content?.[Object.keys(upload.requestBody.content)[0]]
	};
}

// 2. 強制指定 binary 欄位
const schema = spec.components?.schemas?.["Forms.FormCoverUploadRequest"];

if (schema?.properties?.coverImage) {
	schema.properties.coverImage = {
		type: "string",
		format: "binary"
	};
}

writeFileSync(OPENAPI_PATH, yaml.dump(spec, { lineWidth: -1 }), "utf8");
console.log("😉 Patched OpenAPI spec successfully.");