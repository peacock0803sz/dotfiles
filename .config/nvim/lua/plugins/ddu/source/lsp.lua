local function config()
  local helper = require("plugins.ddu.map")
  helper.map_source("<Space>ff", "file_external", { sources = { { name = "file_external" } } })
end

local spec =
  { "uga-rosa/ddu-source-lsp", dependencies = { "Shougo/ddu.vim" }, config = config }

return spec
