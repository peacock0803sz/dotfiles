local function config()
  local helper = require("plugins.ddu.map").map_source
  helper("<Space>lw", "lsp_workspaceSymbol", {
    sources = { { name = "lsp_workspaceSymbol" } },
    sourceOptions = { lsp = { volatile = true } },
  })
  helper("<Space>lc", "lsp_callHierarchy/outgoingCalls", {
    sources = {
      {
        name = "lsp_callHierarchy",
        params = { methoed = "callHierarchy/outgoingCalls" },
      },
    },
    uiParams = { ff = { displayTree = true, startFilter = false } },
  })
end

---@type LazySpec
local spec = {
  "https://github.com/uga-rosa/ddu-source-lsp",
  dependencies = { "https://github.com/Shougo/ddu.vim" },
  config = config,
}
return spec
