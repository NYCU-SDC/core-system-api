import fs from "fs";
import yaml from "js-yaml";
import path from "path";

const SPEC_FILE = "tsp-output/schema/openapi.1.0.0.yaml";
const SRC_DIR = "src";

// Helper: Parse TypeSpec file to extract route patterns
const parseTspRoutes = tspFilePath => {
	if (!fs.existsSync(tspFilePath)) return [];

	const content = fs.readFileSync(tspFilePath, "utf8");
	const routes = [];

	// Match @route("...") patterns
	const routeRegex = /@route\("([^"]+)"\)/g;
	let match;

	while ((match = routeRegex.exec(content)) !== null) {
		routes.push(match[1]);
	}

	return routes;
};

// Helper: Scan directory structure and extract route patterns from operations.tsp
const scanOperationsDirs = (baseDir = SRC_DIR) => {
	const result = new Map(); // Map: dirPath -> { routes: string[], tspPath: string }

	const scanDir = (dir, relativePath = "") => {
		if (!fs.existsSync(dir)) return false;

		const items = fs.readdirSync(dir, { withFileTypes: true });
		const operationsTsp = items.find(item => item.isFile() && item.name === "operations.tsp");

		if (operationsTsp) {
			const tspPath = path.join(dir, "operations.tsp");
			const routes = parseTspRoutes(tspPath);

			if (routes.length > 0) {
				result.set(relativePath || ".", {
					routes,
					tspPath,
					fullPath: dir
				});
			}
		}

		// Recursively scan subdirectories
		for (const item of items) {
			if (item.isDirectory() && !item.name.startsWith(".")) {
				const subPath = relativePath ? `${relativePath}/${item.name}` : item.name;
				scanDir(path.join(dir, item.name), subPath);
			}
		}

		return operationsTsp !== undefined;
	};

	scanDir(baseDir);
	return result;
};

// Helper: Find best matching directory for an API path
const findDirForPath = (apiPath, dirStructure) => {
	let bestMatch = null;
	let bestMatchLength = 0;

	for (const [dirPath, info] of dirStructure.entries()) {
		for (const route of info.routes) {
			// Convert route pattern to regex
			// e.g., "/orgs/{slug}/forms" -> /^\/orgs\/[^/]+\/forms/
			const routePattern = route
				.replace(/\{[^}]+\}/g, "[^/]+") // Replace path params with regex
				.replace(/\//g, "\\/"); // Escape slashes

			const regex = new RegExp(`^${routePattern}`);

			if (regex.test(apiPath)) {
				// Check if this is a more specific match
				if (route.length > bestMatchLength) {
					bestMatch = dirPath;
					bestMatchLength = route.length;
				}
			}
		}
	}

	return bestMatch;
};

// Helper: Resolve $ref in schema
const resolveRef = (ref, spec) => {
	if (!ref || !ref.startsWith("#/")) return null;
	const path = ref.substring(2).split("/");
	let result = spec;
	for (const part of path) {
		result = result[part];
		if (!result) return null;
	}
	return result;
};

// Helper: Extract example from schema
const getSchemaExample = (schema, spec) => {
	if (!schema) return null;

	// Check if schema has $ref
	if (schema.$ref) {
		const resolved = resolveRef(schema.$ref, spec);
		if (resolved) {
			return getSchemaExample(resolved, spec);
		}
	}

	// Check for examples array
	if (schema.examples && Array.isArray(schema.examples) && schema.examples.length > 0) {
		return schema.examples[0];
	}

	// Check for single example
	if (schema.example !== undefined) {
		return schema.example;
	}

	// Generate example from schema properties
	if (schema.type === "object" && schema.properties) {
		const example = {};
		for (const [propName, propSchema] of Object.entries(schema.properties)) {
			const propExample = getSchemaExample(propSchema, spec);
			if (propExample !== null) {
				example[propName] = propExample;
			} else if (propSchema.type === "string") {
				example[propName] = propSchema.format === "uuid" ? "00000000-0000-0000-0000-000000000000" : "";
			} else if (propSchema.type === "number" || propSchema.type === "integer") {
				example[propName] = 0;
			} else if (propSchema.type === "boolean") {
				example[propName] = propSchema.default ?? false;
			}
		}
		return Object.keys(example).length > 0 ? example : null;
	}

	return null;
};

// Helper: Extract path parameters and generate variable definitions
const extractPathParams = url => {
	const params = [];
	const regex = /{([^}]+)}/g;
	let match;
	while ((match = regex.exec(url)) !== null) {
		params.push(match[1]);
	}
	return params;
};

