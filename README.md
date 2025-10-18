# Core System API

Core System API documentation.

> [Chinese Version](README.zh.md)

## Dependencies

Please install [Node.js](https://nodejs.org/) and [pnpm](https://pnpm.io/) first.

pnpm installation:

```bash
npm install --global corepack@latest
corepack enable pnpm
```

## Install Packages

```bash
pnpm i
```

## Build

You need to compile after editing to preview.

```bash
pnpm build
```

<details>

<summary>Other Commands</summary>

### Format Check

```bash
pnpm format
```

### Compilation

#### OpenAPI

```bash
pnpm compile
```

#### Yaak

```bash
pnpm yaak
```

> You need to compile OpenAPI before compiling Yaak

### Clean Compiled Files

```bash
pnpm clean
```

</details>

## Output Files

The output files will be in `tsp-output/schema/openapi.yaml`. You can preview using:

- [Scalar](https://scalar.dev/api-reference/) - Just open the [index.html](index.html) file below.
-   [Swagger UI](https://nycu-sdc.github.io/core-system-api/) - Just open the [swagger.html](swagger.html) file below.
-   [Prism](https://prismjs.com/) - For API documentation preview and testing. Run `pnpm start` and open <http://localhost:4010>.
-   [Yaak](https://yaak.app/) - Import the `yaak` folder.
