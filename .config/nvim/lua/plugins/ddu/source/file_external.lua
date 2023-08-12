local function config()
  local map_source = require("plugins.ddu.map").map_source
  map_source("<Space>ff", "file_external", { sources = { { name = "file_external" } } }, true)
end

---@type LazySpec
local spec =
  { "matsui54/ddu-source-file_external", dependencies = { "Shougo/ddu.vim" }, config = config }
return spec
