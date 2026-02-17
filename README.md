# Core System API

[![Test Build and Format](https://github.com/NYCU-SDC/core-system-api/actions/workflows/test.yml/badge.svg)](https://github.com/NYCU-SDC/core-system-api/actions/workflows/test.yml) [![Release SDK](https://github.com/NYCU-SDC/core-system-api/actions/workflows/sdk.yml/badge.svg)](https://github.com/NYCU-SDC/core-system-api/actions/workflows/sdk.yml) [![npm version](https://badge.fury.io/js/%40nycu-sdc%2Fcore-system-sdk.svg)](https://www.npmjs.com/package/@nycu-sdc/core-system-sdk)

Core System API defined using TypeSpec.

```mermaid
flowchart TD
    A[pnpm clean<br/>Clean Generated Files]

    B[Write TypeSpec]
    C[pnpm format<br/>Prettier Formatting]

    D[compile:openapi<br/>Generate OpenAPI]
    E[patch-openapi.js<br/>Fix Type / Description]
    F[Official OpenAPI Spec]
    %% From TypeSpec to OpenAPI
    A --> B --> C --> D --> E --> F

    %% Mock
    F --> M[Prism Mock Server<br/>pnpm start:mock]

    %% Docs generation from OpenAPI
    F --> S[Swagger UI]
    F --> T[Scala]
    F --> Y[Yaak Collection<br/>build:yaak]
		F --> R[Redocly<br/>build:redocly]

    %% SDK generation
    F --> O[orval Generate SDK<br/>build:sdk]
    O --> CSDK[pnpm compile:sdk]
    CSDK --> NPM[Publish to npm]
    NPM --> FE[Frontend Repo<br/>Install Usage]

    %% SDK docs
    O --> TDOC[TypeDoc<br/>SDK Documentation build:typedoc]

    %% Deploy
    R --> GH[GitHub Pages]
    S --> GH
    T --> GH
    TDOC --> GH
```

## Dependencies

Please install [Node.js](https://nodejs.org/) and [pnpm](https://pnpm.io/) first.

pnpm installation:

```bash
npm install --global corepack@latest
corepack enable pnpm
```

## Install Packages

```bash
pnpm i --dev
```

> If you wanna build website and sdk, use `pnpm i` instead.

## Available Commands

### Format TypeSpec Files

```bash
pnpm format
```

Formats all TypeSpec (`.tsp`) files in the project.

### Compile OpenAPI Specification

```bash
pnpm compile:openapi
```

Compiles TypeSpec files to OpenAPI specification and applies patches. Output will be in `tsp-output/schema/openapi.1.0.0.yaml`.

### Build Yaak Collection

```bash
pnpm build:yaak
```

Generates Yaak API collection from the OpenAPI specification.

> **Note:** You must run `pnpm compile:openapi` before building Yaak collection.

### Build SDK

```bash
pnpm build:sdk
```

Generates the SDK client code from the OpenAPI specification using Orval.

> **Note:** You must run `pnpm compile:openapi` and install with `pnpm i` before building the SDK.

### Compile SDK Package

```bash
pnpm compile:sdk
```

Compiles the SDK TypeScript package (`@nycu-sdc/core-system-sdk`).

> **Note:** You must run `pnpm build:sdk` and install with `pnpm i` before compiling the SDK package.

### Full SDK Build Sequence

To build the SDK from scratch, run these commands in order:

```bash
pnpm compile:openapi
pnpm build:sdk
pnpm compile:sdk
```

### Start Mock Server

```bash
pnpm start:mock
```

Starts a Prism mock server on `http://0.0.0.0:4010` using the compiled OpenAPI specification.

> **Note:** You must run `pnpm compile:openapi` and install with `pnpm i` before starting the mock server.

### Build Documentation

```bash
pnpm build:redocly
```

Builds static HTML documentation using Redocly. Output will be in `website/index.html`.

> **Note:** You must run `pnpm compile:openapi` and install with `pnpm i` before building documentation.

### Build TypeDoc

```bash
pnpm build:typedoc
```

Generates TypeDoc documentation for the SDK. Output will be in `website/sdk`.

> **Note:** You must run `pnpm compile:sdk` and install with `pnpm i` before building TypeDoc.

### Clean Generated Files

```bash
pnpm clean
```

Removes all generated files including `tsp-output`, `yaak`, and SDK generated code.

## Output Files

### API Specification

The compiled OpenAPI specification will be in `tsp-output/schema/openapi.1.0.0.yaml`.

### Preview Tools

- **Scalar** - Open [website/index.html](https://nycu-sdc.github.io/core-system-api/) in your browser
- **Swagger UI** - Open [website/swagger.html](https://nycu-sdc.github.io/core-system-api/swagger.html) in your browser
- **Redoc** - Open [website/sdk/index.html](https://nycu-sdc.github.io/core-system-api/sdk) in your browser
- **Prism Mock Server** - Run `pnpm start:mock` and visit <http://localhost:4010>
- **Yaak** - Import the `yaak` folder into [Yaak](https://yaak.app/)

## SDK Package

The SDK is published as `@nycu-sdc/core-system-sdk` and located in `packages/sdk`.

### Publishing the SDK

```bash
git checkout main
git pull
git tag v1.0.0
git push origin v1.0.0
```

Publishing is handled automatically via CI/CD when a new tag is pushed.
