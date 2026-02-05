import "@typespec/http";

using Http;

namespace CoreSystem {
  @format("uuid")
  scalar uuid extends string;
}
