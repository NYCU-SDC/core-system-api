# Core System API

Core System 的 API 文件。

> [English Version](README.en.md)

## 依賴套件

請先安裝 [Node.js](https://nodejs.org/) 與 [pnpm](https://pnpm.io/)。

pnpm 安裝方式：

```bash
npm install --global corepack@latest
corepack enable pnpm
```

## 安裝套件

```bash
pnpm i
```

## 編譯

編輯完之後需要進行編譯才能預覽。

```bash
pnpm build
```

### 格式檢查

```bash
pnpm format
```

### 編譯

#### OpenAPI

```bash
pnpm compile
```

#### Yaak

```bash
pnpm yaak
```

> 編譯 Yaak 前需要先編譯 OpenAPI

### 清理已編譯文件

```bash
pnpm clean
```

## 輸出文件

輸出的文件會在 `tsp-output/schema/openapi.yaml`。你可以使用以下方式進行預覽：

-   [Swagger UI](https://nycu-sdc.github.io/core-system-api/) - 直接打開底下的 [swagger-ui.html](swagger-ui.html) 檔案即可。
-   [Prism](https://prismjs.com/) - 用於 API 文件的預覽和測試。執行 `pnpm start` 後，打開 <http://localhost:4010> 即可。

## Yaak 在幹嘛？

目前 Yaak 不會從 TypeSpec 抓資料，請單獨編輯維護。