// Helper: Generate HTTP request text
const generateHttpRequest = (op, url, method, spec) => {
	const lines = [];

	// Add comment separator
	lines.push("###");
	lines.push("");

	// Add title and description
	if (op.summary) {
		lines.push(`# @title ${op.summary}`);
	}
	if (op.description) {
		lines.push(`# @description ${op.description}`);
	}

	// Generate URL with query parameters example
	const pathParams = extractPathParams(url);
	let httpUrl = url;

	// Replace path params with variables (keep original format)
	for (const param of pathParams) {
		httpUrl = httpUrl.replace(`{${param}}`, `{{${param}}}`);
	}

	// Check for query parameters
	const queryParams = [];
	if (Array.isArray(op.parameters)) {
		for (const p of op.parameters) {
			if (p.in === "query") {
				queryParams.push(p);
			}
		}
	}

	// Generate request line
	// Remove /api prefix since it's already in BASE_URL
	const urlWithoutApiPrefix = httpUrl.replace(/^\/api/, "");
	const fullUrl = `{{BASE_URL}}${urlWithoutApiPrefix}`;
	lines.push(`${method.toUpperCase()} ${fullUrl}`);

	// Add headers if request has body
	if (op.requestBody) {
		lines.push("Content-Type: application/json");
	}

	// Add body if present
	if (op.requestBody && op.requestBody.content) {
		const jsonContent = op.requestBody.content["application/json"];
		if (jsonContent && jsonContent.schema) {
			const example = getSchemaExample(jsonContent.schema, spec);
			if (example) {
				lines.push("");
				lines.push(JSON.stringify(example, null, 2));
			}
		}
	}

	lines.push("");

	return lines.join("\n");
};

// Helper: Generate variable definitions
const generateVariables = (operations, spec) => {
	const variables = new Set();

	for (const op of operations) {
		const pathParams = extractPathParams(op.url);
		for (const param of pathParams) {
			// Keep original param name format (with underscores)
			const varName = param;
			// Convert to SCREAMING_SNAKE_CASE for placeholder
			let displayName = param
				.replace(/([A-Z])/g, "_$1")
				.toUpperCase()
				.replace(/^_/, "");
			if (param === "id") {
				displayName = "ID";
			}
			variables.add(`@${varName} = {{${displayName}}}`);
		}
	}

	return Array.from(variables).sort().join("\n");
};

// Main function
const generateHttpFiles = () => {
	// Check if spec file exists
	if (!fs.existsSync(SPEC_FILE)) {
		console.error(`❌ Missing ${SPEC_FILE}`);
		console.error("Please run: pnpm run build:tsp");
		process.exit(1);
	}

	// Scan directory structure and parse routes
	console.log("📂 Scanning directory structure and parsing routes...");
	const dirStructure = scanOperationsDirs();
	console.log(`   Found ${dirStructure.size} directories with operations.tsp\n`);

	// Debug: show parsed routes
	for (const [dirPath, info] of dirStructure.entries()) {
		console.log(`   ${dirPath}: ${info.routes.join(", ")}`);
	}
	console.log();

	// Load OpenAPI spec
	const spec = yaml.load(fs.readFileSync(SPEC_FILE, "utf8"));

	// Group operations by target directory based on route matching
	const operationsByDir = new Map();

	for (const [url, methods] of Object.entries(spec.paths)) {
		for (const [method, op] of Object.entries(methods)) {
			// Remove /api prefix for matching (since TypeSpec routes don't have it)
			const pathForMatching = url.replace(/^\/api/, "");
			const targetDir = findDirForPath(pathForMatching, dirStructure);

			if (!targetDir) {
				console.warn(`⚠️  No matching directory for path: ${url}`);
				continue;
			}

			if (!operationsByDir.has(targetDir)) {
				operationsByDir.set(targetDir, []);
			}

			operationsByDir.get(targetDir).push({
				url,
				method,
				op
			});
		}
	}

	// Generate .http files for each directory
	for (const [dirPath, operations] of operationsByDir.entries()) {
		const targetPath = path.join(SRC_DIR, dirPath);

		if (!fs.existsSync(targetPath)) {
			console.warn(`⚠️  Directory does not exist: ${targetPath}`);
			continue;
		}

		// Generate content
		const variables = generateVariables(operations, spec);
		const requests = operations.map(({ url, method, op }) => generateHttpRequest(op, url, method, spec)).join("\n");

		const content = variables + "\n\n" + requests;

		// Write file
		const outputPath = path.join(targetPath, "operations.http");
		fs.writeFileSync(outputPath, content);
		console.log(`✅ Generated: ${outputPath}`);
	}

	console.log("\n🎉 HTTP files generated successfully!");
};

// Run
generateHttpFiles();
